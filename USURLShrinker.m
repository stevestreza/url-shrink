//
//  USURLShrinker.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Ambrosia Software. All rights reserved.
//

#import "USURLShrinker.h"

#import "TCDownload.h"

@implementation USURLShrinker

-(void)shrinkURL:(NSURL *)url
		  target:(id)target
		  action:(SEL)action{
	
	NSString *newURLString = [NSString stringWithFormat:@"http://is.gd/api.php?longurl=%@",[url absoluteString]];
	NSURL *newURL = [NSURL URLWithString:newURLString];

	NSData *data = [TCDownload loadResourceDataForURL:newURL];
	NSString *tinyURL = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	
	NSLog(@"tiny! %@",tinyURL);
	
	[target performSelector:action withObject:tinyURL];
}

@end
