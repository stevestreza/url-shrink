//
//  USNdurlShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 2/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "USNdurlShrinker.h"

@implementation USNdurlShrinker


+(NSString *)name{
	return @"ndurl";
}

+(BOOL)requiresAPIKey {
	return NO;
}

-(void)performShrinkOnURL:(NSURL *)url{
	
	NSString *shortenRequest = [NSString stringWithFormat:@"http://www.ndurl.com/api.generate/?type=web&url=%@",[url absoluteString]];
	NSURL *shortenRequestURL = [NSURL URLWithString:shortenRequest];
	id JSONObj = [[NSData dataWithContentsOfURL:shortenRequestURL] objectFromJSONData];
	NSString *shortURL = [[JSONObj objectForKey:@"data"] objectForKey:@"shortURL"];
	NSURL *newURL = [NSURL URLWithString:shortURL];
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

@end
