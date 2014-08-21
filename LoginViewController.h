//
//  LoginViewController.h
//  Messanger
//
//  Created by ldh on 14/8/20.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)login;

@end
