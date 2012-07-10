//
//  USTinyurlShrinker.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USTinyurlShrinker.h"

@interface USTinyurlShrinker (Private)
-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse;
@end


@implementation USTinyurlShrinker

+(NSString *)name{
	return @"TinyURL";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSError *err = nil;
	NSString *tinyURLString = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:&err];
	if(!tinyURLString || err){
		NSLog(@"Error in tinyurl!");
		[self doneShrinking:url];
		return;
	}
	
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	[self doneShrinking:tinyURL];	
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([(NSString *)[url host] rangeOfString:@"tinyurl.com"].location != NSNotFound);
}

-(void)performExpandOnURL:(NSURL *)url{
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self startImmediately:NO];
	[conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
	[conn performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
}

@end

@implementation USTinyurlShrinker (Private)

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