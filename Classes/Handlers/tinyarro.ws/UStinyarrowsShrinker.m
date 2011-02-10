//
//  UStinyarrowsShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 2/7/11.

#import "UStinyarrowsShrinker.h"

@implementation UStinyarrowsShrinker

#define TINYARRO_WS_BASE_URL @"http://tinyarro.ws/api-create.php?utfpure=0&"
#define TINYARRO_WS_HOST_TO_USE @"xn--ogi.ws"
/*
 xn--ogi.ws for ➨.ws
 xn--vgi.ws for ➯.ws
 xn--3fi.ws for ➔.ws
 xn--egi.ws for ➞.ws
 xn--9gi.ws for ➽.ws
 xn--5gi.ws for ➹.ws
 xn--1ci.ws for ✩.ws
 xn--odi.ws for ✿.ws
 xn--rei.ws for ❥.ws
 xn--cwg.ws for ›.ws
 xn--bih.ws for ⌘.ws
 xn--fwg.ws for ‽.ws
 xn--l3h.ws for ☁.ws
 ta.gd for ta.gd
*/

+(NSString *)name{
	return @"tinyarro.ws";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *fixedURLString = [USURLShrinker escapeURL:url];
	NSString *shortenRequest = [NSString stringWithFormat:@"%@host=%@&url=%@",TINYARRO_WS_BASE_URL,TINYARRO_WS_HOST_TO_USE,fixedURLString];
	NSURL *newURL = [NSURL URLWithString:
					 [[NSString stringWithContentsOfURL:[NSURL URLWithString:shortenRequest] encoding:NSUTF8StringEncoding error:nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
					  ];
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

@end