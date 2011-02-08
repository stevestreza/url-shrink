//
//  USBitlyShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 3/11/10.
//  Copyright 2010 Futuremedia Interactive. All rights reserved.
//

#import "USBitlyShrinker.h"


@implementation USBitlyShrinker
@synthesize login,apiKey;

-(id)init {
	if( (self = [super init]) ) {
		return self;
	} else 
		return nil;
}

-(id)initWithLogin:(NSString*)inlogin APIKey:(NSString*)apikey {
	if( (self = [super init]) ) {
		self.login =  inlogin;
		self.apiKey = apikey;
		return self;
	} else
		return nil;
}

+(NSString *)name{
	return @"bit.ly";
}

+(BOOL)requiresAPIKey {
	return YES;
}

-(void)performShrinkOnURL:(NSURL *)url{
	
	if( [self.login length] == 0 || [self.apiKey length] == 0) {
		NSLog(@"Bit.ly ERROR: Zero length API key: %@ or login name: %@",self.apiKey,self.login);
		return;
	}
	
	NSString *bitlyURL = [NSString stringWithFormat:@"http://api.bit.ly/shorten?version=2.0.1&longUrl=%@&login=%@&apiKey=%@&format=xml",[url absoluteString],self.login,self.apiKey];
	
	NSLog(@"Bit.ly URL: %@",bitlyURL);
	
	NSString *xmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:bitlyURL] encoding:NSUTF8StringEncoding error:nil];
	
	if(!xmlString){
		[self doneShrinking:url];
		return;
	}
	
	NSXMLDocument *xml = [[[NSXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil] autorelease];
	NSXMLElement *root = [xml rootElement];
	NSXMLElement *errornode = [[root elementsForName:@"errorCode"] objectAtIndex:0];
	
	NSLog(@"errornode = %@",errornode);
	if(![[errornode stringValue] isEqualToString:@"0"]){
		[self doneShrinking:url];
		return;
	}
	

	NSXMLElement *shorturl = [[[[[[root elementsForName:@"results"] objectAtIndex:0] elementsForName:@"nodeKeyVal"] objectAtIndex:0] elementsForName:@"shortUrl"] objectAtIndex:0];
	
	NSURL *newURL = [NSURL URLWithString:[shorturl stringValue]];
	
	NSLog(@"New URL: %@",	newURL);
	
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqualToString:@"bit.ly"]);
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


-(void)dealloc {
	[login release];
	[apiKey release];
	[super dealloc];
}

@end
