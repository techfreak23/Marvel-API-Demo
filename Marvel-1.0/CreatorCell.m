//
//  CreatorCell.m
//  API demo
//
//  Created by Art Sevilla on 2/11/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import "CreatorCell.h"

@implementation CreatorCell

@synthesize mainView, imageView, nameLabel, descriptionView;

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

- (void)configureCellWithDictionary:(NSDictionary *)dictionary
{
    
}

@end
