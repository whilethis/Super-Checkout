//
//  QuantityCell.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QuantityCell : UITableViewCell {
	UILabel *quantityLabel;
	NSInteger quantity;
}
@property (nonatomic, retain) IBOutlet UILabel *quantityLabel;
@property (readonly) NSInteger quantity;

- (IBAction)decrementQuantity:(id)sender;
- (IBAction)incrementQuantity:(id)sender;
@end
