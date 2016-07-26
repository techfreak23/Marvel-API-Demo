//
//  CreatorCell.h
//  API demo
//
//  Created by Art Sevilla on 2/11/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatorCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionView;

@end
