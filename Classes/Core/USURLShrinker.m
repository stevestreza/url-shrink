//
//  USURLShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USURLShrinker.h"

#import "USShrinkController.h"

@implementation USURLShrinker
@synthesize login=login_, apiKey=apiKey_;

+(BOOL)requiresAPIKey{
	return NO;
}

+(BOOL)requiresLogin {
	return NO;
}

+(id)login {
	return nil;
}

+(id)apiKey {
	return nil;
}

+(NSString*)escapeURL:(NSURL*)url {
	return [[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)name{
	return nil;
}

-(NSString *)name{
	return [[self class] name];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

- (id)initWithLogin:(id)newLogin apiKey:(id)newKey {
	if ( (self = [self initWithApiKey:newKey]) ) {
		login_ = [newLogin retain];
		return self;
	}
	return nil;
}

- (id)initWithApiKey:(id)newKey {
	if ( (self = [super init]) ) {
		apiKey_ = [newKey retain];
		return self;
	}
	return nil;
}

- (id)init {
	if ( (self = [super init]) ) {
		apiKey_ = [[self class] requiresAPIKey] ? [[self class] apiKey] : nil; 
		login_ = [[self class] requiresLogin] ? [[self class] login] : nil; 
		return self;
	}
	return nil;
}


-(void)dealloc{
	[apiKey_ release];
	[login_ release];
	[sourceURL release];
	sourceURL = nil;
	[super dealloc];
}

- (BOOL)checkForKeyAndLogin_ {
	if ([[self class] requiresLogin] && self.login == nil) {
		return NO;
	} else if ([[self class] requiresAPIKey] && self.apiKey == nil) {
		return NO;
	}
	return YES;
}

-(void)shrinkURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action{
	
	NSAssert([self checkForKeyAndLogin_],@"This shrinker requires an api key, login or both.");
	
	_target = target;
	_action = action;
	sourceURL = [url copy];
	[NSThread detachNewThreadSelector:@selector(_startShrink:) toTarget:self withObject:url];
}

-(void)_startShrink:(NSURL *)url{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[self performShrinkOnURL:url];
	[pool release];
}

-(void)_startExpand:(NSURL *)url{
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[self performExpandOnURL:url];
	[pool release];
}

-(void)performShrinkOnURL:(NSURL *)url{
	[self doneShrinking:nil];
}

-(void)performExpandOnURL:(NSURL *)url{
	[self doneExpanding:nil];
}

-(void)doneShrinking:(NSURL *)url{
	[_target performSelectorOnMainThread:_action withObject:url waitUntilDone:NO];
}

-(void)expandURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action{

	[self checkForKeyAndLogin_];
	_target = target;
	_action = action;
	sourceURL = [url copy];
	[NSThread detachNewThreadSelector:@selector(_startExpand:) toTarget:self withObject:url];	
}

-(void)doneExpanding:(NSURL *)url{
	[_target performSelectorOnMainThread:_action withObject:url waitUntilDone:NO];
}


@end
