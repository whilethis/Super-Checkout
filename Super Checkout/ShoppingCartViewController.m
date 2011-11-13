//
//  ShoppingCartViewController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ProductCell.h"

@implementation ShoppingCartViewController
@synthesize checkoutButtonView;
@synthesize delegate;
@synthesize productCell;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
	if(self) {
		apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
		imageIndexPaths = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (void)dealloc {
	[apiEngine setDelegate:nil];
	[apiEngine release];
	[imageIndexPaths release];
	[checkoutButtonView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Actions received
-(void) backToStorePressed:(id)sender
{
	[self.delegate viewControllerDidCancel:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
	[self setTitle:@"My Cart"];
	UIBarButtonItem *storeButton = [[UIBarButtonItem alloc] initWithTitle:@"Store" style:UIBarButtonItemStyleBordered target:self action:@selector(backToStorePressed:)];
	[self.navigationItem setRightBarButtonItem:storeButton];
	[storeButton release];
	
	[self.navigationItem setLeftBarButtonItem:[self editButtonItem]];
}

- (void)viewDidUnload
{

	[self setCheckoutButtonView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	[apiEngine getCart];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[shoppingCart objectForKey:@"items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *reuseIdentifier = @"CartCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSDictionary *cartItem = [[shoppingCart objectForKey:@"items"] objectAtIndex:[indexPath row]];
	[cell.textLabel setText:[cartItem objectForKey:@"name"]];
	
	NSString *subtitle = [NSString stringWithFormat:@"%i at $%1.2f each", [[cartItem objectForKey:@"quantity"] intValue], [[cartItem objectForKey:@"price"] floatValue]];
	[cell.detailTextLabel setText:subtitle];
	
	
	//Setup subtotal cell accessory
	NSString *subtotal = [NSString stringWithFormat:@"$%1.2f", [[cartItem objectForKey:@"subtotal"] floatValue]];
	CGSize size = [subtotal sizeWithFont:[UIFont systemFontOfSize:18.0f]];
	UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
	
	[priceLabel setFont:[UIFont systemFontOfSize:18.0f]];
	[priceLabel setText:subtotal];
	[cell setAccessoryView:priceLabel];
	[priceLabel release];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *item = [[shoppingCart objectForKey:@"items"] objectAtIndex:[indexPath row]];
		
		[apiEngine removeProductFromCart:[item objectForKey:@"id"] withQuantity:[item objectForKey:@"quantity"]];
    }   
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if([[shoppingCart objectForKey:@"items"] count] == 0) {
		return @"Your basket is empty";
	}
	
	return nil;
}


#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if([[shoppingCart objectForKey:@"items"] count] == 0) {
		return nil;
	}
	
	return checkoutButtonView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 57.0f;
}

#pragma mark - SuperCheckoutAPIEngineDelegate Methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred adding this item" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	
	[alert show];
}

-(void) cartContentsReceived:(NSDictionary *)cart forRequest:(NSString *)connectionIdentifier {
	shoppingCart = [cart retain];
	
	NSNotification *note = [NSNotification notificationWithName:@"CartUpdated" object:[NSNumber numberWithInt:[[shoppingCart objectForKey:@"items"] count]]];
	
	[[NSNotificationCenter defaultCenter] postNotification:note];
	
	[self.tableView reloadData];
	
	if([[shoppingCart objectForKey:@"items"] count] == 0) {
		[self setEditing:NO];
	}
}

- (IBAction)checkoutPressed:(id)sender {
	[apiEngine checkout];
}
@end
