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


@interface GalleryCollectionViewController () <PHPhotoLibraryChangeObserver>

@end

@implementation GalleryCollectionViewController

static NSString * const reuseIdentifier = @"imageCell";

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Gallery";
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

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


- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.assetsFetchResults count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    cell.representedAssetIdentifier = asset.localIdentifier;

    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    // requestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
     [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    __weak typeof(cell) weakCell = cell;
    cell.imageRequestID = [self.imageManager requestImageForAsset:asset targetSize:cell.previewImageView.frame.size contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
        if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakCell.previewImageView.image = result;
            });
        }
    }];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(nonnull PHChange *)changeInstance {
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    //Change notifications may be made on a background queue. Re-dispatch to the main queue before acting on the change as we'll be updating the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            [collectionView reloadData];
        } else {
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[self indexPathsFromIndexSet:removedIndexes]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[self indexPathsFromIndexSet:insertedIndexes]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[self indexPathsFromIndexSet:changedIndexes]];
                }
            } completion:NULL];
        }
    });
}


- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [paths addObject:[NSIndexPath indexPathForItem:index inSection:0]];
    }];
    return paths;
}

@end
