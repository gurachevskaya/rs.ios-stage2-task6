//
//  DetailViewController.h
//  RSSchool_T6
//
//  Created by Karina on 6/22/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *creationDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *modificationDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeTextLabel;
@property (strong, nonatomic) IBOutlet CustomButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) IBOutlet UILabel *creationDateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *modificationDateValueLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@property(nonatomic , strong) PHCachingImageManager *imageManager;


-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asset:(PHAsset *)asset;


@end

NS_ASSUME_NONNULL_END
