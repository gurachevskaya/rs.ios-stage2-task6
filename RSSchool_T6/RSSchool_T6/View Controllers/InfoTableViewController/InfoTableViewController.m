//
//  InfoTableViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "InfoTableViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"

@interface InfoTableViewController ()
@property(strong, nonatomic) NSDateComponentsFormatter *formatter;

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Info";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    [self configureFormatter];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            
            weakSelf.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        });
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assetsFetchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = self.assetsFetchResults[indexPath.row];
        
    __weak typeof(cell) weakCell = cell;
    cell.contentRequestID = [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
        if (contentEditingInput.fullSizeImageURL) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakCell.namelabel.text = [contentEditingInput.fullSizeImageURL lastPathComponent];
            });
        }
    }];
    
     cell.imageRequestID = [self.imageManager requestImageForAsset:asset targetSize:cell.mainImage.image.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info){
         dispatch_async(dispatch_get_main_queue(), ^{
             weakCell.mainImage.image = result;
         });
     }];
    
    switch (asset.mediaType) {
        case PHAssetMediaTypeUnknown: {
            cell.smallImage.image = [UIImage imageNamed:@"other"];
            cell.mainImage.image = [UIImage imageNamed:@"icons8-minus-128"];
            cell.resolutionLabel.text = @"";
            break;
        }
        case PHAssetMediaTypeImage: {
            cell.smallImage.image = [UIImage imageNamed:@"image"];
            cell.resolutionLabel.text = [NSString stringWithFormat:@"%lux%lu",(unsigned long)asset.pixelWidth, asset.pixelHeight];
            break;
        }
        case PHAssetMediaTypeVideo: {
            cell.smallImage.image = [UIImage imageNamed:@"video"];
            cell.resolutionLabel.text = [NSString stringWithFormat:@"%lux%lu %@",(unsigned long)asset.pixelWidth, asset.pixelHeight, [self.formatter stringFromTimeInterval:asset.duration]];
            break;
        }
        case PHAssetMediaTypeAudio: {
            cell.smallImage.image = [UIImage imageNamed:@"audio"];
            cell.mainImage.image = [UIImage imageNamed:@"icons8-musical-100"];
            cell.resolutionLabel.text = [NSString stringWithFormat:@"%@", [self.formatter stringFromTimeInterval:asset.duration]];
            break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     PHAsset *asset = self.assetsFetchResults[indexPath.item];

    [self.navigationController pushViewController:[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle] asset:asset] animated:YES];
}

//#pragma mark - Table view delegate
//
//-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    {
//        PHAsset *asset = self.assetsFetchResults[indexPath.row];
//
//        PHImageRequestID imageRequestID = ((TableViewCell *)cell).imageRequestID;
//        PHContentEditingInputRequestID contentRequestID = ((TableViewCell *)cell).contentRequestID;
//        if(imageRequestID != 0)
//        {
//            [self.imageManager cancelImageRequest:imageRequestID];
//            [((TableViewCell *)cell).imageView setImage:nil];
//        }
//        if(contentRequestID != 0)
//        {
//            [asset cancelContentEditingInputRequest:contentRequestID];
//            ((TableViewCell *)cell).namelabel.text = @"";
//            ((TableViewCell *)cell).resolutionLabel.text = @"";
//        }
//    }
//}


#pragma mark - Helpers

-(void) configureFormatter {
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    formatter.allowedUnits = (NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour);
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    self.formatter = formatter;
}

#pragma mark - PHPhotoLibraryChangeObserver

//- (void)photoLibraryDidChange:(nonnull PHChange *)changeInstance {
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        PHFetchOptions *options = [[PHFetchOptions alloc] init];
//        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
//
//        self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//
//    });

//    PHFetchResultChangeDetails *details = [[PHFetchResultChangeDetails alloc] init];
//    details.fetchResultAfterChanges
//    + (instancetype)changeDetailsFromFetchResult:(PHFetchResult<ObjectType> *)fromResult toFetchResult:(PHFetchResult<ObjectType> *)toResult changedObjects:(NSArray<ObjectType> *)changedObjects;

   // guard let collectionView = self.collectionView else { return }
    // Change notifications may be made on a background queue.
    // Re-dispatch to the main queue to update the UI.
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//          // Check for changes to the displayed album itself
//                 // (its existence and metadata, not its member assets).
//        self.assetsFetchResults = [self.assetsFetchResults ]
//


//
//       });
//

//        if let albumChanges = changeInstance.changeDetails(for: assetCollection) {
//            // Fetch the new album and update the UI accordingly.
//            assetCollection = albumChanges.objectAfterChanges! as! PHAssetCollection
//            navigationController?.navigationItem.title = assetCollection.localizedTitle
//        }
//        // Check for changes to the list of assets (insertions, deletions, moves, or updates).
//        if let changes = changeInstance.changeDetails(for: fetchResult) {
//            // Keep the new fetch result for future use.
//            fetchResult = changes.fetchResultAfterChanges
//            if changes.hasIncrementalChanges {
//                // If there are incremental diffs, animate them in the collection view.
//                collectionView.performBatchUpdates({
//                    // For indexes to make sense, updates must be in this order:
//                    // delete, insert, reload, move
//                    if let removed = changes.removedIndexes where removed.count > 0 {
//                        collectionView.deleteItems(at: removed.map { IndexPath(item: $0, section:0) })
//                    }
//                    if let inserted = changes.insertedIndexes where inserted.count > 0 {
//                        collectionView.insertItems(at: inserted.map { IndexPath(item: $0, section:0) })
//                    }
//                    if let changed = changes.changedIndexes where changed.count > 0 {
//                        collectionView.reloadItems(at: changed.map { IndexPath(item: $0, section:0) })
//                    }
//                    changes.enumerateMoves { fromIndex, toIndex in
//                        collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
//                                                to: IndexPath(item: toIndex, section: 0))
//                    }
//                })
//            } else {
//                // Reload the collection view if incremental diffs are not available.
//                collectionView.reloadData()
//            }
//        }

//self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
//   dispatch_async(dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });



    

@end

