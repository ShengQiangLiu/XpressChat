//
//  ProfileViewController.m
//  XpressChat
//
//  Created by admin on 15-4-9.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "camera.h"
#import "images.h"
#import "pushnotification.h"
#import "utilities.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@end

@implementation ProfileViewController

- (instancetype)init {
    if (self = [super init]) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_profile"]];
        self.tabBarItem.title = @"资料";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资料";
    
    _headImage.layer.cornerRadius = _headImage.frame.size.width/2;
    _headImage.layer.masksToBounds = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self
                                                                             action:@selector(actionLogout)];
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidAppear:animated];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([PFUser currentUser] != nil)
    {
        [self loadUser];
    }
    else LoginUser(self);
}
#pragma mark - Backend actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadUser
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
//    PFUser *user = [PFUser currentUser];
    
//    [imageUser setFile:user[PF_USER_PICTURE]];
//    [imageUser loadInBackground];
    
//    fieldName.text = user[PF_USER_FULLNAME];
}

#pragma mark - User actions

- (void)actionLogout
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Log out", nil];
    [action showFromTabBar:[[self tabBarController] tabBar]];
}

- (IBAction)imageTap:(UITapGestureRecognizer *)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
