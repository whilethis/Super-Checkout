//
//  SCJSONParser.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/7/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperCheckoutRequestTypes.h"

@protocol SCJSONParserDelegate <NSObject>

@required
-(void)parsingSucceededForRequest:(NSString *)identifier ofResponseType:(SuperCheckoutResponseType)responseType parsedObjects:(NSDictionary *)parsedObject;

@end

@interface SCJSONParser : NSObject {
	id<SCJSONParserDelegate> delegate;
    NSString *identifier;
	SuperCheckoutRequestType requestType;
	SuperCheckoutResponseType responseType;
	NSURL *URL;
	NSData *json;
	NSDictionary *parsedObject;
}

+(id) parserWithJSON:(NSData *)jsonData 
			delegate:(id<SCJSONParserDelegate>)delegate
connectionIdentifier:(NSString *)requestIdentifier
		 requestType:(SuperCheckoutRequestType)reqType
		responseType:(SuperCheckoutResponseType)responseType
				 URL:(NSURL *)theURL;

-(id)   initWithJSON:(NSData *)jsonData 
			delegate:(id<SCJSONParserDelegate>)delegate
connectionIdentifier:(NSString *)requestIdentifier
		 requestType:(SuperCheckoutRequestType)reqType
		responseType:(SuperCheckoutResponseType)responseType
				 URL:(NSURL *)theURL;



@end
