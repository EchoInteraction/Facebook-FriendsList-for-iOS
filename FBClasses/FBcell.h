//
//  FBcell.h
//  AssistanceFund
//
//  Created by Joshua Hale on 5/10/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FBcell : UITableViewCell {
    int section;
    int row;
    UILabel *label;
}

-(void)setIndexPath:(NSIndexPath *)indexPath;
-(int)getRow;
-(int)getSection;
-(void)setFBImage:(UIImage *)image;
-(void)setLabelText:(NSString *)text;

@end
