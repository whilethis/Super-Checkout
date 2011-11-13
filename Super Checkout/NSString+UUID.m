//
//  NSString+UUID.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/6/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "NSString+UUID.h"


@implementation NSString (NSString_UUID)

+ (NSString*)stringWithNewUUID {
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    NSString *newUUID = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [newUUID autorelease];
}


@end
