//
//  InfoTableViewController.h
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


NS_ASSUME_NONNULL_BEGIN

@interface InfoTableViewController : UITableViewController

@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

NS_ASSUME_NONNULL_END
