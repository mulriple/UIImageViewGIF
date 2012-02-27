//
//  UIImage+animatedImageWithGIF.h
//
//  Created by YuAo on 2/24/12.
//  Copyright (c) 2012 eico design. All rights reserved.
//
//  Note: 
//        ImageIO.framework is needed.
//        This lib is only available on iOS 4+

#import <Foundation/Foundation.h>

@interface UIImageView(animatedImageViewWithGIF)
+ (UIImageView *)imageViewWithGIFData:(NSData *)data;
+ (UIImageView *)imageViewWithGIFURL:(NSURL *)url;
@end
