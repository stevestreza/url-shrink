//
//  USAppController.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIncludes.h"
#import <Carbon/Carbon.h>
#import "USURLShrinker.h"
#import "PTHotKey.h"

@interface USAppController : NSObject {
	PTHotKey *hotKey;
}

//-(void)shrinkURL:(EventRef)ev;
-(void)shrinkURL:(id)something;
@end
