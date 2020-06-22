//
//  RSSchoolTask6ViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/20/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "RSSchoolTask6ViewController.h"
#import "CustomButton.h"
#import "FiguresStackView.h"
#import "Constants.h"
#import "UIColor+ColorFromRGB.h"

@interface RSSchoolTask6ViewController ()
@property (strong, nonatomic) UIButton *openCVButton;
@property (strong, nonatomic) UIButton *goToStartButton;
@property (strong, nonatomic) FiguresStackView *figuresStackView;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *middleView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIStackView *infoStackView;
@property (strong, nonatomic) UIImageView *appleView;

@end

@implementation RSSchoolTask6ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"RSSchool Task 6";
    
    [self configureViews];
    [self configureFiguresStackView];
    [self configureButtons];
    [self configureInfo];

}

-(void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:YES];
 [self.figuresStackView animateFigures];
}

#pragma mark - UI Setup

-(void)configureButtons {
    self.openCVButton = [CustomButton configureButtonWithText:@"Open Git CV" textColorNumber:@0x101010 andBackgroundColorNumber:@0xF9CC78];
    [self.openCVButton addTarget:self action:@selector(openCVButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.openCVButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomView addSubview:self.openCVButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.openCVButton.topAnchor constraintEqualToAnchor:self.bottomView.topAnchor constant:30],
        [self.openCVButton.centerXAnchor constraintEqualToAnchor:self.bottomView.centerXAnchor],
        [self.openCVButton.heightAnchor constraintEqualToConstant:kButtonHeight],
        [self.openCVButton.widthAnchor constraintEqualToConstant:kButtonWidth]
    ]];
    
    self.goToStartButton = [CustomButton configureButtonWithText:@"Go to start!" textColorNumber:@0xFFFFFF andBackgroundColorNumber:@0xEE686A];
    [self.goToStartButton addTarget:self action:@selector(goToStartButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.goToStartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.bottomView addSubview:self.goToStartButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.goToStartButton.bottomAnchor constraintEqualToAnchor:self.bottomView.bottomAnchor constant:-30],
        [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.bottomView.centerXAnchor],
        [self.goToStartButton.heightAnchor constraintEqualToConstant:kButtonHeight],
        [self.goToStartButton.widthAnchor constraintEqualToConstant:kButtonWidth],
    ]];
}

-(void)configureFiguresStackView {
    self.figuresStackView = [[FiguresStackView alloc] init];
    [self.middleView addSubview:self.figuresStackView];
    self.figuresStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.figuresStackView.centerYAnchor constraintEqualToAnchor:self.middleView.centerYAnchor],
        [self.figuresStackView.centerXAnchor constraintEqualToAnchor:self.middleView.centerXAnchor],
    ]];
}

-(void)configureViews {
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:(CGRect)self.view.bounds.size];
//    scrollView.contentSize = self.view.bounds.size;
    
    self.topView  =[[UIView alloc] init];
    self.middleView  =[[UIView alloc] init];
    self.bottomView  =[[UIView alloc] init];
    
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    
//    self.topView.backgroundColor = UIColor.greenColor;
//    self.middleView.backgroundColor = UIColor.redColor;
//    self.bottomView.backgroundColor = UIColor.blueColor;
    view1.backgroundColor = [UIColor colorFromRGBNumber:@0x707070];
    view2.backgroundColor = [UIColor colorFromRGBNumber:@0x707070];
    view1.alpha = 0.5;
    view2.alpha = 0.5;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
    
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.middleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        
        [self.topView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.topView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.topView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.topView.heightAnchor constraintEqualToAnchor:self.middleView.heightAnchor],
        
        [self.middleView.heightAnchor constraintEqualToAnchor:self.bottomView.heightAnchor],
        [self.middleView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.bottomView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.middleView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.bottomView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        
        [view1.topAnchor constraintEqualToAnchor:self.topView.bottomAnchor],
        [self.middleView.topAnchor constraintEqualToAnchor:view1.bottomAnchor],
        [view2.topAnchor constraintEqualToAnchor:self.middleView.bottomAnchor],
        [self.bottomView.topAnchor constraintEqualToAnchor:view2.bottomAnchor],
        [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        
        
        [view1.heightAnchor constraintEqualToConstant:2],
        [view1.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:50],
        [view1.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-50],
        [view2.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:50],
        [view2.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-50],
        [view2.heightAnchor constraintEqualToConstant:2]
    ]];
    
}

-(void) configureInfo {
    
    self.infoStackView = [[UIStackView alloc] init];
    self.infoStackView.axis = UILayoutConstraintAxisVertical;
    self.infoStackView.spacing = 10;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *modelLabel = [[UILabel alloc] init];
    UILabel *systemLabel = [[UILabel alloc] init];
    UIDevice *device = [[UIDevice alloc] init];
    
    nameLabel.text = device.name;
    modelLabel.text = device.model;
    systemLabel.text = [NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion];
    nameLabel.font = modelLabel.font = systemLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];

    
    [self.infoStackView addArrangedSubview:nameLabel];
    [self.infoStackView addArrangedSubview:modelLabel];
    [self.infoStackView addArrangedSubview:systemLabel];
    
    [self.view addSubview:self.infoStackView];
    
    self.infoStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.infoStackView.centerXAnchor constraintEqualToAnchor:self.topView.centerXAnchor],
        [self.infoStackView.centerYAnchor constraintEqualToAnchor:self.topView.centerYAnchor],
    ]];
    
    self.appleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple"]];
    [self.view addSubview:self.appleView];
    self.appleView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
           [self.appleView.trailingAnchor constraintEqualToAnchor:self.infoStackView.leadingAnchor constant:-10],
           [self.appleView.centerYAnchor constraintEqualToAnchor:self.infoStackView.centerYAnchor],           
       ]];
    
    
}

//-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    [self setNeedsUpdateConstraints];
//}

//- (void)updateConstraints {
//    switch (self.traitCollection.verticalSizeClass) {
//        case UIUserInterfaceSizeClassRegular:
//
//            break;
//        case UIUserInterfaceSizeClassCompact:
//
//            break;
//        default:
//            break;
//    }
//    [super updateConstraints];
//}


#pragma mark - Actions

-(void)openCVButtonTapped {
    NSLog(@"openCVButtonTapped!");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/gurachevskaya/rsschool-cv/blob/gh-pages/cv.md"] options:@{} completionHandler:nil];
}

-(void)goToStartButtonTapped {
    NSLog(@"goToStartButtonTapped!");
    [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
