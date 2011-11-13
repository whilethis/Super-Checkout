//
//  Super_CheckoutViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCheckoutAPIEngineDelegate.h"
@class SuperCheckoutAPIEngine;
@class ProductCell;

@interface Super_CheckoutViewController : UITableViewController<SuperCheckoutAPIEngineDelegate> {
	NSArray *inventory;
	SuperCheckoutAPIEngine *apiEngine;
	
	UINib *cellNib;
	ProductCell *productCell;
	
	NSMutableDictionary *imageIndexPaths;
}

@property (nonatomic, retain) IBOutlet ProductCell *productCell;

@end
