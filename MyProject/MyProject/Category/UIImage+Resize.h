// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

+ (UIImage *)blurryImage:(UIImage *)image
           withBlurLevel:(CGFloat)blur;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


//裁剪成圆形图片
+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;

@end
