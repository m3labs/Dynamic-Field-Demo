//
//  FormTableViewCell.m
//  DynamicForms
//
//  Created by Phong on 5/15/14.
//  Copyright (c) 2014 MCubedLabs. All rights reserved.
//

#import "FormTableViewCell.h"

@implementation FormTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
