//
//  QuantityCell.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "QuantityCell.h"


@implementation QuantityCell
@synthesize quantityLabel;
@synthesize quantity;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if(self) {
		quantity = 1;
	}
	
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [quantityLabel release];
    [super dealloc];
}

- (IBAction)decrementQuantity:(id)sender {
	if(quantity > 1) {
		quantity--;
		
		[quantityLabel setText:[NSString stringWithFormat:@"%i", quantity]];
	}
}

- (IBAction)incrementQuantity:(id)sender {
	quantity++;
	
	[quantityLabel setText:[NSString stringWithFormat:@"%i", quantity]];
}
@end
