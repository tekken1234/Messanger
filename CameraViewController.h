//
//  CameraViewController.h
//  Messanger
//
//  Created by ldh on 14/8/21.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImagePickerController *picker;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSURL *videoFilePath;
@property (nonatomic, strong)NSArray *friends;
@property (nonatomic, strong)PFRelation *friendsRelation;
@property (nonatomic, strong)NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;

- (IBAction)send:(id)sender;

- (void) uploadMessage;

- (UIImage *)resizeImage:(UIImage *)Image toWidth:(float)width andHeight:(float)height;

@end
