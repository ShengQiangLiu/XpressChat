//
//  MessageViewController.m
//  XpressChat
//
//  Created by admin on 15-4-9.
//  Copyright (c) 2015年 ShengQiangLiu. All rights reserved.
//

#import "MessageViewController.h"
#import <Parse/Parse.h>
#import "utilities.h"
#import "MessagesCell.h"
#import "ChatView.h"

@interface MessageViewController ()

@end

@implementation MessageViewController {
    NSMutableArray *_messages;
}

- (instancetype)init {
    
    if (self = [super init]) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_messages"]];
        self.tabBarItem.title = @"Messages";
        
        // 用户退出登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];

    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessagesCell" bundle:nil] forCellReuseIdentifier:@"MessagesCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    _messages = [[NSMutableArray alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] != nil) {
        [self loadMessages];
    } else {
        LoginUser(self);
    }
    
}

#pragma mark - Backend methods
- (void)loadMessages {
    // 查询数据
    PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
    [query whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]];
    [query includeKey:PF_MESSAGES_LASTUSER];
    [query orderByDescending:PF_MESSAGES_UPDATEDACTION];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil)
        {
            [_messages removeAllObjects];
            [_messages addObjectsFromArray:objects];
            [self.tableView reloadData];
            [self updateTabCounter];
        }
        else [ProgressHUD showError:@"Network error."];
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateTabCounter
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    int total = 0;
    for (PFObject *message in _messages)
    {
        total += [message[PF_MESSAGES_COUNTER] intValue];
    }
    
    UITabBarItem *item = self.tabBarController.tabBar.items[1];
    item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
    
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    [_messages removeAllObjects];
    [self.tableView reloadData];
    [self updateTabCounter];
}
//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    ChatView *chatView = [[ChatView alloc] initWith:groupId];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell...
    MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindData:_messages[indexPath.row]];
    return cell;
    
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    PFObject *message = _messages[indexPath.row];
    [self actionChat:message[PF_MESSAGES_GROUPID]];
}

@end
