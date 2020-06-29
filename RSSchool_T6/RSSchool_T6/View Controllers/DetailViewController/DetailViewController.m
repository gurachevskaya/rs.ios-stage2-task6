//
//  DetailViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/22/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "DetailViewController.h"
#import "UIColor+ColorFromRGB.h"
#import <AVKit/AVKit.h>


@interface DetailViewController ()
- (IBAction)CustomButtonTapped:(id)sender;
@property (strong, nonatomic) UIImage *sharingImage;
@property (strong, nonatomic) AVPlayerItem *sharingVideo;

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
    
    __weak typeof(self) weakSelf = self;
         [self.asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
             if (contentEditingInput.fullSizeImageURL) {
             weakSelf.navigationItem.title = [contentEditingInput.fullSizeImageURL lastPathComponent];
             }
         }];
    
    [self conFigureImageView];
    [self configureLabels];
    [self configureButton];
}

-(void)conFigureImageView {
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    __weak typeof(self) weakSelf = self;
    if (self.asset.mediaType == PHAssetMediaTypeImage || self.asset.mediaType == PHAssetMediaTypeVideo) {
        
        if (self.asset.mediaType == PHAssetMediaTypeVideo) {
            self.playButton.hidden = NO;
        }
        
        [self.imageManager requestImageForAsset:self.asset targetSize:self.imageView.bounds.size contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *result, NSDictionary *info)
         {
            weakSelf.sharingImage = result;
            weakSelf.imageView.image = result;
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

- (IBAction)playVideoButtonClicked:(id)sender {
    [self playVideo];
}

- (IBAction)CustomButtonTapped:(id)sender {
    
    UIActivityViewController *activityVC;
    
    activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.sharingImage] applicationActivities:nil];
    
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

-(void) playVideo {
    
    [self.imageManager requestPlayerItemForVideo:self.asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            playerViewController.player = player;
            [self presentViewController:playerViewController animated:YES completion:^{
                [playerViewController.player play];
            }];
        });
    }];
}
       
@end
