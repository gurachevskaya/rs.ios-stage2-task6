//
//  ModalViewController.h
//  RSSchool_T6
//
//  Created by Karina on 6/24/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModalViewController : UIViewController

@property (strong, nonatomic) PHAsset *asset;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
