//
//  USqrcxShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 2/7/11.

#import "USqrcxShrinker.h"

@implementation USqrcxShrinker

+(NSString *)name{
	return @"qr.cx";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *shortenRequest = [NSString stringWithFormat:@"http://qr.cx/api/?longurl=%@",[url absoluteString]];
	NSURL *shortenRequestURL = [NSURL URLWithString:shortenRequest];
	NSURL *newURL = [NSURL URLWithString:[NSString stringWithContentsOfURL:shortenRequestURL encoding:NSUTF8StringEncoding error:nil]];
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

@end
