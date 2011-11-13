//
//  SuperCheckoutAPIEngine.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "SuperCheckoutAPIEngine.h"
#import "SuperCheckoutRequestTypes.h"
#import "SuperCheckoutHTTPURLConnection.h"
#import "SCJSONParser.h"

#define HTTP_POST_METHOD        @"POST"
#define BASE_URL				@"www.scottpenberthy.com/fruit/api"
#define URL_REQUEST_TIMEOUT     25.0

@interface NSDictionary (MGTwitterEngineExtensions)

-(NSDictionary *)MGTE_dictionaryByRemovingObjectForKey:(NSString *)key;

@end

@interface SuperCheckoutAPIEngine (PrivateMethods)

// Utility methods
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;
- (NSString *)_encodeString:(NSString *)string;

// Connection/Request methods
- (NSString*)_sendRequest:(NSURLRequest *)theRequest withRequestType:(SuperCheckoutRequestType)requestType responseType:(SuperCheckoutResponseType)responseType;
- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params
                                body:(NSString *)body 
                         requestType:(SuperCheckoutRequestType)requestType 
                        responseType:(SuperCheckoutResponseType)responseType;

- (NSString *)_sendImageRequestWithURL:(NSString *)imageURL;
- (NSMutableURLRequest *)_baseRequestWithMethod:(NSString *)method 
                                           path:(NSString *)path 
                                    requestType:(SuperCheckoutRequestType)requestType 
                                queryParameters:(NSDictionary *)params;


// Parsing methods
- (void)_parseDataForConnection:(SuperCheckoutHTTPURLConnection *)connection;

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector;

@end


@implementation SuperCheckoutAPIEngine
@synthesize delegate;
@synthesize connections;
@synthesize APIDomain;

-(id)initWithDelegate:(NSObject<SuperCheckoutAPIEngineDelegate> *) theDelegate {
	self = [super init];
	
	if(self) {
		delegate = theDelegate;
	}
	
	return self;
}

// Utility methods
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
	// Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        NSUInteger i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}

