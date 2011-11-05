//
//  FBfriends.m
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

#import "FBfriends.h"


@implementation FBfriends

@synthesize alphabeticalList, indexs;

NSInteger alphaCompare(id item1, id item2, void *context){
    return [(NSString *)[(NSDictionary *)item1 objectForKey:@"name"] localizedCaseInsensitiveCompare:(NSString *)[(NSDictionary *)item2 objectForKey:@"name"]];
}

-(UIImage *)getImageForFriend:(int)section: (int)row{
    if([[[[alphabeticalList objectAtIndex:section] objectAtIndex:row] objectForKey:@"pic_square"] isKindOfClass:[UIImage class]])
        return [[[alphabeticalList objectAtIndex:section] objectAtIndex:row] objectForKey:@"pic_square"];
    
    NSURL *url = [[NSURL alloc] initWithString:[[[alphabeticalList objectAtIndex:section] objectAtIndex:row] objectForKey:@"pic_square"]];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    [url release];
    UIImage *image = [[UIImage alloc] initWithData:data];
    [[[alphabeticalList objectAtIndex:section] objectAtIndex:row] setObject:image forKey:@"pic_square"];
    
    [image release];
    [data release];
    
    return [[[alphabeticalList objectAtIndex:section] objectAtIndex:row] objectForKey:@"pic_square"];
}

-(id)initWithArray:(NSArray *)friends{
    [super init];
    
    //array of arrays
    alphabeticalList = [[NSMutableArray alloc] init];
    indexs = [[NSMutableArray alloc] init];
    NSMutableArray *sortedfriends = [NSMutableArray arrayWithArray:[friends sortedArrayUsingFunction:alphaCompare context:NULL]];
    
    for (NSMutableDictionary* obj in sortedfriends) {
        char alpha = [[obj objectForKey:@"name"] characterAtIndex:0];
		NSString *uChar = [NSString stringWithFormat:@"%c", alpha];
		
		if(![indexs containsObject:uChar])
			[indexs addObject:uChar];
    }
    
    
    for(int i=0; i<[indexs count]; i++){        
        NSString *alpha = [indexs objectAtIndex:i];
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name beginswith[c] %@", alpha];
		NSArray *builds = [sortedfriends filteredArrayUsingPredicate:predicate];
        
        [alphabeticalList addObject:builds];
    }
    
    return self;
}

-(NSString *)getFriendNameAt:(NSIndexPath *)indexpath{
    return [[[alphabeticalList objectAtIndex:indexpath.section] objectAtIndex:indexpath.row] objectForKey:@"name"];
}

-(NSString *)getFriendUIDAt:(NSIndexPath *)indexpath{
    return [[[alphabeticalList objectAtIndex:indexpath.section] objectAtIndex:indexpath.row] objectForKey:@"uid"];
}
-(void)dealloc{
    [alphabeticalList release];
    [indexs release];
    [super dealloc];
}

@end
