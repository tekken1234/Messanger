//
//  EditFriendsTableViewController.m
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import "EditFriendsTableViewController.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error : %@ %@", error, [error userInfo]);
        } else {
            self.allusers = objects;
           // NSLog(@"%@", [self allusers]);
            [self.tableView reloadData];
        }
    }];
    
    self.currentUser = [PFUser currentUser];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.allusers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
    
    PFUser *user = [self.allusers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation = [self.currentUser objectForKey:@"friendsRelation"];
    
    if ([self isFriend:user]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        for (PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        [friendsRelation removeObject:user];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.friends addObject:user];
        [friendsRelation addObject:user];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"error : %@ %@", error, [error userInfo]);
        } else {
            return;
        }
    }];
    
}

#pragma mark - Check if are friends

-(BOOL)isFriend:(PFUser *)user {
    
    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}

@end
