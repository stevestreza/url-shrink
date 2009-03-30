//
//  USIsGdShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIsGdShrinker.h"
#import "TCDownload.h"


@implementation USIsGdShrinker

+(void)load {
	[self registerShrinker];
}

+(NSString *)name{
	return @"is.gd";
}

-(void)performShrinkOnURL:(NSURL *)url{
	NSString *newURLString = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];
	
	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	NSString *tinyURLString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	NSURL *tinyURL = [NSURL URLWithString:tinyURLString];
	
	NSLog(@"tiny! %@",tinyURL);
	
	[self doneShrinking:tinyURL];	
}

@end
