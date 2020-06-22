//
//  CustomButton.m
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "CustomButton.h"
#import "UIColor+ColorFromRGB.h"

@implementation CustomButton

+(UIButton *)configureButtonWithText:(NSString *)text textColorNumber:(NSNumber *)textcolor andBackgroundColorNumber:(NSNumber *)color {
    
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorFromRGBNumber:textcolor] forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:20]];
    button.layer.cornerRadius = 27;
    button.backgroundColor = [UIColor colorFromRGBNumber:color];
    button.clipsToBounds = YES;
    
    return button;
}

@end
