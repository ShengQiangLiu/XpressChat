//
//  GroupsViewController.m
//  XpressChat
//
//  Created by admin on 15-4-9.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "GroupsViewController.h"
#import <Parse/Parse.h>
#import "ProgressHUD.h"

#import "AppConstant.h"
#import "messages.h"
#import "utilities.h"
#import "ChatView.h"

@interface GroupsViewController () {
    NSMutableArray *_groups;
}

@end

@implementation GroupsViewController

- (instancetype)init {
    if (self = [super init]) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_groups"]];
        self.tabBarItem.title = @"群组";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群组";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(actionNew)];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _groups = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([PFUser currentUser] != nil) {
        [self loadGroups];
    } else {
        LoginUser(self);
    }
    
}

#pragma mark - Backend actions
- (void)loadGroups
{
    
    PFQuery *query = [PFQuery queryWithClassName:PF_GROUPS_CLASS_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [_groups removeAllObjects];
             [_groups addObjectsFromArray:objects];
             [self.tableView reloadData];
         }
         else [ProgressHUD showError:@"Network error."];
     }];
    
}
#pragma mark - User actions
- (void)actionNew
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入你的群组名." message:nil delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length] != 0)
        {
            PFObject *object = [PFObject objectWithClassName:PF_GROUPS_CLASS_NAME];
            object[PF_GROUPS_NAME] = textField.text;
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error == nil)
                 {
                     [self loadGroups];
                 } else {
                     [ProgressHUD showError:@"Network error."];
                 }
             }];
        }
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    PFObject *group = _groups[indexPath.row];
    cell.textLabel.text = group[PF_GROUPS_NAME];
    return cell;
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFObject *group = _groups[indexPath.row];
    NSString *groupId = group.objectId;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    CreateMessageItem([PFUser currentUser], groupId, group[PF_GROUPS_NAME]);
    //---------------------------------------------------------------------------------------------------------------------------------------------
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
    
}
@end
