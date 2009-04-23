//
//  USIsGdShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIsGdShrinker.h"
#import "TCDownload.h"


@implementation USIsGdShrinker

+(NSString *)name{
	return @"is.gd";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	NSString *tinyURLString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	
	NSLog(@"tiny! %@",tinyURL);
	
	[self doneShrinking:tinyURL];	
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqual:@"is.gd"]);
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
