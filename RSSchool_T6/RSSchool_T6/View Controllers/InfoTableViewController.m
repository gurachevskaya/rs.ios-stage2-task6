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

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Info";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"customCell"];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    self.assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
       
    self.imageManager = [[PHCachingImageManager alloc] init];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.assetsFetchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"customCell" forIndexPath:indexPath];
    
    PHAsset *asset = self.assetsFetchResults[indexPath.item];
    
//  [self requestFileNameForAssets:asset resultHandler:^(NSString * _Nullable result) {
//      [cell.namelabel setText:result];
//  }];

    
    switch (asset.mediaType) {
        case PHAssetMediaTypeUnknown: {
            cell.smallImage.image = [UIImage imageNamed:@"other"];
            break;
        }
        case PHAssetMediaTypeImage: {
            cell.smallImage.image = [UIImage imageNamed:@"image"];
            [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
            {
                NSLog(@"%@", info);
                cell.mainImage.image = result;
            }];
            break;
        }
        case PHAssetMediaTypeVideo: {
            cell.smallImage.image = [UIImage imageNamed:@"video"];
            break;
        }
        case PHAssetMediaTypeAudio: {
            cell.smallImage.image = [UIImage imageNamed:@"audio"];
            break;
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     PHAsset *asset = self.assetsFetchResults[indexPath.item];

    [self.navigationController pushViewController:[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil asset:asset] animated:YES];

  //  [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil asset:asset];
    
}

-(void) requestFileNameForAssets:(PHAsset*)asset resultHandler:(void (^)(NSString *_Nullable result))handler {
    
    [self.imageManager requestImageDataAndOrientationForAsset:asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
        if ([info objectForKey:@"PHImageFileURLKey"]) {
            // path looks like this -
            // file:///var/mobile/Media/DCIM/###APPLE/IMG_####.JPG
            NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
            handler ([path lastPathComponent]);
        }
    }];
}


@end
