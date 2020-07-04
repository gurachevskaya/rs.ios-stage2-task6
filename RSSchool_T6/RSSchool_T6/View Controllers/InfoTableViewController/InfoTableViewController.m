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

@interface InfoTableViewController () <PHPhotoLibraryChangeObserver>
@property(strong, nonatomic) NSDateComponentsFormatter *formatter;
@end

@implementation InfoTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Info";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    [self configureFormatter];
    
    __weak typeof(self) weakSelf = self;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (PHAuthorizationStatusAuthorized) {

            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                PHFetchOptions *options = [[PHFetchOptions alloc] init];
                options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
                
                weakSelf.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            });
        } else {
            
        }
    }];
}


- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assetsFetchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
        
    self.imageManager = [[PHCachingImageManager alloc] init];
    PHAsset *asset = self.assetsFetchResults[indexPath.row];
    cell.representedAssetIdentifier = asset.localIdentifier;
        
    __weak typeof(cell) weakCell = cell;
    
     cell.imageRequestID = [self.imageManager requestImageForAsset:asset targetSize:cell.mainImage.image.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info){
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
               weakCell.mainImage.image = result;
               weakCell.namelabel.text = [asset valueForKey:@"filename"];
             }
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     PHAsset *asset = self.assetsFetchResults[indexPath.item];

    [self.navigationController pushViewController:[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:[NSBundle mainBundle] asset:asset] animated:YES];
}


#pragma mark - Helpers

- (void)configureFormatter {
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    formatter.allowedUnits = (NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour);
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    self.formatter = formatter;
}


#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(nonnull PHChange *)changeInstance {
    
    PHFetchResultChangeDetails *tableChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (tableChanges == nil) {
        return;
    }
    
    //Change notifications may be made on a background queue. Re-dispatch to the main queue before acting on the change as we'll be updating the UI.
    dispatch_async(dispatch_get_main_queue(), ^{

        self.assetsFetchResults = [tableChanges fetchResultAfterChanges];
        
        UITableView *tableView = self.tableView;
        
        if (![tableChanges hasIncrementalChanges] || [tableChanges hasMoves]) {
           
            [tableView reloadData];
            
        } else {
           
            if (@available(iOS 11.0, *)) {
                [tableView performBatchUpdates:^{
                    NSIndexSet *removedIndexes = [tableChanges removedIndexes];
                    if ([removedIndexes count] > 0) {
                        [tableView deleteRowsAtIndexPaths:[self indexPathsFromIndexSet:removedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    NSIndexSet *insertedIndexes = [tableChanges insertedIndexes];
                    if ([insertedIndexes count] > 0) {
                        [tableView insertRowsAtIndexPaths:[self indexPathsFromIndexSet:insertedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    NSIndexSet *changedIndexes = [tableChanges changedIndexes];
                    if ([changedIndexes count] > 0) {
                        [tableView reloadRowsAtIndexPaths:[self indexPathsFromIndexSet:changedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                } completion:NULL];
            } else {
                // Fallback on earlier versions
                NSIndexSet *removedIndexes = [tableChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [tableView deleteRowsAtIndexPaths:[self indexPathsFromIndexSet:removedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                NSIndexSet *insertedIndexes = [tableChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [tableView insertRowsAtIndexPaths:[self indexPathsFromIndexSet:insertedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
                NSIndexSet *changedIndexes = [tableChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [tableView reloadRowsAtIndexPaths:[self indexPathsFromIndexSet:changedIndexes] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    });
}


- (NSArray *)indexPathsFromIndexSet:(NSIndexSet *)indexSet {
    NSMutableArray *paths = [[NSMutableArray alloc] init];
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [paths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
    }];
    return paths;
}

@end

