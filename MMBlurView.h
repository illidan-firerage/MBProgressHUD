//
//  MMBlurView.h
//  MBProgressHUD
//
//  Created by Aidian.Tang on 14-6-5.
//  Copyright (c) 2014年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MMBlurUndefined = 0,
    MMStaticBlur = 1,
    MMLiveBlur = 2
} MMBlurType;

@class MMBlurComponents;

@interface MMBlurView : UIView

+ (MMBlurView *) load:(UIView *) view;
+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view;
+ (MMBlurView *) loadWithLocation:(CGPoint) point parent:(UIView *) view frame:(CGRect)frame;
- (void) unload;
- (void) blurWithColor:(MMBlurComponents *) components;
//For realtime animate
- (void) blurWithColor:(MMBlurComponents *) components updateInterval:(float) interval;

@end
