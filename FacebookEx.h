//
//  FacebookEx.h
//  FaceBookClasser
//
//  Created by Justin Taylor on 6/20/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#define FBAppID @"206175899441556"

#define UserDefaultsFBDate      @"fb_date"
#define UserDefaultsFBToken     @"fb_token"

@interface FacebookEx : NSObject <FBSessionDelegate, FBRequestDelegate>{
    Facebook *facebook;
    UIViewController *viewController;
    UIView *_blockerView;
}

@property (nonatomic, retain) NSString *itunesURL;
@property (nonatomic, retain) NSString *androidURL;
@property (nonatomic, retain) NSString *properties;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *picture;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *redirectURI;
@property (nonatomic, retain) NSString *link;

- (id)initWithAppID:(NSString *)appId;

- (void)displayFriendsListWithViewController:(UIViewController *)controller;
- (void)logOutWithAlert:(BOOL)withAlert;

- (NSMutableDictionary *)parameters;

- (Facebook *)facebook;
+ (FacebookEx *)sharedInstance;

@end