//
//  ProductCell.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProductCell : UITableViewCell {
    
	UIImageView *productImage;
	UILabel *productNameLabel;
	UILabel *productPriceLabel;
}

+(NSString *) reuseIdentifier;

@property (nonatomic, retain) NSDictionary *productInformation;
@property (nonatomic, retain) IBOutlet UIImageView *productImage;
@property (nonatomic, retain) IBOutlet UILabel *productNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *productPriceLabel;

@end
