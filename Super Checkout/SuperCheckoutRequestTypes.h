//
//  SuperCheckoutRequestTypes.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

typedef enum _SuperCheckoutRequestType {
	SuperCheckoutProducts = 0,
	SuperCheckoutProductImage,
	SuperCheckoutBuy,
	SuperCheckoutDelete,
	SuperCheckoutCart,
	SuperCheckoutCheckout
} SuperCheckoutRequestType;

typedef enum _SuperCheckoutResponseType {
	SuperCheckoutProductList = 0,
	SuperCheckoutCartContents,
	SuperCheckoutCheckoutResponse,
	SuperCheckoutImage
} SuperCheckoutResponseType;