//
//  SuperCheckoutHTTPURLConnection.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperCheckoutRequestTypes.h"

@interface SuperCheckoutHTTPURLConnection : NSURLConnection {
	
	NSMutableData *data;                   // accumulated data received on this connection
    SuperCheckoutRequestType requestType;      // general type of this request, mostly for error handling
    SuperCheckoutResponseType responseType;    // type of response data expected (if successful)
    NSString *identifier;
	NSURL *URL;							// the URL used for the connection (needed as a base URL when parsing with libxml)
    NSHTTPURLResponse *response;          // the response.
}

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate 
		  requestType:(SuperCheckoutRequestType)requestType responseType:(SuperCheckoutResponseType)responseType;


// Data helper methods
- (void)resetDataLength;
- (void)appendData:(NSData *)data;

// Accessors
- (NSString *)identifier;
- (NSData *)data;
- (NSURL *)URL;
- (SuperCheckoutRequestType)requestType;
- (SuperCheckoutResponseType)responseType;
- (NSString *)description;

@property (nonatomic, retain) NSHTTPURLResponse *response;


@end
