//
//  USDiggShrinker.m
//  URL Shrink
//
//  Created by Steve on 4/2/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USDiggShrinker.h"

#define kUSDiggShrinkerAPIEndpoint @"http://services.digg.com/url/short/create?url=%@&appkey=%@"
#define kUSDiggShrinkerAppKey @"http://github.com/amazingsyco/url-shrink"

@implementation USDiggShrinker

+(NSString *)name{
	return @"Digg";
}

-(void)performShrinkOnURL:(NSURL *)url{
    
	NSString *newURLString = [NSString stringWithFormat:
							  kUSDiggShrinkerAPIEndpoint,
							  [[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
							  kUSDiggShrinkerAppKey
							  ];
    
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSString *xmlString = [NSString stringWithContentsOfURL:newURL encoding:NSUTF8StringEncoding error:nil];
	if(!xmlString){
		[self doneShrinking:url];
		return;
	}
	
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
	BOOL isValid = YES;
	
#define URLTest(__test) if(!(__test)) isValid = NO;
	URLTest( [[url host] isEqualToString:@"digg.com"]);
	URLTest([[[url path] pathComponents] count] == 2); /* '/u12EEU' expands to ['/', 'u12EEU'] */
	
	return isValid;
}

-(void)performExpandOnURL:(NSURL *)url{
	NSError *err = nil;
	NSString *html = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
	if(!html || err){
		[self doneExpanding:url];
		return;
	}
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