//
//  CustomButton.h
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomButton : UIButton
+(UIButton *)configureButtonWithText:(NSString *)text textColorNumber:(NSNumber *)textcolor andBackgroundColorNumber:(NSNumber *)color;

@end

NS_ASSUME_NONNULL_END
