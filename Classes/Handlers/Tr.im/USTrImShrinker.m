//
//  USTrImShrinker.m
//  URL Shrink
//
//  Created by Steve Streza on 4/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USTrImShrinker.h"

@implementation USTrImShrinker

+(NSString *)name{
	return @"tr.im";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *trimURL = [NSString stringWithFormat:@"http://api.tr.im/api/trim_simple?url=%@",[url absoluteString]];

	NSLog(@"Tr.im URL: %@",trimURL);

	NSError *err = nil;

	NSString *urlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:trimURL] encoding:NSUTF8StringEncoding error:&err];

	if(!urlString || err){
		[self doneShrinking:url];
		return;
	}

	urlString = [urlString substringToIndex:[urlString length]-1];
	urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	NSURL *newURL = [NSURL URLWithString:urlString];

	NSLog(@"New URL: %@ -> %@",urlString,			newURL);

	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqualToString:@"tr.im"]);
}

-(void)performExpandOnURL:(NSURL *)url{
	NSString *trimpath = [[url path] substringFromIndex:1];
	NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tr.im/api/trim_destination.xml?trimpath=%@",trimpath]];

	NSError *err = nil;
	NSString *response = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:&err];
	if(!response || err){
		[self doneExpanding:url];
		return;
	}

	NSXMLDocument *document = [[[NSXMLDocument alloc] initWithXMLString:response options:0 error:nil] autorelease];
	NSArray *destNode = [[document rootElement] nodesForXPath:@"/trim/destination" error:&err];
	if(destNode){
		NSString *expandedURL = [[destNode objectAtIndex:0] stringValue];
		if(expandedURL){
			[self doneExpanding:[NSURL URLWithString:expandedURL]];
			return;
		}
	}
	[self doneExpanding:url];
}

@end
