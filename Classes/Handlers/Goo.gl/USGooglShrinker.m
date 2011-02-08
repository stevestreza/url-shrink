//
//  USGooglShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz 02/08/11.

#import "USGooglShrinker.h"
#import "JSONKit.h"

#define GOO_GL_BASE @"https://www.googleapis.com/urlshortener/v1/url"

@implementation USGooglShrinker

+(NSString *)name{
	return @"Goo.gl";
}

-(void)performShrinkOnURL:(NSURL *)url {
	
	/*
		Google doesn't require an API key, for shortening but recommend it for a production ready app
		See also: http://code.google.com/apis/urlshortener/v1/reference.html
	*/
	
	NSLog(@"start shrink on goo.gl");
	NSURL *googleRestRequestURL = [NSURL URLWithString:GOO_GL_BASE];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:googleRestRequestURL];
	[req setHTTPMethod:@"POST"];
	[req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSString *jsonString = [NSString stringWithFormat:@"{ \"longUrl\":\"%@\" }",[url absoluteString]];
	[req setHTTPBody:[[jsonString objectFromJSONString] JSONData]];
	NSURLResponse *response;
	NSData *receivedData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:nil];
	id resultObj = [receivedData objectFromJSONData];
	NSURL *shortURL = [NSURL URLWithString:[resultObj objectForKey:@"id"]];
	[self doneShrinking:shortURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
	// TO-DO: implement it
	//return ([(NSString *)[url host] rangeOfString:@"goo.gl"].location != NSNotFound);
}

-(void)performExpandOnURL:(NSURL *)url{
}

@end
