//
//  USURLShrinker.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIncludes.h"

#define kSDShortenURLGLobalShortcutKey @"kSDShortenURLGLobalShortcutKey"

@interface USURLShrinker : NSObject {
	NSURL *sourceURL;
	
	id _target;
	SEL _action;
}

#pragma mark Methods for subclasses

+(NSString *)name;

+(BOOL)canExpandURL:(NSURL *)url;
-(void)performExpandOnURL:(NSURL *)url;
-(void)performShrinkOnURL:(NSURL *)url;

//optional, implement these if your service requires an API key
+(BOOL)requiresAPIKey;
+(id)APIKey;

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
