//
//  DemoViewController.m
//  UIImageViewGIF
//
//  Created by YuAo on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DemoViewController.h"
#import "UIImageView+imageViewWithGIF.h"

@implementation DemoViewController

- (void)loadView {
    UIView *mainView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    mainView.backgroundColor = [UIColor whiteColor];
    
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] 
                                     pathForResource:@"demo"
                                              ofType:@"gif"]];
    UIImageView *imageView = [UIImageView imageViewWithGIFData:gifData];

    [mainView addSubview:imageView];
    self.view = mainView;
}


@end
