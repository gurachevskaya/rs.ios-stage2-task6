//
//  MainViewController.m
//  RSSchool_T6
//
//  Created by Karina on 6/19/20.
//  Copyright © 2020 Karina. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+ColorFromRGB.h"
#import "FiguresStackView.h"
#import "InfoTableViewController.h"
#import "RSSchoolTask6ViewController.h"
#import "CustomButton.h"
#import "GalleryCollectionViewController.h"
#import "Constants.h"

@interface MainViewController ()
@property (strong, nonatomic) UILabel *questionLabel;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) FiguresStackView *figuresStackView;
@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureQuestionLabel];
    [self configureStartButton];
    [self configureFiguresStackView];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self addLabelConstraints];
    [self addButtonConstraints];
    [self addFiguresConstraints];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.figuresStackView animateFigures];
}


#pragma mark - UI Setup

- (void)configureQuestionLabel {
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.text = @"Are you ready?";
    self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
    [self.view addSubview:self.questionLabel];
    self.questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
}


- (void)addLabelConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.questionLabel.topAnchor constraintLessThanOrEqualToAnchor:self.view.topAnchor constant:100],
        [self.questionLabel.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:20],
        [self.questionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}


- (void)configureStartButton {
    self.startButton = [[CustomButton alloc] init];
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setBackgroundColor:[UIColor colorFromRGBNumber:@0xF9CC78]];
    [self.startButton setTitleColor:[UIColor colorFromRGBNumber:@0x101010] forState:UIControlStateNormal];
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.startButton];
}


- (void)addButtonConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.startButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.startButton.bottomAnchor constraintGreaterThanOrEqualToAnchor:self.view.bottomAnchor constant:-100],
        [self.startButton.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor constant:-20],
    ]];
}


- (void)configureFiguresStackView {
    self.figuresStackView = [[FiguresStackView alloc] init];
    [self.view addSubview:self.figuresStackView];
    self.figuresStackView.translatesAutoresizingMaskIntoConstraints = NO;
}


- (void)addFiguresConstraints {
    [NSLayoutConstraint activateConstraints:@[
        [self.figuresStackView.topAnchor constraintGreaterThanOrEqualToAnchor:self.questionLabel.bottomAnchor constant:20],
        [self.figuresStackView.topAnchor constraintLessThanOrEqualToAnchor:self.questionLabel.bottomAnchor constant:100],
        [self.figuresStackView.centerYAnchor constraintLessThanOrEqualToAnchor:self.view.centerYAnchor constant:-50],
        [self.figuresStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.figuresStackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.startButton.topAnchor constant:-20],
    ]];
}


#pragma mark - Actions

- (void)startButtonTapped {

    UITabBarController *tabBarController = [UITabBarController new];

    NSMutableArray *tabBarControllers = [[NSMutableArray alloc] init];

    UINavigationController *firstViewController = [[UINavigationController alloc] initWithRootViewController:[InfoTableViewController new]];
    [tabBarControllers addObject:firstViewController];
     firstViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"info_unselected"] selectedImage:[[UIImage imageNamed:@"info_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    GalleryCollectionViewController *vc = [[GalleryCollectionViewController alloc] initWithNibName:@"GalleryCollectionViewController" bundle:nil];
    UINavigationController *secondViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [tabBarControllers addObject:secondViewController];
     secondViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"gallery_unselected"] selectedImage:[[UIImage imageNamed:@"gallery_selected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UINavigationController *thirdViewController = [[UINavigationController alloc] initWithRootViewController:[RSSchoolTask6ViewController new]];
    [tabBarControllers addObject:thirdViewController];
    thirdViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"home_unselected"] selectedImage:[[UIImage imageNamed:@"home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabBarController.viewControllers = tabBarControllers;
    tabBarController.customizableViewControllers = nil;
    
    [self.navigationController pushViewController:tabBarController animated:YES];

}

@end
