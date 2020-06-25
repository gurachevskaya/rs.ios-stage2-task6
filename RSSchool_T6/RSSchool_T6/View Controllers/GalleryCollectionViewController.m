//
//  GalleryCollectionViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/21/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "GalleryCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "ModalViewController.h"

@interface GalleryCollectionViewController ()

@end

@implementation GalleryCollectionViewController

static NSString * const reuseIdentifier = @"imageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Gallery";
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            weakSelf.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
            });
        });
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetsFetchResults count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = self.assetsFetchResults[indexPath.row];

    [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
               {
                   cell.previewImageView.image = result;
               }];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetsFetchResults[indexPath.row];
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaType == PHAssetMediaTypeImage) {
        [self presentViewController:[[ModalViewController alloc] initWithAsset:asset] animated:YES completion:nil];
    }
}
    
#pragma mark - UICollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double sizeOfItem = collectionView.frame.size.width / 3.0;
    double resultSizeOfItem = sizeOfItem - 15;
    return  CGSizeMake (resultSizeOfItem, resultSizeOfItem);
}

@end
