//
//  FacebookEx.m
//  FaceBookClasser
//
//  Created by Justin Taylor on 6/20/11.
//  Copyright 2011 Echo Interaction. All rights reserved.
//

#import "FacebookEx.h"
#import "FriendsList.h"
#import <QuartzCore/QuartzCore.h>

static FacebookEx* sharedInstance = nil;

@implementation FacebookEx

@synthesize itunesURL, androidURL;
@synthesize properties;
@synthesize name;
@synthesize picture;
@synthesize description;
@synthesize message;
@synthesize caption;
@synthesize redirectURI;
@synthesize link;

- (id)init
{
    self = [super init];
    if (self) {
        facebook = [[Facebook alloc] initWithAppId:FBAppID];
        
        CGRect viewRect = [[UIScreen mainScreen] bounds];
        _blockerView = [[UIView alloc] initWithFrame:viewRect];
        UIView *_blocker = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 250, 60)] autorelease];
        _blocker.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
        _blocker.center = CGPointMake(viewRect.size.width * .5, viewRect.size.height * .5);
        _blocker.alpha = 1.0;
        _blocker.clipsToBounds = YES;
        if ([_blocker.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) _blocker.layer setCornerRadius: 10];
        
        UILabel	*label = [[[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blocker.bounds.size.width, 15)] autorelease];
        label.text = NSLocalizedString(@"Loading Facebook Friends…", nil);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize: 15];
        [_blocker addSubview: label];
        
        UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
        
        spinner.center = CGPointMake(_blocker.bounds.size.width / 2, _blocker.bounds.size.height / 2 + 10);
        [_blocker addSubview: spinner];
        [_blockerView addSubview:_blocker];
        [_blockerView setHidden:YES];
        [spinner startAnimating];
        
        // initilize and blank out all properties
        itunesURL   = @" ";
        androidURL  = @" ";
        properties  = @" ";
        name        = @" ";
        picture     = @" ";
        description = @" ";
        message     = @" ";
        caption     = @" ";
        redirectURI = @" ";
        link        = @" ";

    }
    
    return self;
}

- (id)initWithAppID:(NSString *)appId
{
    self = [super init];
    if (self) {
        facebook = [[Facebook alloc] initWithAppId:appId];
    }
    
    return self;
}

#pragma mark -
#pragma mark - Parameters

-(NSMutableDictionary *)parameters{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            FBAppID, @"app_id",
            [self name], @"name",
            [self picture], @"picture",
            [self description], @"description",
            [self message],  @"message",
            [self caption], @"caption",
            [self redirectURI] ,@"redirect_uri",
            [self properties], @"properties",
            [self link], @"link",
            nil];
}

#pragma mark -
#pragma mark - Session Handling

-(void)loginToFacebook{
    NSArray* permissions = [[NSArray arrayWithObjects:@"read_stream", @"offline_access", @"publish_stream", nil] retain];
    [facebook authorize:permissions delegate:self];
    [permissions release];
}

- (void)logOutWithAlert:(BOOL)withAlert{
    NSUserDefaults *standards = [NSUserDefaults standardUserDefaults];
    [standards removeObjectForKey:@"fb_date"];
    [standards removeObjectForKey:@"fb_token"];
    [standards synchronize];
    
    if (withAlert)
        [facebook logout:self];
    else
        [facebook logout:nil];
}

#pragma mark -
#pragma mark -


-(void)fbDidLogin{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    bool stayloggedin = [standard boolForKey:@"facebook_preference"];
    if(stayloggedin){
        NSString *token = facebook.accessToken;
        [standard setObject:token forKey:@"fb_token"];
    
        NSDate *date = facebook.expirationDate;
        [standard setObject:date forKey:@"fb_date"];
    }
    
    [self performSelector:@selector(getFriendsList)];
}

- (void)fbDidNotLogin:(BOOL)cancelled{

}

-(void)fbDidLogout{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                    message:@"You have been logged out of Facebook"
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark - 
#pragma mark - Request Delegate Methods

- (void)request:(FBRequest *)request didLoad:(id)result {
    [_blockerView setHidden:YES];
    if ([result isKindOfClass:[NSArray class]]) {
        if([result count] == 0)
            return;
        
        FriendsList *ftvc = [[FriendsList alloc] initWithArray:result];
        [viewController presentModalViewController:ftvc animated:YES];
        [ftvc release];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    [_blockerView setHidden:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                    message:@"Facebook has encountered an error.\n Please Try again later."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark - Fun For Everyone

-(void)getFriendsList{
    [_blockerView setHidden:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT name,uid,pic_square FROM user WHERE uid IN ( SELECT uid2 FROM friend WHERE uid1=me() )",@"query",
                                   nil];
    
    [facebook requestWithMethodName: @"fql.query"
                          andParams: params
                      andHttpMethod: @"POST"
                        andDelegate: self];
}

-(void)checkForLoginCredentials{
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    BOOL valid = FALSE;
    if([standard objectForKey:@"fb_date"] != nil){
        NSDate *date = [standard objectForKey:@"fb_date"];
        if([date compare:[NSDate date]] == NSOrderedDescending){
            NSString *token = [standard objectForKey:@"fb_token"];
            [facebook setAccessToken:token];
            [facebook setExpirationDate:date];
            if([facebook isSessionValid]){
                valid = TRUE;
                [self getFriendsList];
            }else
                [self loginToFacebook];
        }
    }
    
    if(!valid)
        [self loginToFacebook];
}

- (void)displayFriendsListWithViewController:(UIViewController *)controller{
    viewController = controller;
    
    [controller.view addSubview:_blockerView];
    
    if(![facebook isSessionValid])
        [self checkForLoginCredentials];
    else
        [self getFriendsList];
}

- (Facebook *)facebook{
    return facebook;
}

+ (FacebookEx *)sharedInstance{
    @synchronized(self)
    {
        if (sharedInstance == nil){
            sharedInstance = [[FacebookEx alloc] init];
        }
    }
    return sharedInstance;
}

- (void)dealloc{
    [itunesURL release];
    [androidURL release];
    [properties release];
    [name release];
    [picture release];
    [description release];
    [message release];
    [caption release];
    [redirectURI release];
    
    [super dealloc];
}

@end
