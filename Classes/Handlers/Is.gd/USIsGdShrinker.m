//
//  USIsGdShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIsGdShrinker.h"

@interface USIsGdShrinker (Private)
-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse;
@end

@implementation USIsGdShrinker

+(NSString *)name{
	return @"is.gd";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];

	NSError *err = nil;
	NSString *tinyURLString = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:&err];
	if(!tinyURLString || err){
		[self doneShrinking:url];
		return;
	}

	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	[self doneShrinking:tinyURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqual:@"is.gd"]);
}

-(void)performExpandOnURL:(NSURL *)url{
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self startImmediately:NO];
	[conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	[conn performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
}

@end

@implementation USIsGdShrinker (Private)

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse{
	NSURL *url = [request URL];
	if([url isEqual:sourceURL]) return request;

	[self doneExpanding:url];
	[connection cancel];
	[connection release];
	return nil;
}

@end
