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

+(void)load {
	[self registerShrinker];
}

+(NSString *)name{
	return @"is.gd";
}

+(BOOL)canExpandURL:(NSURL *)url{
	return [[url host] isEqualToString:@"is.gd"];
}

-(void)performExpandOnURL:(NSURL *)url{
	expandURL = [url copy];
	
	TCDownload *download = [[TCDownload alloc] initWithURL:expandURL];
	[download setDelegate:self];
	[download performSelectorOnMainThread:@selector(send) withObject:nil waitUntilDone:NO];
}

-(BOOL)download:(TCDownload *)download shouldRedirectToURL:(NSURL *)url{
	NSLog(@"ShouldRedirectToURL: %@",url);
	if([url isEqual:expandURL]){
		return YES;
	}else{
		[self performSelector:@selector(doneExpanding:) withObject:[[url copy] autorelease] afterDelay:0.0];
		[download cancel];
		[download release];
		return NO;
	}
}

-(void)downloadFinished:(TCDownload *)download{
	[self doneExpanding:nil];
	[download release];
}

-(void)download:(TCDownload *)download hadError:(NSError *)error{
	[self doneExpanding:nil];
	[download release];
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

@end
