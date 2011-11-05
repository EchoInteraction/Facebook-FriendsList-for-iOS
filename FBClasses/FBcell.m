//
//  FBcell.m

//  Created by Justin Taylor on 6/20/11.

/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of 
 this software and associated documentation files (the "Software"), to deal in the 
 Software without restriction, including without limitation the rights to use, 
 copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
 Software, and to permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
