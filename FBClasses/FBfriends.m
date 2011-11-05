//
//  FBfriends.m
//  AssistanceFund
//
//  Created by Joshua Hale on 5/10/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

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
