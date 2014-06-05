//
//  MMBlurView.m
//  MBProgressHUD
//
//  Created by Aidian.Tang on 14-6-5.
//  Copyright (c) 2014年 Matej Bukovinski. All rights reserved.
//

#import "MMBlurView.h"
#import "UIImage+MMBlur.h"

@interface MMBlurView ()

@property(nonatomic, weak) UIView *parent;
@property(nonatomic, assign) CGPoint location;
@property(nonatomic, assign) MMBlurType blurType;
@property(nonatomic, strong) MMBlurComponents *colorComponents;
@property(nonatomic, strong) UIImageView *backgroundImageView;
@property(nonatomic, assign) dispatch_source_t timer;

@end

@implementation MMBlurView

- (void)dealloc{
    self.backgroundImageView = nil;
    self.colorComponents = nil;
}

+ (MMBlurView *) load:(UIView *) view {
    MMBlurView *blur = [[MMBlurView alloc]initWithFrame:CGRectZero];
    blur.parent = view;
    blur.location = CGPointMake(0, 64);
    blur.frame = CGRectMake(blur.location.x, -(blur.frame.size.height + blur.location.y), blur.frame.size.width, blur.frame.size.height);
    
    return blur;
}

+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view {
    MMBlurView *blur = [[MMBlurView alloc]initWithFrame:CGRectZero];
    blur.parent = view;
    blur.location = point;
    blur.frame = CGRectMake(0, 0, blur.frame.size.width, blur.frame.size.height);
    return blur;
}

+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view frame:(CGRect)frame{
    MMBlurView *blur = [[MMBlurView alloc]initWithFrame:CGRectZero];
    blur.parent = view;
    blur.location = point;
    return blur;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.backgroundImageView];
        self.backgroundImageView.layer.cornerRadius = 10.0;
        self.backgroundImageView.clipsToBounds = YES;
        self.backgroundImageView.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void) unload {
    if(self.timer != nil) {
        
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    [self removeFromSuperview];
}

- (void) blurBackground {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1);
    
    //Snapshot finished in 0.051982 seconds.
    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];
    
    __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //Blur finished in 0.004884 seconds.
        snapshot = [snapshot applyBlurWithCrop:CGRectMake(self.location.x, self.location.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) resize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) blurRadius:self.colorComponents.radius tintColor:self.colorComponents.tintColor saturationDeltaFactor:self.colorComponents.saturationDeltaFactor maskImage:self.colorComponents.maskImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.backgroundImageView.image = snapshot;
        });
    });
}

- (void) blurWithColor:(MMBlurComponents *) components {
    if(self.blurType == MMBlurUndefined) {
        self.blurType = MMStaticBlur;
        self.colorComponents = components;
    }
    
    [self blurBackground];
}

- (void) blurWithColor:(MMBlurComponents *) components updateInterval:(float) interval {
    self.blurType = MMLiveBlur;
    self.colorComponents = components;
    
    self.timer = DispatchTimer(interval * NSEC_PER_SEC, 1ull * NSEC_PER_SEC, dispatch_get_main_queue(), ^{[self blurWithColor:components];});
}

dispatch_source_t DispatchTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block) {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (timer) {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        
        dispatch_resume(timer);
    }
    
    return timer;
}

@end
