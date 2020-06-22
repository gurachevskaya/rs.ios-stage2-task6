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
#import "SecondCollectionViewController.h"
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

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureQuestionLabel];
    [self configureStartButton];
    [self configureFiguresStackView];
        
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.figuresStackView animateFigures];
   
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}

#pragma mark - UI Setup

-(void)configureQuestionLabel {
    
    self.questionLabel = [[UILabel alloc] init];
             
    self.questionLabel.text = @"Are you ready?";
    self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];

    [self.view addSubview:self.questionLabel];
    self.questionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.questionLabel.centerYAnchor constraintLessThanOrEqualToAnchor:self.view.topAnchor constant:self.view.frame.size.height / 5],
        [self.questionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

-(void)configureStartButton {
    
    self.startButton = [CustomButton configureButtonWithText:@"START" textColorNumber:@0x101010 andBackgroundColorNumber:@0xF9CC78];
    [self.startButton addTarget:self action:@selector(startButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.startButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.startButton.centerYAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100],
        [self.startButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.startButton.heightAnchor constraintEqualToConstant:kButtonHeight],
        [self.startButton.widthAnchor constraintEqualToConstant:kButtonWidth]
    ]];
    
}

-(void)configureFiguresStackView {
    
    self.figuresStackView = [[FiguresStackView alloc] init];
    [self.view addSubview:self.figuresStackView];
    self.figuresStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.figuresStackView.topAnchor constraintEqualToAnchor:self.questionLabel.bottomAnchor constant:50],
        [self.figuresStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    ]];
}

#pragma mark - Actions

-(void)startButtonTapped {

    UITabBarController *tabBarController = [UITabBarController new];

    NSMutableArray *tabBarControllers = [[NSMutableArray alloc] init];

    UINavigationController *firstViewController = [[UINavigationController alloc] initWithRootViewController:[InfoTableViewController new]];
    [self setTabBarImage:@"info_unselected" selectedImage:@"info_selected" forController:firstViewController];
    [tabBarControllers addObject:firstViewController];
    
    GalleryCollectionViewController *vc = [[GalleryCollectionViewController alloc] initWithNibName:@"GalleryCollectionViewController" bundle:nil];
    UINavigationController *secondViewController = [[UINavigationController alloc] initWithRootViewController:vc];
     [self setTabBarImage:@"gallery_unselected" selectedImage:@"gallery_selected" forController:secondViewController];
    [tabBarControllers addObject:secondViewController];

    UINavigationController *thirdViewController = [[UINavigationController alloc] initWithRootViewController:[RSSchoolTask6ViewController new]];
    [self setTabBarImage:@"home_unselected" selectedImage:@"home_selected" forController:thirdViewController];
    [tabBarControllers addObject:thirdViewController];
    
    tabBarController.viewControllers = tabBarControllers;
    tabBarController.customizableViewControllers = nil;
    
    [self.navigationController pushViewController:tabBarController animated:YES];

}

-(void)setTabBarImage:(NSString *)image selectedImage:(NSString *)selectedImage forController:(UIViewController *)vc {
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:0];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


    



@end
