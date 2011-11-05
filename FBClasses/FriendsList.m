//
//  FriendsList.m
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

#import "FriendsList.h"
#import "FBfriends.h"
#import "FBcell.h"

#import "FacebookEx.h"

@implementation FriendsList

@synthesize table;

-(IBAction)close{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)invite{
    NSString *uid = [NSString stringWithFormat:@"%@", [friends getFriendUIDAt:selectedFriend]];
    NSMutableDictionary* params = [[FacebookEx sharedInstance] parameters];
    [params setObject:uid forKey:@"to"];
    
    [[[FacebookEx sharedInstance] facebook] dialog:@"feed" andParams:params andDelegate:self];
}

-(IBAction)share{
    NSMutableDictionary* params = [[FacebookEx sharedInstance] parameters];
     [[[FacebookEx sharedInstance] facebook] dialog:@"feed" andParams:params andDelegate:self];
}

NSInteger myCompare(id item1, id item2, void *context){
    return [(NSString *)item1 localizedCaseInsensitiveCompare:(NSString *)item2];
}



- (BOOL)isIpad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}



#pragma mark
#pragma mark - FBDialog Delegate Methods

-(void)dialogDidComplete:(FBDialog *)dialog{
    NSLog(@"did complete");
}

-(void)dialog:(FBDialog *)dialog didFailWithError:(NSError *)error{
    NSLog(@"ERROR   %@", error);
}

-(void)dialogDidNotComplete:(FBDialog *)dialog{
    NSLog(@"DID NOT COMPLETE");
}

#pragma mark
#pragma mark - init Methods

-(id)initWithFriends:(FBfriends *)friend_list{
    [super init];
    friends = friend_list;
    return self;
}

-(id)initWithArray:(NSArray *)array{
    NSString *nib;
    if ([self isIpad])
        nib = @"IpadFriendsLIst";
    else
        nib = @"FriendsList";
    [super initWithNibName:nib bundle:nil];
    friends = [[FBfriends alloc] initWithArray:array];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark
#pragma mark - Table methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    FBcell *cell = (FBcell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[FBcell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        UIImageView *customDisclosureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [customDisclosureView setFrame:CGRectMake(0, 0, 20*.8, 20)];
        cell.accessoryView = customDisclosureView;
        [customDisclosureView release];
    }
    [cell setIndexPath:indexPath];
    [cell setLabelText:[friends getFriendNameAt:indexPath]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if( selectedFriend )
        [selectedFriend retain];
        
    selectedFriend = [indexPath retain];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [friends.indexs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[friends.alphabeticalList objectAtIndex:section] count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return friends.indexs;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return index;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UILabel *sectionHeader = [[[UILabel alloc] init] autorelease];
	sectionHeader.textColor = [UIColor whiteColor];
    
    sectionHeader.backgroundColor  = [UIColor grayColor];

    sectionHeader.text = [NSString stringWithFormat:@"  %@", [friends.indexs objectAtIndex:section]];
    
	return sectionHeader;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [NSThread detachNewThreadSelector:@selector(getImageforCell:) toTarget:self withObject:cell];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45.0f;
}

-(void)getImageforCell:(FBcell *)cell{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [cell setFBImage:[friends getImageForFriend:[cell getSection] :[cell getRow]]];
    [pool release];
}

#pragma mark
#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated{
    for(FBcell *cell in [table visibleCells]){
        [NSThread detachNewThreadSelector:@selector(getImageforCell:) toTarget:self withObject:cell];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    for(UIView *view in self.view.subviews)
        [view release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    if( selectedFriend )
        [selectedFriend retain];
    
    [friends release];
    [table release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
