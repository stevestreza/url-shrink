//
//  USDiggShrinker.m
//  URL Shrink
//
//  Created by Steve on 4/2/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USDiggShrinker.h"
#import "TCDownload.h"

#define kUSDiggShrinkerAPIEndpoint @"http://services.digg.com/url/short/create?url=%@"
#define kUSDiggShrinkerAppKey @"http://github.com/amazingsyco/url-shrink"

@implementation USDiggShrinker

+(NSString *)name{
	return @"Digg";
}

-(void)performShrinkOnURL:(NSURL *)url{
    
	NSString *s = [NSString stringWithFormat:kUSDiggShrinkerAPIEndpoint,
                   [[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                   ];
    
	NSURL *newURL = [NSURL URLWithString:s];
	
	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	
	NSString *xmlString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSXMLDocument *xml = [[[NSXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil] autorelease];
	
	if([[[xml rootElement] name] isEqualToString:@"error"]){
		[self doneShrinking:url];
		return;
	}
	
	NSXMLElement *shorturl = (NSXMLElement*)[[xml rootElement] childAtIndex:0];
	
	NSString *tinyURLString = [[shorturl attributeForName:@"short_url"] stringValue];
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	
	[self doneShrinking:tinyURL];
	
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqualToString:@"digg.com"]);
}

-(void)performExpandOnURL:(NSURL *)url{
	NSString *html = [TCDownload loadResourceStringForURL:url encoding:NSUTF8StringEncoding];
	NSScanner *scanner = [[NSScanner alloc] initWithString:html];
	[scanner scanUpToString:@"<iframe" intoString:nil];
	[scanner scanUpToString:@"src=\"" intoString:nil];
	
	[scanner setScanLocation:[scanner scanLocation] + ([@"src=\"" length])];
	
	NSString *source = nil;
	[scanner scanUpToString:@"\"" intoString:&source];
	
	if(source){
		NSURL *url = [NSURL URLWithString:source];
		[self doneExpanding:url];
	}
}

@end