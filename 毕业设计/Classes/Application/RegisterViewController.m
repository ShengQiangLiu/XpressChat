//
//  RegisterViewController.m
//  毕业设计
//
//  Created by admin on 15-4-8.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "pushnotification.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fieldName;
@property (weak, nonatomic) IBOutlet UITextField *fieldPassword;
@property (weak, nonatomic) IBOutlet UITextField *fieldEmail;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)swipeAction:(UISwipeGestureRecognizer *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)actionRegister:(UIButton *)sender {
    
    NSString *name		= _fieldName.text;
    NSString *password	= _fieldPassword.text;
    NSString *email		= [_fieldEmail.text lowercaseString];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([name length] == 0)		{ [ProgressHUD showError:@"Name 必须设置."]; return; }
    if ([password length] == 0)	{ [ProgressHUD showError:@"Password 必须设置."]; return; }
    if ([email length] == 0)	{ [ProgressHUD showError:@"Email 必须设置."]; return; }
    //---------------------------------------------------------------------------------------------------------------------------------------------
    [ProgressHUD show:@"请稍等..." Interaction:NO];
    
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    user[PF_USER_EMAILCOPY] = email;
    user[PF_USER_FULLNAME] = name;
    user[PF_USER_FULLNAME_LOWER] = [name lowercaseString];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             ParsePushUserAssign();
             [ProgressHUD showSuccess:@"注册成功."];
             [self dismissViewControllerAnimated:YES completion:nil];
         } else {
//             [ProgressHUD showError:error.userInfo[@"error"]];
             [ProgressHUD show:@"注册失败."];

         }
     }];
    
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
