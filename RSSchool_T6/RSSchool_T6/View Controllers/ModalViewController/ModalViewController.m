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
    self.fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    [imageManager requestImageForAsset:self.asset targetSize:self.fullImageView.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info)
     {
        self.fullImageView.image = result;
    }];
    
    self.fullImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (@available(iOS 13.0, *)) {
        self.closeButton = [UIButton buttonWithType:UIButtonTypeClose];
    } else {
        self.closeButton = [[UIButton alloc] init];
        self.closeButton.backgroundColor = [UIColor whiteColor];
        [self.closeButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    float aspectRatio = self.fullImageView.image.size.height/self.fullImageView.image.size.width;

    [NSLayoutConstraint activateConstraints:@[
        [self.closeButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.closeButton.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10],
        [self.closeButton.widthAnchor constraintEqualToConstant:40],
        [self.closeButton.heightAnchor constraintEqualToConstant:40],
        
        [self.fullImageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.fullImageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:10],

        [self.fullImageView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:10],
        [self.fullImageView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor constant:-10],
        [self.fullImageView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:50],
        [self.fullImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:-50],
        [self.fullImageView.heightAnchor constraintEqualToAnchor:self.fullImageView.widthAnchor multiplier:aspectRatio]

    ]];
}

-(void)closeButtonTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
