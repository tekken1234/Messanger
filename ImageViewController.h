//
//  ImageViewController.h
//  Messanger
//
//  Created by ldh on 14/8/21.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) PFObject *message;
@end
