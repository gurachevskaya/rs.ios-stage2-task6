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
@property (strong, nonatomic) UIImage *sharingImage;

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

    PHContentEditingInputRequestOptions *editOptions = [[PHContentEditingInputRequestOptions alloc] init];
         [self.asset requestContentEditingInputWithOptions:editOptions completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
             if (contentEditingInput.fullSizeImageURL) {
             self.navigationItem.title = [contentEditingInput.fullSizeImageURL lastPathComponent];
             }
         }];
    [self conFigureImageView];
    [self configureLabels];
    [self configureButton];
}


-(void)conFigureImageView {
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    
    if (self.asset.mediaType == PHAssetMediaTypeImage || self.asset.mediaType == PHAssetMediaTypeVideo) {
        [self.imageManager requestImageForAsset:self.asset targetSize:self.imageView.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info)
         {
            self.sharingImage = result;
            self.imageView.image = result;
        }];
    }
    
    if (self.asset.mediaType == PHAssetMediaTypeAudio) {
        self.imageView.image = [UIImage imageNamed:@"icons8-musical-100"];
    }
    if (self.asset.mediaType == PHAssetMediaTypeUnknown) {
        self.imageView.image =  [UIImage imageNamed:@"icons8-minus-128"];
    }
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
    if (self.asset.mediaType == PHAssetMediaTypeAudio || self.asset.mediaType == PHAssetMediaTypeUnknown) {
        self.shareButton.hidden = YES;
    }
}

- (IBAction)CustomButtonTapped:(id)sender {
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.sharingImage] applicationActivities:nil];
    
    UIDevice *device = [[UIDevice alloc] init];
    //if iPad
    if ( !(device.userInterfaceIdiom == UIUserInterfaceIdiomPhone)) {
        if ([sender isKindOfClass:[UIView class]]) {
            activityVC.popoverPresentationController.sourceView = [sender superview];
            activityVC.popoverPresentationController.sourceRect = [sender frame];
        }
    }
    [self presentViewController:activityVC animated:YES completion:nil];
}
       
@end
