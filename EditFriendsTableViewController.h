//
//  EditFriendsTableViewController.h
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface EditFriendsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *allusers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

- (BOOL)isFriend:(PFUser *)user;

@end
