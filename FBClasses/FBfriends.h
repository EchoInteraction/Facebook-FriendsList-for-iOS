//
//  FBfriends.h
//  AssistanceFund
//
//  Created by Joshua Hale on 5/10/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FBfriends : NSObject {
    NSMutableArray *alphabeticalList;
    NSMutableArray *indexs;
}

@property (nonatomic, retain) NSMutableArray *alphabeticalList;
@property (nonatomic, retain) NSMutableArray *indexs;

-(id)initWithArray:(NSArray *)friends;
-(NSString *)getFriendNameAt:(NSIndexPath *)indexpath;
-(NSString *)getFriendUIDAt:(NSIndexPath *)indexpath;
-(UIImage *)getImageForFriend:(int)section: (int)row;
@end
