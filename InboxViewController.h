//
//  InboxViewController.h
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;

- (IBAction)logout:(id)sender;

@end
