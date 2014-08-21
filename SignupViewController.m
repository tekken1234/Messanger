//
//  SignupViewController.m
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)Signup {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([username length] == 0 || [password length] == 0 || [email length] == 0 ){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops," message:@"please input : \nusername:\npassword:\nemail:\n" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
    } else {
    
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    
    // other fields can be set just like with PFObject
    // user[@"phone"] = @"415-392-0202";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } else {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];
        }
        
    }];

    }
}
@end
