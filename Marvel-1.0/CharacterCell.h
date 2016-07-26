//
//  CharacterCell.h
//  API demo
//
//  Created by Art Sevilla on 2/9/14.
//  Copyright (c) 2014 Art Sevilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *characterName;
@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIView *labelView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *descriptionView;

- (void)configureCellWithDictionary:(NSDictionary *)dictionary;

@end
