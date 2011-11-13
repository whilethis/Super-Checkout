//
//  MainNavigationController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainNavigationController.h"
#import "ShoppingCartViewController.h"

@implementation MainNavigationController
@synthesize shoppingCartButton;

-(id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if(self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdateNotification:) name:@"CartUpdated" object:nil];
	}
	
	return self;
}

#pragma mark - Actions Received
-(IBAction) cartButtonPressed:(id)sender
{
	//Present modal cart by flip transition
	ShoppingCartViewController *cartVC = [[ShoppingCartViewController alloc] initWithNibName:@"ShoppingCartViewController" bundle:nil];
	[cartVC setDelegate:self];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cartVC];
	
	
	[navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self.topViewController presentModalViewController:navController animated:YES];
	
	[cartVC release];
	[navController release];
}

#pragma mark - SCModalDelegate Methods
-(void) viewController:(UIViewController *)vc didFinishWithData:(id) data
{
	[self.topViewController dismissModalViewControllerAnimated:YES];
}

-(void) viewControllerDidCancel:(UIViewController *)vc
{
	[self.topViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - Notifications
-(void) cartUpdateNotification:(NSNotification *) note {
	//Udpate cart button
	NSNumber *cartCount = [note object];
	
	[shoppingCartButton setTitle:[NSString stringWithFormat:@"Cart (%i)", [cartCount intValue]]];
}

- (void)dealloc {
	[shoppingCartButton release];
	[super dealloc];
}
@end