// Connection/Request methods
- (NSString*)_sendRequest:(NSURLRequest *)theRequest withRequestType:(SuperCheckoutRequestType)requestType responseType:(SuperCheckoutResponseType)responseType
{
	// Create a connection using this request, with the default timeout and caching policy, 
    // and appropriate Twitter request and response types for parsing and error reporting.
    SuperCheckoutHTTPURLConnection *connection;
    connection = [[SuperCheckoutHTTPURLConnection alloc] initWithRequest:theRequest 
                                                            delegate:self 
                                                         requestType:requestType 
                                                        responseType:responseType];
    
    if (!connection) {
        return nil;
    } else {
        [connections setObject:connection forKey:[connection identifier]];
        [connection release];
    }
	
	if ([self _isValidDelegateForSelector:@selector(connectionStarted:)])
		[delegate connectionStarted:[connection identifier]];
    
    return [connection identifier];
}
- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params
                                body:(NSString *)body 
                         requestType:(SuperCheckoutRequestType)requestType 
                        responseType:(SuperCheckoutResponseType)responseType
{
	NSMutableURLRequest *theRequest = [self _baseRequestWithMethod:method 
                                                              path:path
													   requestType:requestType 
                                                   queryParameters:params];
    
    // Set the request body if this is a POST request.
    BOOL isPOST = (method && [method isEqualToString:HTTP_POST_METHOD]);
    if (isPOST) {
        // Set request body, if specified (hopefully so), with 'source' parameter if appropriate.
        NSString *finalBody = @"";
		if (body) {
			finalBody = [finalBody stringByAppendingString:body];
		}
		
        if (finalBody) {
            [theRequest setHTTPBody:[finalBody dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
	
	return [self _sendRequest:theRequest withRequestType:requestType responseType:responseType];
}
- (NSString *)_sendImageRequestWithURL:(NSString *)imageURL {
	NSMutableURLRequest *theRequest = [self _baseRequestWithMethod:nil path:imageURL requestType:SuperCheckoutProductImage queryParameters:nil];
	
	return [self _sendRequest:theRequest withRequestType:SuperCheckoutProductImage responseType:SuperCheckoutImage];
}

- (NSMutableURLRequest *)_baseRequestWithMethod:(NSString *)method 
                                           path:(NSString *)path 
                                    requestType:(SuperCheckoutRequestType)requestType 
                                queryParameters:(NSDictionary *)params
{
	NSString *contentType = [params objectForKey:@"Content-Type"];
	if(contentType){
		params = [params MGTE_dictionaryByRemovingObjectForKey:@"Content-Type"];
	}else{
		contentType = @"application/x-www-form-urlencoded";
	}
	
    // Construct appropriate URL string.
    NSString *fullPath = [path stringByAddingPercentEscapesUsingEncoding:NSNonLossyASCIIStringEncoding];
    if (params && ![method isEqualToString:HTTP_POST_METHOD]) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
    
	NSString *connectionType = @"http";

	NSString *urlString = nil;
	if(requestType == SuperCheckoutProductImage) {
		urlString = path;
	} else {
		urlString = [NSString stringWithFormat:@"%@://%@/%@", 
											   connectionType,
											   BASE_URL, fullPath];
	}
	
	NSURL *finalURL = [NSURL URLWithString:urlString];
    // Construct an NSMutableURLRequest for the URL and set appropriate request method.
	NSMutableURLRequest *theRequest = nil;
	theRequest = [NSMutableURLRequest requestWithURL:finalURL 
										 cachePolicy:NSURLRequestReloadIgnoringCacheData 
									 timeoutInterval:URL_REQUEST_TIMEOUT];

    if (method) {
        [theRequest setHTTPMethod:method];
    }
    
    [theRequest setHTTPShouldHandleCookies:NO];
    
	// Grab the cookies
	NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[theRequest URL]];
	NSLog(@"Sending cookies: %@", cookies);
	NSDictionary *cookieHeaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
	
	// Set the cookies on the request
	[theRequest setAllHTTPHeaderFields:cookieHeaders];
    NSLog(@"Created Request: %@", [theRequest description]);
    return theRequest;
}

// Parsing methods
- (void)_parseDataForConnection:(SuperCheckoutHTTPURLConnection *)connection {
	NSData *jsonData = [[[connection data] copy] autorelease];
    NSString *identifier = [[[connection identifier] copy] autorelease];
	
	SuperCheckoutRequestType requestType = [connection requestType];
    SuperCheckoutResponseType responseType = [connection responseType];
	
	NSURL *URL = [connection URL];

	switch ([connection responseType]) {
		case SuperCheckoutProductList:
		case SuperCheckoutCartContents:
			[SCJSONParser parserWithJSON:jsonData delegate:self connectionIdentifier:identifier requestType:requestType responseType:responseType URL:URL];
			break;
			
		default:
			break;
	}
}

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector
{
	return ((delegate != nil) && [delegate respondsToSelector:selector]);
}

#pragma mark NSURLConnection delegate methods


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}


- (void)connection:(SuperCheckoutHTTPURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // This method is called when the server has determined that it has enough information to create the NSURLResponse.
    // it can be called multiple times, for example in the case of a redirect, so each time we reset the data.
    [connection resetDataLength];
	
	NSLog(@"Saving cookies");
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
	//Save Cookie
	// If you want to get all of the cookies:
	NSArray *all = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[connection URL]];
	// Store the cookies:
	[[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:all forURL:[connection URL] mainDocumentURL:nil];
}


- (void)connection:(SuperCheckoutHTTPURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the receivedData.
    [connection appendData:data];
}


- (void)connection:(SuperCheckoutHTTPURLConnection *)connection didFailWithError:(NSError *)error
{
	NSString *connectionIdentifier = [connection identifier];
	
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)]){
		[delegate requestFailed:connectionIdentifier
					   withError:error];
	}
    
    // Release the connection.
    [connections removeObjectForKey:connectionIdentifier];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[delegate connectionFinished:connectionIdentifier];
}


