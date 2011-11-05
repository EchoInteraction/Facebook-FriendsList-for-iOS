//
//  FriendsList.h
//  AssistanceFund
//
//  Created by Joshua Hale on 5/5/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBfriends.h"
#import "Facebook.h"

@interface FriendsList : UIViewController <UITableViewDelegate, UITableViewDataSource, FBDialogDelegate>{
    FBfriends *friends;
    IBOutlet UITableView *table;
    NSIndexPath *selectedFriend;
}

@property (nonatomic, retain) IBOutlet UITableView *table;

-(id)initWithFriends:(FBfriends *)friend_list;
-(id)initWithArray:(NSArray *)array;
-(IBAction)close;
-(IBAction)invite;
-(IBAction)share;

@end
