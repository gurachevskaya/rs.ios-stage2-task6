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
#import <AVKit/AVKit.h>


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
        
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
//    requestOptions.synchronous = YES;
    // requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
     [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    __weak typeof(cell) weakCell = cell;
    cell.imageRequestID = [self.imageManager requestImageForAsset:asset targetSize:cell.previewImageView.frame.size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakCell.previewImageView.image = result;
        });
    }];
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetsFetchResults[indexPath.row];
    
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [self presentViewController:[[ModalViewController alloc] initWithAsset:asset] animated:YES completion:nil];
        
    } else if (asset.mediaType == PHAssetMediaTypeVideo) {
        [self.imageManager requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
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
}
    
//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PHImageRequestID requestId = ((ImageCollectionViewCell *)cell).imageRequestID;
//    if(requestId != 0)
//    {
//        [self.imageManager cancelImageRequest:requestId];
//       // [((ImageCollectionViewCell *)cell).previewImageView setImage:nil];
//    }
//}

#pragma mark - UICollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    double sizeOfItem = collectionView.frame.size.width / 3.0;
    double resultSizeOfItem = sizeOfItem - 15;
    return  CGSizeMake (resultSizeOfItem, resultSizeOfItem);
}

//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//
//    [self.collectionView.collectionViewLayout invalidateLayout];
//}

@end
