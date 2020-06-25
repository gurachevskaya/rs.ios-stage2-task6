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
    
    self.dataSource = [NSMutableArray array];
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           PHFetchOptions *options = [[PHFetchOptions alloc] init];
           options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
           
           self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
           
           for (int i = 0; i < self.assetsFetchResults.count; i++) {
               [self.dataSource addObject:self.assetsFetchResults[i]];
           }
           dispatch_async(dispatch_get_main_queue(), ^{
              [self.collectionView reloadData];
                 });
       });
        }];
            
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [self.collectionView reloadData];
//       });
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = self.dataSource[indexPath.row];

    [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
               {
                   cell.previewImageView.image = result;
               }];
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.dataSource[indexPath.row];
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
