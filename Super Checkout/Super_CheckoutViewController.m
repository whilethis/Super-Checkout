//
//  Super_CheckoutViewController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Super_CheckoutViewController.h"
#import "SuperCheckoutAPIEngine.h"
#import "ProductCell.h"
#import "ProductDetailsViewController.h"
@implementation Super_CheckoutViewController
@synthesize productCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//We are loading from a nib, so initWithCoder: is used
- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if(self) {
		imageIndexPaths = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[productCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [inventory count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:[ProductCell reuseIdentifier]];
	
	if(cell == nil) {
		[cellNib instantiateWithOwner:self options:nil];
		cell = productCell;
	}
	NSDictionary *item = [inventory objectAtIndex:[indexPath row]];
	
	[cell setProductInformation:item];
	
	[self setProductCell:nil];
	
	//Fetch image for the cell
	NSString *requestId = [apiEngine getImageForProduct:[item objectForKey:@"thumb"]];
	
	[imageIndexPaths setObject:indexPath forKey:requestId];
	
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ProductDetailsViewController *newVC = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
	
	[newVC setSelectedProduct:[inventory objectAtIndex:[indexPath row]]];
	
	[self.navigationController pushViewController:newVC animated:YES];
	
	[newVC release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 76.0;
}

#pragma mark - Actions Received
-(void) cartButtonPressed:(id) sender {

}

#pragma mark - SuperCheckoutAPIEngineDelegate Methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
	
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	
}

-(void) productListReceived:(NSArray *)products forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Products list: %@", [products description]);
	inventory = [products retain];
	[self.tableView reloadData];
}

-(void) imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier {
	ProductCell *cell = (ProductCell *)[self.tableView cellForRowAtIndexPath:[imageIndexPaths objectForKey:connectionIdentifier]];
	
	[cell.productImage setImage:image];
	
	[imageIndexPaths removeObjectForKey:connectionIdentifier];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:@"Inventory"];
	
	UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithTitle:@"Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(cartButtonPressed:)];
	//[self.navigationItem setRightBarButtonItem:cartButton];
	[cartButton release];
	
	if(!cellNib) {
		cellNib = [[UINib nibWithNibName:@"ProductListCells" bundle:nil] retain];
	}
	
	if(!apiEngine) {
		apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
	}
	
	[apiEngine getProducts];
}

- (void)viewDidUnload
{
	[self setProductCell:nil];
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
