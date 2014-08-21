//
//  LoginViewController.m
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}


- (IBAction)login {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    
    if ([username length] == 0 || [password length] == 0 ){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops," message:@"please input : \nusername:\npassword:" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        [PFUser logInWithUsernameInBackground:username password:password  block:^(PFUser *user, NSError *error) {
            if (user) {
               /* PFUser *currentUser = [PFUser currentUser];
                NSLog(@"Current User is %@", currentUser.username); */
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
                
                
            }
        }];
    }
}
@end
