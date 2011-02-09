//
//  USBitlyShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 3/11/10.

#import "USBitlyShrinker.h"

#define BIT_LY_BASE_URL @"http://api.bit.ly/v3/"

@implementation USBitlyShrinker

+ (NSString *)name{	return @"bit.ly"; }
+ (BOOL)requiresLogin {	return YES; }
+ (BOOL)requiresAPIKey { return YES; }

-(void)performShrinkOnURL:(NSURL *)url{
	if( [self.login length] == 0 || [self.apiKey length] == 0) {
		NSLog(@"Bit.ly ERROR: Zero length API key: %@ or login name: %@",self.apiKey,self.login);
		return;
	}
	
	NSString *bitlyURL = [NSString stringWithFormat:@"%@shorten?longUrl=%@&login=%@&apiKey=%@&format=xml",BIT_LY_BASE_URL,[url absoluteString],self.login,self.apiKey];
	NSString *xmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:bitlyURL] encoding:NSUTF8StringEncoding error:nil];
	
	if(!xmlString){
		[self doneShrinking:url];
		return;
	}
	
	NSXMLDocument *xml = [[[NSXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil] autorelease];
	NSXMLElement *root = [xml rootElement];
	NSXMLElement *errornode = [[root elementsForName:@"errorCode"] objectAtIndex:0];
	
	if(![[errornode stringValue] isEqualToString:@"0"]){
		[self doneShrinking:url];
		return;
	}
	
	NSXMLElement *shorturl = [[[[[[root elementsForName:@"results"] objectAtIndex:0] elementsForName:@"nodeKeyVal"] objectAtIndex:0] elementsForName:@"shortUrl"] objectAtIndex:0];
	NSURL *newURL = [NSURL URLWithString:[shorturl stringValue]];
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqualToString:[[self class] name]]);
}

-(void)performExpandOnURL:(NSURL *)url{
	[self doneExpanding:url];
}

@end
