//
//  SuperCheckoutAPIEngineDelegate.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SuperCheckoutAPIEngineDelegate <NSObject>

@required
- (void)requestSucceeded:(NSString *)connectionIdentifier;
- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error;

@optional
-(void) productListReceived:(NSArray *)products forRequest:(NSString *)connectionIdentifier;
-(void) cartContentsReceived:(NSDictionary *)products forRequest:(NSString *)connectionIdentifier;
-(void) imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier;

- (void)connectionStarted:(NSString *)connectionIdentifier;
- (void)connectionFinished:(NSString *)connectionIdentifier;

@end
