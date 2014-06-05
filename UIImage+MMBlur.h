//
//  UIImage+MMBlur.h
//  MBProgressHUD
//
//  Created by Aidian.Tang on 14-6-5.
//  Copyright (c) 2014年 Matej Bukovinski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MMBlur)

- (UIImage *)applyBlurWithCrop:(CGRect) bounds resize:(CGSize) size blurRadius:(CGFloat) blurRadius tintColor:(UIColor *) tintColor saturationDeltaFactor:(CGFloat) saturationDeltaFactor maskImage:(UIImage *) maskImage;

@end

@interface MMBlurComponents : NSObject

@property(nonatomic) CGFloat radius;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, assign) CGFloat saturationDeltaFactor;
@property(nonatomic) UIImage *maskImage;

///Light color effect.
+ (MMBlurComponents *) lightEffect;

///Dark color effect.
+ (MMBlurComponents *) darkEffect;

///Coral color effect.
+ (MMBlurComponents *) coralEffect;

///Neon color effect.
+ (MMBlurComponents *) neonEffect;

///Sky color effect.
+ (MMBlurComponents *) skyEffect;

@end
