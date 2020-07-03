//
//  ImageCollectionViewCell.h
//  RSSchool_T6
//
//  Created by Karina on 6/23/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *previewImageView;
@property (assign, nonatomic) PHImageRequestID imageRequestID;
@property (copy, nonatomic) NSString *representedAssetIdentifier;

@end

NS_ASSUME_NONNULL_END
