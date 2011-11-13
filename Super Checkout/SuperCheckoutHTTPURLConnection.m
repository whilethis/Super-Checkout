//
//  SuperCheckoutHTTPURLConnection.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "SuperCheckoutHTTPURLConnection.h"
#import "NSString+UUID.h"

@implementation SuperCheckoutHTTPURLConnection

@synthesize response;

#pragma mark Initializer


- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate 
          requestType:(SuperCheckoutRequestType)theRequestType responseType:(SuperCheckoutResponseType)theResponseType
{
    if ((self = [super initWithRequest:request delegate:delegate])) {
        data = [[NSMutableData alloc] initWithCapacity:0];
        identifier = [[NSString stringWithNewUUID] retain];
        requestType = theRequestType;
        responseType = theResponseType;
		URL = [[request URL] retain];
    }
    
    return self;
}


- (void)dealloc
{
    [response release];
    [data release];
    [identifier release];
	[URL release];
    [super dealloc];
}


#pragma mark Data helper methods


- (void)resetDataLength
{
    [data setLength:0];
}


- (void)appendData:(NSData *)newData
{
    [data appendData:newData];
}


#pragma mark Accessors


- (NSString *)identifier
{
    return [[identifier retain] autorelease];
}


- (NSData *)data
{
    return [[data retain] autorelease];
}


- (NSURL *)URL
{
    return [[URL retain] autorelease];
}


- (SuperCheckoutRequestType)requestType
{
    return requestType;
}


- (SuperCheckoutResponseType)responseType
{
    return responseType;
}


- (NSString *)description
{
    NSString *description = [super description];
    
    return [description stringByAppendingFormat:@" (requestType = %d, identifier = %@)", requestType, identifier];
}

@end
