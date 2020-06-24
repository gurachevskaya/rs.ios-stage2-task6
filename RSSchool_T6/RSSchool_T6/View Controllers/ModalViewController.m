//
//  ModalViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/24/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "ModalViewController.h"
#import "UIColor+ColorFromRGB.h"

@interface ModalViewController ()
@property (strong, nonatomic) UIButton *closeButton;
@property (strong,  nonatomic) UIImageView *fullImageView;

@end

@implementation ModalViewController

- (instancetype)initWithAsset:(PHAsset *)asset;
{
    self = [super init];
    if (self) {
        _asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorFromRGBNumber:@0xFFFFFF];
    self.fullImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.fullImageView ];
    self.fullImageView.contentMode = UIViewContentModeScaleToFill;
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:self.asset targetSize:self.fullImageView.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info)
     {
        self.fullImageView.image = result;
    }];
    
    self.fullImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeClose];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    
    [NSLayoutConstraint activateConstraints:@[
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10],
        [self.closeButton.widthAnchor constraintEqualToConstant:40],
        [self.closeButton.heightAnchor constraintEqualToConstant:40],
        
        [self.fullImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:10],
        [self.fullImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.fullImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:10],
        [self.fullImageView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:50],
        [self.fullImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:-50],
    ]];
}

-(void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
