//
//  ProductDetailsViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCheckoutAPIEngine.h"
@class QuantityCell;

@interface ProductDetailsViewController : UITableViewController<SuperCheckoutAPIEngineDelegate> {
    NSDictionary *selectedProduct;
	UIView *productDetailsHeader;
	UIImageView *productImage;
	UILabel *productNameLabel;
	UILabel *productPriceLabel;
	UITableViewCell *addToBasketCell;
	QuantityCell *quantityCell;
	
	SuperCheckoutAPIEngine *apiEngine;
}

@property(retain, nonatomic) NSDictionary *selectedProduct;
@property (nonatomic, retain) IBOutlet UIView *productDetailsHeader;
@property (nonatomic, retain) IBOutlet UIImageView *productImage;
@property (nonatomic, retain) IBOutlet UILabel *productNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *addToBasketCell;
@property (nonatomic, retain) IBOutlet QuantityCell *quantityCell;

@end
