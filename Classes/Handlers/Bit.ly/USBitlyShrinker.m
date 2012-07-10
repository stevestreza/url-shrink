//
//  USBitlyShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 3/11/10.

#import "USBitlyShrinker.h"
#import "JSONKit.h"

#define BIT_LY_BASE_URL @"http://api.bit.ly/v3/"

@implementation USBitlyShrinker

+ (NSString *)name{	return @"bit.ly"; }
+ (BOOL)requiresLogin {	return YES; }
+ (BOOL)requiresAPIKey { return YES; }

-(void)performShrinkOnURL:(NSURL *)url{
	NSError *bitlyError = nil;
	
	NSString *fixedURL = [USURLShrinker escapeURL:url];
	NSString *bitlyURL = [NSString stringWithFormat:@"%@shorten?longUrl=%@&login=%@&apiKey=%@",BIT_LY_BASE_URL,fixedURL,self.login,self.apiKey];
	NSString *xmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:bitlyURL] encoding:NSUTF8StringEncoding error:&bitlyError];
	
	if (bitlyError) {
		NSLog(@"Error shrinking bit.ly URL - %@",bitlyError);
		[self doneShrinking:nil];
		return;
	}
	
	id resultObj = [xmlString objectFromJSONString];
	
	if ([[resultObj objectForKey:@"status_code"] intValue] != 200) {
		NSLog(@"Error from bit.ly status code = %i : \"%@\"",[[resultObj objectForKey:@"status_code"] intValue],[resultObj objectForKey:@"status_txt"]);
		[self doneShrinking:nil];
		return;
	}
	
	NSString *shortenedURLString = [[resultObj objectForKey:@"data"] objectForKey:@"url"];
	[self doneShrinking:[NSURL URLWithString:shortenedURLString]];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return ([[url host] isEqualToString:[[self class] name]]);
}

-(void)performExpandOnURL:(NSURL *)url{
	[self doneExpanding:url];
}

@end
