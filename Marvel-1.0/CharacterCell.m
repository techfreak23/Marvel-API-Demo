//
//  CharacterCell.m
//  API demo
//
//  Created by Art Sevilla on 2/9/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import "CharacterCell.h"

@implementation CharacterCell

@synthesize characterName, imageView, descriptionView;

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
    self.mainView.layer.cornerRadius = 10;
    self.mainView.layer.masksToBounds = YES;
    self.labelView.layer.opacity = .75;
    
    self.descriptionView.backgroundColor = [UIColor darkGrayColor];
    self.descriptionView.textColor = [UIColor whiteColor];
    
    if ([dictionary objectForKey:@"name"]) {
        self.characterName.text = [dictionary objectForKey:@"name"];
    }
    
    if ([dictionary objectForKey:@"title"]) {
        self.characterName.text = [dictionary objectForKey:@"title"];
    }
    
    self.imageView.image = [dictionary objectForKey:@"image"];
    
    if ([[[dictionary objectForKey:@"description"] description] isEqualToString:@"<null>"] || [[[dictionary objectForKey:@"description"] description] isEqualToString:@""]) {
        self.descriptionView.text = @"There is no description available.";
    } else {
        self.descriptionView.text = [[dictionary objectForKey:@"description"] description];
    }
    
}

@end
