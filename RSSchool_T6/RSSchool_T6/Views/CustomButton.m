//
//  CustomButton.m
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CustomButton.h"
#import "UIColor+ColorFromRGB.h"
#import "Constants.h"

@implementation CustomButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    self.layer.cornerRadius = 27;
    self.clipsToBounds = YES;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.heightAnchor constraintEqualToConstant:kButtonHeight],
        [self.widthAnchor constraintEqualToConstant:kButtonWidth]
    ]];
}
@end