- (void)connectionDidFinishLoading:(SuperCheckoutHTTPURLConnection *)connection
{
    NSInteger statusCode = [[connection response] statusCode];
	
    if (statusCode >= 400) {
        // Assume failure, and report to delegate.
        NSData *receivedData = [connection data];
        NSString *body = [receivedData length] ? [NSString stringWithUTF8String:[receivedData bytes]] : @"";
		
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [connection response], @"response",
                                  body, @"body",
                                  nil];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:statusCode userInfo:userInfo];
		if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
			[delegate requestFailed:[connection identifier] withError:error];
		
        // Destroy the connection.
        [connection cancel];
		NSString *connectionIdentifier = [connection identifier];
		[connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[delegate connectionFinished:connectionIdentifier];
        return;
    }
	
    NSString *connID = nil;
	SuperCheckoutResponseType responseType = 0;
	connID = [connection identifier];
	responseType = [connection responseType];
	
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestSucceeded:)])
		[delegate requestSucceeded:connID];
    
    NSData *receivedData = [connection data];
    if (receivedData) {
        if (responseType == SuperCheckoutImage) {
			// Create image from data.
            UIImage *image = [[[UIImage alloc] initWithData:[connection data]] autorelease];

            // Inform delegate.
			if ([self _isValidDelegateForSelector:@selector(imageReceived:forRequest:)])
				[delegate imageReceived:image forRequest:[connection identifier]];
        } else {
            // Parse data from the connection (either XML or JSON.)
            [self _parseDataForConnection:connection];
        }
		
//		if(responseType == SuperCheckoutCheckoutResponse) {
//			
//			//Clear cookies
//			__block NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//			NSArray *cookies = [cookieStorage cookiesForURL:[connection URL]];
//			
//			[cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//				[cookieStorage deleteCookie:obj];
//			}];
//		}
    }
	
    // Release the connection.
    [connections removeObjectForKey:connID];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[delegate connectionFinished:connID];
}

#pragma mark - SCJSONParserDelegate Methods
-(void)parsingSucceededForRequest:(NSString *)identifier ofResponseType:(SuperCheckoutResponseType)responseType parsedObjects:(NSDictionary *)parsedObject {
	switch (responseType) {
		case SuperCheckoutProductList:
			if([self _isValidDelegateForSelector:@selector(productListReceived:forRequest:)]) {
				[delegate productListReceived:[parsedObject objectForKey:@"result"] forRequest:identifier];
			}
			break;
		case SuperCheckoutCartContents:
			if([self _isValidDelegateForSelector:@selector(cartContentsReceived:forRequest:)]) {
				[delegate cartContentsReceived:[parsedObject objectForKey:@"result"] forRequest:identifier];
			}
			
		default:
			break;
	}
}

#pragma mark - API Methods


-(NSString *) getProducts {
	return [self _sendRequestWithMethod:nil path:@"products" queryParameters:nil body:nil requestType:SuperCheckoutProducts responseType:SuperCheckoutProductList];
}

-(NSString *) getImageForProduct:(NSString *)imageURL {
	return [self _sendImageRequestWithURL:imageURL];
}

-(NSString *) buyProduct:(NSNumber *)productId withQuantity:(NSNumber *)quantity {
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	
	[options setValue:[NSString stringWithFormat:@"%i", [productId intValue]] forKey:@"id"];
	[options setValue:[NSString stringWithFormat:@"%i", [quantity intValue]] forKey:@"quantity"];
	
	return [self _sendRequestWithMethod:nil path:@"add" queryParameters:options body:nil requestType:SuperCheckoutBuy responseType:SuperCheckoutCartContents];
}

-(NSString *) removeProductFromCart:(NSNumber *)productId withQuantity:(NSNumber *)quantity {
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	
	[options setValue:[NSString stringWithFormat:@"%i", [productId intValue]] forKey:@"id"];
	[options setValue:[NSString stringWithFormat:@"%i", [quantity intValue]] forKey:@"quantity"];
	
	return [self _sendRequestWithMethod:nil path:@"delete" queryParameters:options body:nil requestType:SuperCheckoutDelete responseType:SuperCheckoutCartContents];
}

-(NSString *) getCart {
	return [self _sendRequestWithMethod:nil path:@"cart" queryParameters:nil body:nil requestType:SuperCheckoutCart responseType:SuperCheckoutCartContents];
}

-(NSString *) checkout {
	return [self _sendRequestWithMethod:nil path:@"checkout" queryParameters:nil body:nil requestType:SuperCheckoutCheckout responseType:SuperCheckoutCartContents];
}

@end
