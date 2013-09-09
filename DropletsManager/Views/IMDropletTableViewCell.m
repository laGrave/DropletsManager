//
//  IMDropletTableViewCell.m
//  DropletsManager
//
//  Created by Игорь Мищенко on 26.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMDropletTableViewCell.h"

@interface IMDropletTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *colorIndicatorView;

@end

@implementation IMDropletTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)prepareForReuse {

    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    self.adressLabel.text = @"";
}

- (void)setActive:(BOOL)active {

    _active = active;
    self.colorIndicatorView.backgroundColor = (active) ? [UIColor greenColor] : [UIColor redColor];
}

@end
