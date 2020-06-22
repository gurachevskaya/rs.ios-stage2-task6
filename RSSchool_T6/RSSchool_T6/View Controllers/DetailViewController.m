//
//  DetailViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/22/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+ColorFromRGB.h"

@interface DetailViewController ()
- (IBAction)CustomButtonTapped:(id)sender;


@end

@implementation DetailViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asset:(PHAsset *)asset {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _asset = asset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorFromRGBNumber:@0x101010];

    self.imageManager = [[PHCachingImageManager alloc] init];
    [self.imageManager requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info)
               {
        self.imageView.image = result;
//        [self.imageView.heightAnchor constraintEqualToConstant:result.size.height].active = YES;

               }];
    
    [self configureLabels];
    [self configureButton];
}

-(void)configureLabels {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss dd:MM:yyyy"];
    
    NSString *creationDateString = [dateFormatter stringFromDate:self.asset.creationDate];
    self.creationDateValueLabel.text = creationDateString;
    NSString *modificationDateString = [dateFormatter stringFromDate:self.asset.modificationDate];
    self.modificationDateValueLabel.text = modificationDateString;
    
    switch (self.asset.mediaType) {
        case PHAssetMediaTypeUnknown:
            self.typeLabel.text = @"Unknown";
            break;
        case PHAssetMediaTypeImage:
            self.typeLabel.text = @"Image";
            break;
        case PHAssetMediaTypeVideo:
            self.typeLabel.text = @"Video";
            break;
        case PHAssetMediaTypeAudio:
            self.typeLabel.text = @"Audio";
            break;
    }
}

-(void)configureButton {
    
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton setBackgroundColor:[UIColor colorFromRGBNumber:@0xF9CC78]];
    [self.shareButton setTitleColor:[UIColor colorFromRGBNumber:@0x101010] forState:UIControlStateNormal];
        
}

- (IBAction)CustomButtonTapped:(id)sender {
    NSLog(@"Tapped");

}
@end
