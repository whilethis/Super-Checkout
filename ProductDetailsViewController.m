//
//  ProductDetailsViewController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "QuantityCell.h"
#import "SuperCheckoutAPIEngine.h"

@implementation ProductDetailsViewController
@synthesize selectedProduct;
@synthesize productDetailsHeader;
@synthesize productImage;
@synthesize productNameLabel;
@synthesize productPriceLabel;
@synthesize addToBasketCell;
@synthesize quantityCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
    }
    return self;
}

- (void)dealloc
{
	[selectedProduct release];
	[productDetailsHeader release];
	[productImage release];
	[productNameLabel release];
	[productPriceLabel release];
	[addToBasketCell release];
	[quantityCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return 0;
	} else {
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if(section == 0) {
		return [selectedProduct objectForKey:@"description"];
	} else {
		return nil;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 1) {
		return quantityCell;
	} else {
		return addToBasketCell;
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Add item to cart here.....
	[apiEngine buyProduct:[selectedProduct objectForKey:@"id"] withQuantity:[NSNumber numberWithInt:[quantityCell quantity]]];
}

- (NSIndexPath *)tableView:(UITableView *)tableview willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 2) {
		return indexPath;
	} else {
		return nil;
	}
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return productDetailsHeader;
	} else {
		return nil;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return [productDetailsHeader frame].size.height;
	} else {
		return 0.0;
	}
}

#pragma mark - SuperCheckoutAPIEngineDelegate Methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred adding this item" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	
	[alert show];
}

-(void) cartContentsReceived:(NSDictionary *)cart forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Shopping cart contents: %@", cart);
	NSNotification *note = [NSNotification notificationWithName:@"CartUpdated" object:[NSNumber numberWithInt:[[cart objectForKey:@"items"] count]]];
	
	[[NSNotificationCenter defaultCenter] postNotification:note];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier {
	[productImage setImage:image];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:[selectedProduct objectForKey:@"name"]];
	
	[productNameLabel setText:[selectedProduct objectForKey:@"name"]];
	[productPriceLabel setText:[NSString stringWithFormat:@"$%1.2f", [[selectedProduct objectForKey:@"price"] floatValue]]];
	
	[apiEngine getImageForProduct:[selectedProduct objectForKey:@"image"]];
}

- (void)viewDidUnload
{
	[self setProductDetailsHeader:nil];
	[self setProductImage:nil];
	[self setProductNameLabel:nil];
	[self setProductPriceLabel:nil];
	[self setAddToBasketCell:nil];
	[self setQuantityCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
