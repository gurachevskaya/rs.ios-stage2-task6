//
//  FiguresStackView.m
//  RSSchool_T6
//
//  Created by Karina on 6/19/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "FiguresStackView.h"
#import "UIColor+ColorFromRGB.h"
#import "Constants.h"

@interface FiguresStackView()

@property (strong, nonatomic) UIView *redCircle;
@property (strong, nonatomic) UIView *blueRectangle;
@property (strong, nonatomic) UIView *greenTriangle;

@end


@implementation FiguresStackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _redCircle = [UIView new];
        _blueRectangle = [UIView new];
        _greenTriangle = [UIView new];
        [self setupViews];
    }
    return self;
}


- (void)setupViews {
    
    self.redCircle.backgroundColor = [UIColor colorFromRGBNumber:@0xEE686A];
    self.blueRectangle.backgroundColor = [UIColor colorFromRGBNumber:@0x29C2D1];
    self.greenTriangle.backgroundColor = [UIColor colorFromRGBNumber:@0x34C1A1];
    
    CAShapeLayer *triangle = [CAShapeLayer layer];
    UIBezierPath* trianglePath = [UIBezierPath bezierPath];
    [trianglePath moveToPoint:(CGPoint){kFigureDimension / 2,0}];
    [trianglePath addLineToPoint:(CGPoint){kFigureDimension,kFigureDimension}];
    [trianglePath addLineToPoint:(CGPoint){0,kFigureDimension}];
    [trianglePath closePath];
    
    [triangle setPath:trianglePath.CGPath];
    
    self.greenTriangle.layer.mask = triangle;
    
    self.redCircle.layer.cornerRadius = kFigureDimension / 2;
    
    [self addArrangedSubview:self.redCircle];
    [self addArrangedSubview:self.blueRectangle];
    [self addArrangedSubview:self.greenTriangle];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.redCircle.heightAnchor constraintEqualToConstant:kFigureDimension],
        [self.redCircle.widthAnchor constraintEqualToConstant:kFigureDimension],
        [self.blueRectangle.heightAnchor constraintEqualToConstant:kFigureDimension],
        [self.blueRectangle.widthAnchor constraintEqualToConstant:kFigureDimension],
        [self.greenTriangle.heightAnchor constraintEqualToConstant:kFigureDimension],
        [self.greenTriangle.widthAnchor constraintEqualToConstant:kFigureDimension]
    ]];
    
    self.distribution = UIStackViewDistributionEqualSpacing;
    self.spacing = 30;
}


-(void)animateFigures {
    
    [self animateRectangle];
    [self animateTriangle];
    [self animateCircle];
    
}

-(void)animateCircle {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1.f;
    animation.fromValue = @(0.8);
    animation.toValue = @(1.2);
    animation.autoreverses = YES;
    animation.repeatCount = INFINITY;
    [self.redCircle.layer addAnimation:animation forKey:@"transform.scale"];
    
}

-(void)animateRectangle {
    
    [UIView animateWithDuration:0.5f delay:0 options:UIViewKeyframeAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                     animations:^{
        
        self.blueRectangle.center = CGPointMake(self.blueRectangle.center.x, self.blueRectangle.center.y + kFigureDimension * 0.1);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5f
                         animations:^{
            
            self.blueRectangle.center = CGPointMake(self.blueRectangle.center.x, self.blueRectangle.center.y - kFigureDimension * 0.1);
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)animateTriangle {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 3.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INFINITY;
    [self.greenTriangle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}


@end
