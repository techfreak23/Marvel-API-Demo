//
//  ListViewController.h
//  API demo
//
//  Created by Art Sevilla on 2/1/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *elements;
@property (nonatomic, strong) NSString *endString;
@property (nonatomic, strong) NSString *titleString;

@property (assign, nonatomic) CATransform3D initialTransformation;

@end
