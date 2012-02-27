//
//  UIImage+animatedImageWithGIF.m
//
//  Created by YuAo on 2/24/12.
//  Copyright (c) 2012 eico design. All rights reserved.
//

#import "UIImageView+imageViewWithGIF.h"
#import <ImageIO/ImageIO.h>

#if __has_feature(objc_arc)
    #define toCF (__bridge CFTypeRef)
    #define ARCCompatibleAutorelease(object) object
#else
    #define toCF (CFTypeRef)
    #define ARCCompatibleAutorelease(object) [object autorelease]
#endif

@implementation UIImageView(animatedImageViewWithGIF)

+ (UIImageView *)imageViewWithAnimatedGIFImageSource:(CGImageSourceRef) source 
                                         andDuration:(NSTimeInterval) duration {
    if (!source) return nil;
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:count];
    for (size_t i = 0; i < count; ++i) {
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!cgImage)
            return nil;
        [images addObject:[UIImage imageWithCGImage:cgImage]];
        CGImageRelease(cgImage);
    }
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setAnimationImages:images];
    [imageView setAnimationDuration:duration];
    [imageView sizeToFit];
    [imageView startAnimating];
    return ARCCompatibleAutorelease(imageView);
}

+ (UIImageView *)imageViewWithAnimatedGIFReleasingImageSource:(CGImageSourceRef) source 
                                                  andDuration:(NSTimeInterval) duration {
    UIImageView *imageView = [UIImageView imageViewWithAnimatedGIFImageSource:source andDuration:duration]; 
    CFRelease(source);
    return imageView;
}

+ (NSTimeInterval)durationForGifData:(NSData *)data {
    char graphicControlExtensionStartBytes[] = {0x21,0xF9,0x04};
    double duration=0;
    NSRange dataSearchLeftRange = NSMakeRange(0, data.length);
    while(YES){
        NSRange frameDescriptorRange = [data rangeOfData:[NSData dataWithBytes:graphicControlExtensionStartBytes 
                                                                        length:3] 
                                                 options:NSDataSearchBackwards
                                                   range:dataSearchLeftRange];
        if(frameDescriptorRange.location!=NSNotFound){
            NSData *durationData = [data subdataWithRange:NSMakeRange(frameDescriptorRange.location+4, 2)];
            unsigned char buffer[2];
            [durationData getBytes:buffer];
            double delay = (buffer[0] | buffer[1] << 8);
            duration += delay;
            dataSearchLeftRange = NSMakeRange(0, frameDescriptorRange.location);
        }else{
            break;
        }
    }
    return duration/100;
}

+ (UIImageView *)imageViewWithGIFData:(NSData *)data{
    NSTimeInterval duration = [self durationForGifData:data];
    return [UIImageView imageViewWithAnimatedGIFReleasingImageSource:CGImageSourceCreateWithData(toCF data, NULL) 
                                                         andDuration:duration];
}

+ (UIImageView *)imageViewWithGIFURL:(NSURL *)url{
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSTimeInterval duration = [self durationForGifData:data];
    return [UIImageView imageViewWithAnimatedGIFReleasingImageSource:CGImageSourceCreateWithData(toCF data, NULL) 
                                                         andDuration:duration];
}

@end
