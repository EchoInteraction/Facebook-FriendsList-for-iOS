//
//  FacebookEx.h
//  FaceBookClasser
//
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

#import <Foundation/Foundation.h>
#import "FBConnect.h"

#warning ADD YOUR APPLICATIONS id

#define FBAppID @"<YOU_APP_ID>"

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