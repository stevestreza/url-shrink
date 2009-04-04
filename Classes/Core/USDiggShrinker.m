//
//  USDiggShrinker.m
//  URL Shrink
//
//  Created by Steve on 4/2/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USDiggShrinker.h"
#import "TCDownload.h"

@implementation USDiggShrinker

+(void)load {
	[self registerShrinker];
}

+(NSString *)name{
	return @"Digg";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://services.digg.com/url/short/create?url=%@",[[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	
	NSString *xmlString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSXMLDocument *xml = [[[NSXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil] autorelease];
	
	if([[[xml rootElement] name] isEqualToString:@"error"]){
		[self doneShrinking:url];
		return;
	}
	
	NSXMLElement *shorturl = [[xml rootElement] childAtIndex:0];
	
	NSString *tinyURLString = [[shorturl attributeForName:@"short_url"] stringValue];
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	
	[self doneShrinking:tinyURL];
	
}

@end