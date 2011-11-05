//
//  FBcell.m
//  AssistanceFund
//
//  Created by Joshua Hale on 5/10/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import "FBcell.h"


@implementation FBcell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        row = 0;
        section = 0;
        
        [self.textLabel removeFromSuperview];
        [self.imageView removeFromSuperview];
        label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 300, 45)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18]];
        [self addSubview:label];
    }
    return self;
}

-(void)setLabelText:(NSString *)text{
    label.text = text;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    row = indexPath.row;
    section = indexPath.section;
}

-(void)setFBImage:(UIImage *)image{
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame = CGRectMake(0, 0, 43, 43);
    [self addSubview:imageview];
    //[imageview release];
}

-(int)getRow{ return row; }
-(int)getSection{ return section; }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)dealloc
{
    [label release];
    [super dealloc];
}

@end
