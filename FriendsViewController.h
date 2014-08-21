//
//  FriendsViewController.h
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (nonatomic, strong) PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;

@end
