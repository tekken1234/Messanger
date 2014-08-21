//
//  CameraViewController.m
//  Messanger
//
//  Created by ldh on 14/8/21.
//  Copyright (c) 2014年 ldh. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>


@interface CameraViewController ()

@end

@implementation CameraViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation = [[PFUser currentUser]objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error : %@ %@", error, [error userInfo]);
        } else {
            self.friends = objects;
            // NSLog(@"%@", [self allusers]);
            [self.tableView reloadData];
        }
    }];
    // add a check to prevent backend is still loading and user initialize camera again.
    if (self.image == nil && self.videoFilePath == nil) {
        
        self.picker = [[UIImagePickerController alloc]init];
        self.picker.delegate = self;
        self.picker.allowsEditing = NO;
        self.picker.videoMaximumDuration = 10;
        
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            } else {
                    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
                
                self.picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.picker.sourceType];
                [self presentViewController:self.picker animated:YES completion:nil];
     }
    
}
    
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser * user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
    // NSLog(@"%@",self.recipients);
}

#pragma mark - Image Picker Controller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tabBarController setSelectedIndex:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"mediatype : %@", mediaType);
    if ([mediaType isEqualToString:@"public.image"]) {
        // a photo is taken / selected & save
        
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(self.image, nil, nil ,nil);
            
        } else {
        // Video was taken / selected and save
            
        self.videoFilePath = [info objectForKey:UIImagePickerControllerMediaURL];
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:self.videoFilePath completionBlock:nil];
        
        }
                
        [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - IBActions



- (IBAction)cancel:(id)sender {
    [self reset];
}

- (IBAction)send:(id)sender {
    if (self.image == nil && self.videoFilePath == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Try again!" message:@"Please take a photo or select one to share" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
        [alertView show];
        
        [self presentViewController:self.picker animated:YES completion:nil];
    
    } else {
    
        [self uploadMessage];
        
    }
}

#pragma mark - Helper methods

- (void) uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    // check if img or video exsist
    if (self.image != nil) {
        UIImage *newImage = [self resizeImage:self.image toWidth:160.0f andHeight:240.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    } else {
        fileData = [NSData dataWithContentsOfURL:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {

        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try again." delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
            [alertView show];

        } else {
            
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try again." delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil];
                    [alertView show];
                    
            } else {
                    [self reset];
            }
        }];
    }
  }];
    
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - resize image method

- (UIImage *)resizeImage:(UIImage *)Image toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}
@end