//
//  USTrImShrinker.m
//  URL Shrink
//
//  Created by Steve Streza on 4/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USTrImShrinker.h"
#import "TCDownload.h"

@implementation USTrImShrinker

+(NSString *)name{
	return @"tr.im";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *trimURL = [NSString stringWithFormat:@"http://api.tr.im/api/trim_simple?url=%@",[url absoluteString]];
	
	NSLog(@"Tr.im URL: %@",trimURL);
	
	NSString *urlString = [TCDownload loadResourceStringForURL: [NSURL URLWithString:trimURL] 
													  encoding: NSUTF8StringEncoding];
	
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
	NSLog(@"Parts %@ %@",
		  [url path],
		  [url fragment]);
	
	NSString *trimpath = [[url path] substringFromIndex:1];
	NSURL *newURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.tr.im/api/trim_destination.xml?trimpath=%@",trimpath]];
	
	NSString *response = [TCDownload loadResourceStringForURL:newURL encoding:NSUTF8StringEncoding];
	NSXMLDocument *document = [[[NSXMLDocument alloc] initWithXMLString:response options:0 error:nil] autorelease];
	NSError *err = nil;
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
