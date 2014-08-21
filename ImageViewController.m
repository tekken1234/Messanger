//
//  ImageViewController.m
//  Messanger
//
//  Created by ldh on 14/8/21.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];

    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    self.imageView.image = [UIImage imageWithData:imageData];
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"sent from %@", senderName];
    self.navigationItem.title = title;
}

@end
