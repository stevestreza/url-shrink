//
//  USTinyurlShrinker.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USTinyurlShrinker.h"
#import "TCDownload.h"


@implementation USTinyurlShrinker

+(void)load {
	[self registerShrinker];
}

+(NSString *)name{
	return @"TinyURL";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://tinyurl.com/api-create.php?url=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	NSString *tinyURLString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	
	NSLog(@"tiny! %@",tinyURL);
	
	[self doneShrinking:tinyURL];	
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([(NSString *)[url host] rangeOfString:@"tinyurl.com"].location != NSNotFound);
}

-(void)performExpandOnURL:(NSURL *)url{
	TCDownload *download = [[TCDownload alloc] initWithURL:url];
	[download setDelegate:self];
	[download send];
}

-(BOOL)download:(TCDownload *)download shouldRedirectToURL:(NSURL *)url{
	if([url isEqual:sourceURL]) return YES;
	
	[self doneExpanding:url];
	return NO;
}

@end
