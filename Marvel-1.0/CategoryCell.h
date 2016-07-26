//
//  CategoryCell.h
//  API demo
//
//  Created by Art Sevilla on 2/10/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UILabel *category;

- (void)configureLabel:(NSString *)label;

@end
