//
//  TableViewCell.h
//  RSSchool_T6
//
//  Created by Karina on 6/19/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UILabel *namelabel;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage;
@property (strong, nonatomic) IBOutlet UILabel *resolutionLabel;
@property (assign, nonatomic) PHImageRequestID imageRequestID;
@property (assign, nonatomic) PHContentEditingInputRequestID contentRequestID;
@property (copy, nonatomic) NSString *representedAssetIdentifier;

@end

NS_ASSUME_NONNULL_END
