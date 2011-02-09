//
//  USURLShrinker.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIncludes.h"

@interface USURLShrinker : NSObject {
	NSURL *sourceURL;
	id _target;
	SEL _action;
	id apiKey_;
	id login_;
}

@property(readonly) id apiKey, login;

#pragma mark Initialization

- (id)initWithLogin:(id)newLogin apiKey:(id)newKey;
- (id)initWithApiKey:(id)newKey;

#pragma mark Methods for subclasses

+(NSString *)name;

+(BOOL)canExpandURL:(NSURL *)url;
-(void)performExpandOnURL:(NSURL *)url;
-(void)performShrinkOnURL:(NSURL *)url;

//optional, implement these if your service requires an API key
+(BOOL)requiresAPIKey;
+(BOOL)requiresLogin;

#pragma mark Internals

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
