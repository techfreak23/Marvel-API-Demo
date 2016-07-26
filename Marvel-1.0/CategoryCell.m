//
//  CategoryCell.m
//  API demo
//
//  Created by Art Sevilla on 2/10/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

@synthesize mainView, category;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureLabel:(NSString *)label
{
    self.mainView.layer.cornerRadius = 10.0;
    self.mainView.layer.masksToBounds = YES;
    
    self.category.text = label;
}

@end
