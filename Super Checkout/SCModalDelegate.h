//
//  SCModalDelegate.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SCModalDelegate <NSObject>

-(void) viewController:(UIViewController *)vc didFinishWithData:(id) data;
-(void) viewControllerDidCancel:(UIViewController *)vc;

@end
