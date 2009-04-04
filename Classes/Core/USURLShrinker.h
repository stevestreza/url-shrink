//
//  USURLShrinker.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIncludes.h"

@interface USURLShrinker : NSObject {
	id _target;
	SEL _action;
}

#pragma mark Methods for subclasses

+(NSString *)name;

+(BOOL)canExpandURL:(NSURL *)url;
-(void)performExpandOnURL:(NSURL *)url;
-(void)performShrinkOnURL:(NSURL *)url;

#pragma mark Internals

+(void)registerShrinker;
-(NSString *)name;

-(void)shrinkURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action;

-(void)expandURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action;

-(void)doneExpanding:(NSURL *)url;
-(void)doneShrinking:(NSURL *)url;
@end
