//
//  ProductCell.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "ProductCell.h"


@implementation ProductCell
@synthesize productInformation;
@synthesize productImage;
@synthesize productNameLabel;
@synthesize productPriceLabel;

+(NSString *)reuseIdentifier {
	return @"ProductCell";
}

-(NSString *)reuseIdentifier {
	return [[self class] reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setProductInformation:(NSDictionary *)newProductInformation {
	NSDictionary *oldInfo = productInformation;
	productInformation = [newProductInformation retain];

	[productNameLabel setText:[productInformation objectForKey:@"name"]];
	
	NSNumber *price = [productInformation objectForKey:@"price"];
	[productPriceLabel setText:[NSString stringWithFormat:@"$%1.2f", [price floatValue]]];
	
	[oldInfo release];
}

- (void)dealloc
{
	[productImage release];
	[productNameLabel release];
	[productPriceLabel release];
    [super dealloc];
}

@end
