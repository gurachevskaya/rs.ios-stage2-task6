//
//  TableViewCell.m
//  RSSchool_T6
//
//  Created by Karina on 6/19/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "TableViewCell.h"
#import "UIColor+ColorFromRGB.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
            
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorFromRGBNumber:@0xFDF4E3];
    [self setSelectedBackgroundView:bgColorView];

}


@end
