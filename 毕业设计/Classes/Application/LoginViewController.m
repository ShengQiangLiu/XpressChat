//
//  ViewController.m
//  毕业设计
//
//  Created by admin on 15-4-8.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "pushnotification.h"

#import "NavigationController.h"
#import "GroupsViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"

#define kEmail @"EMAIL"
#define kPassword @"PASSWORD"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;

@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) GroupsViewController *groupsViewCtrl;
@property (nonatomic, strong) MessageViewController *messageViewCtrl;
@property (nonatomic, strong) ProfileViewController *profileViewCtrl;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _fieldEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:kEmail];
    _fieldPassword.text = [[NSUserDefaults standardUserDefaults] objectForKey:kPassword];
}

- (IBAction)LoginBtnClick:(UIButton *)sender {
    
    NSString *email = [_fieldEmail.text lowercaseString];
    NSString *password = _fieldPassword.text;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([email length] == 0)	{ [ProgressHUD showError:@"Email 必须设置."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Password 必须设置."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [[NSUserDefaults standardUserDefaults] setObject:_fieldEmail.text forKey:kEmail];
    [[NSUserDefaults standardUserDefaults] setObject:_fieldPassword.text forKey:kPassword];
    [ProgressHUD show:@"登录中..." Interaction:NO];
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
         if (user != nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:[NSString stringWithFormat:@"欢迎回来 %@!", user[PF_USER_FULLNAME]]];
             [self presentViewCtrl];
         } else {
//             [ProgressHUD showError:error.userInfo[@"error"]];
             [ProgressHUD showError:@"登录失败."];
             NSLog(@"%@", error.userInfo[@"error"]);
         }
        
     }];
}

- (IBAction)RegisterBtnClick:(UIButton *)sender {
    
    RegisterViewController *registerCtrl = [RegisterViewController new];
    registerCtrl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:registerCtrl animated:YES completion:^{
        
    }];
    
}

- (void)presentViewCtrl {
    _groupsViewCtrl = [[GroupsViewController alloc] init];
    _messageViewCtrl = [[MessageViewController alloc] init];
    _profileViewCtrl = [[ProfileViewController alloc] init];
    NavigationController *naviCtrl1 = [[NavigationController alloc] initWithRootViewController:_groupsViewCtrl];
    NavigationController *naviCtrl2 = [[NavigationController alloc] initWithRootViewController:_messageViewCtrl];
    NavigationController *naviCtrl3 = [[NavigationController alloc] initWithRootViewController:_profileViewCtrl];
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = [NSArray arrayWithObjects:naviCtrl1, naviCtrl2, naviCtrl3, nil];
    _tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    _tabBarController.selectedIndex = DEFAULT_TAB;
    [self presentViewController:_tabBarController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
