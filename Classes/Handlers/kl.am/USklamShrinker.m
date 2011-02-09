//
//  USklamShrinker.m
//  URL Shrink
//
//  Created by Christopher Najewicz on 3/11/10.

#import "USklamShrinker.h"


@implementation USklamShrinker

-(id)init {
	if( (self = [super init]) ) {
		return self;
	} else 
		return nil;
}

+(NSString *)name{
	return @"kl.am";
}

+(BOOL)requiresAPIKey {
	return NO;
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *klamURL = [NSString stringWithFormat:@"http://kl.am/api/shorten/?format=text&url=%@",[url absoluteString]];
	NSString *klamResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:klamURL] encoding:NSUTF8StringEncoding error:nil];
	NSURL *newURL = [NSURL URLWithString:klamResult];
	[self doneShrinking:newURL];
}

+(BOOL)canExpandURL:(NSURL *)url{
	return NO;
}

@end
