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
@property (strong, nonatomic) UIView *firstLineView;
@property (strong, nonatomic) UIView *secondLineView;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self activateViewsConstraints];
    [self activateInfoViewConstraints];
    [self activateFiguresViewConstraints];
    [self activateButtonConstraintsInPortraitMode];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.figuresStackView animateFigures];
}

#pragma mark - UI Setup

-(void)configureViews {
    // creating views with views separators
    self.topView = [[UIView alloc] init];
    self.middleView = [[UIView alloc] init];
    self.bottomView = [[UIView alloc] init];
    self.firstLineView = [[UIView alloc] init];
    self.secondLineView = [[UIView alloc] init];
    
    self.firstLineView.backgroundColor = [UIColor colorFromRGBNumber:@0x707070];
    self.secondLineView.backgroundColor = [UIColor colorFromRGBNumber:@0x707070];
    self.firstLineView.alpha = 0.5;
    self.secondLineView.alpha = 0.5;
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.middleView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.firstLineView];
    [self.view addSubview:self.secondLineView];
    
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.middleView.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstLineView.translatesAutoresizingMaskIntoConstraints = NO;
    self.secondLineView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void) configureInfo {
    self.infoStackView = [[UIStackView alloc] init];
    self.infoStackView.axis = UILayoutConstraintAxisVertical;
    self.infoStackView.distribution = UIStackViewDistributionEqualSpacing;
//    self.infoStackView.spacing = 10;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    UILabel *modelLabel = [[UILabel alloc] init];
    UILabel *systemLabel = [[UILabel alloc] init];
    UIDevice *device = [[UIDevice alloc] init];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    
    nameLabel.text = device.name;
    modelLabel.text = device.model;
    systemLabel.text = [NSString stringWithFormat:@"%@ %@", device.systemName, device.systemVersion];
    nameLabel.font = modelLabel.font = systemLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];

    [self.infoStackView addArrangedSubview:nameLabel];
    [self.infoStackView addArrangedSubview:modelLabel];
    [self.infoStackView addArrangedSubview:systemLabel];
    self.appleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple"]];
    self.appleView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:self.infoStackView];
    [self.view addSubview:self.appleView];
    
    self.infoStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.appleView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)configureFiguresStackView {
    self.figuresStackView = [[FiguresStackView alloc] init];
    [self.middleView addSubview:self.figuresStackView];
    self.figuresStackView.translatesAutoresizingMaskIntoConstraints = NO;
}

-(void)configureButtons {
    // create openCVButton
    self.openCVButton = [[CustomButton alloc] init];
    [self.openCVButton setTitle:@"Open Git CV" forState:UIControlStateNormal];
    [self.openCVButton setBackgroundColor:[UIColor colorFromRGBNumber:@0xF9CC78]];
    [self.openCVButton setTitleColor:[UIColor colorFromRGBNumber:@0x101010] forState:UIControlStateNormal];
    [self.openCVButton addTarget:self action:@selector(openCVButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.openCVButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // create goToStartButton
    self.goToStartButton = [[CustomButton alloc] init];
    [self.goToStartButton setTitle:@"Go to start!" forState:UIControlStateNormal];
    [self.goToStartButton setBackgroundColor:[UIColor colorFromRGBNumber:@0xEE686A]];
    [self.goToStartButton setTitleColor:[UIColor colorFromRGBNumber:@0xFFFFFF] forState:UIControlStateNormal];
    [self.goToStartButton addTarget:self action:@selector(goToStartButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.goToStartButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    // adding as subviews
    [self.bottomView addSubview:self.openCVButton];
    [self.bottomView addSubview:self.goToStartButton];
}

#pragma mark - Constraints activation

// views
- (void)activateViewsConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.topView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:70],
        [self.topView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.topView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
        [self.topView.heightAnchor constraintEqualToAnchor:self.middleView.heightAnchor],
        
        [self.middleView.heightAnchor constraintEqualToAnchor:self.bottomView.heightAnchor],
        [self.middleView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.bottomView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.middleView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
        [self.bottomView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
        
        [self.firstLineView.topAnchor constraintEqualToAnchor:self.topView.bottomAnchor],
        [self.middleView.topAnchor constraintEqualToAnchor:self.firstLineView.bottomAnchor],
        [self.secondLineView.topAnchor constraintEqualToAnchor:self.middleView.bottomAnchor],
        [self.bottomView.topAnchor constraintEqualToAnchor:self.secondLineView.bottomAnchor],
        [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-70],
        
        [self.firstLineView.heightAnchor constraintEqualToConstant:2],
        [self.firstLineView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.firstLineView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
        [self.secondLineView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:50],
        [self.secondLineView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-50],
        [self.secondLineView.heightAnchor constraintEqualToConstant:2]
    ]];
}

// info
- (void)activateInfoViewConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.infoStackView.centerYAnchor constraintEqualToAnchor: self.topView.centerYAnchor],
        [self.infoStackView.centerXAnchor constraintGreaterThanOrEqualToAnchor: self.topView.centerXAnchor],
        [self.infoStackView.bottomAnchor constraintLessThanOrEqualToAnchor: self.topView.bottomAnchor],
        
        [self.appleView.leadingAnchor constraintLessThanOrEqualToAnchor:self.topView.leadingAnchor],
        [self.appleView.centerYAnchor constraintEqualToAnchor:self.topView.centerYAnchor],
        [self.appleView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topView.topAnchor constant:5],
        [self.appleView.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.topView.bottomAnchor constant:5],
        [self.appleView.trailingAnchor constraintEqualToAnchor:self.infoStackView.leadingAnchor constant:-10],

    ]];
}

// figures
- (void)activateFiguresViewConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.figuresStackView.centerYAnchor constraintEqualToAnchor:self.middleView.centerYAnchor],
        [self.figuresStackView.centerXAnchor constraintEqualToAnchor:self.middleView.centerXAnchor],
    ]];
}

// buttons
-(void)activateButtonConstraintsInPortraitMode {
    [NSLayoutConstraint activateConstraints:@[
        [self.openCVButton.centerXAnchor constraintEqualToAnchor:self.bottomView.centerXAnchor],
        [self.openCVButton.topAnchor constraintGreaterThanOrEqualToAnchor:self.bottomView.topAnchor constant:10],
        [self.openCVButton.bottomAnchor constraintEqualToAnchor:self.goToStartButton.topAnchor constant:-10],
        [self.goToStartButton.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.bottomView.bottomAnchor constant:-30],
        [self.goToStartButton.centerXAnchor constraintEqualToAnchor:self.bottomView.centerXAnchor],
    ]];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

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
