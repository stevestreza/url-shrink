//
//  USAppController.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Ambrosia Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>
#import "USURLShrinker.h"

@interface USAppController : NSObject {
	USURLShrinker *shrinker;
}

-(void)shrinkURL:(EventRef)ev;

@end
