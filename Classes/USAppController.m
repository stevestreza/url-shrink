//
//  USAppController.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USAppController.h"
#import "USShrinkController.h"
#import "USSettingsController.h"

#import <SDGlobalShortcuts/SDGlobalShortcuts.h>

@interface USAppController (Private)
-(void)writeURL:(NSURL *)url toPasteboard:(NSPasteboard *)pboard;
@end


@implementation USAppController

-(void)awakeFromNib{
	[[SDGlobalShortcutsController sharedShortcutsController] addShortcutFromDefaultsKey:kSDShortenURLGLobalShortcutKey
																				 target:self
																			   selector:@selector(handleHotKeyEvent:)];
	
	settings = [[USSettingsController alloc] init];
	[settings showWindow:self];
}

+ (NSString*) sanitizeString:(NSString*)oldString {
	NSString *newString = (oldString);
	return (newString != nil ? newString : oldString);
}

+(NSString *)sanitizeURLString:(NSString *)urlString{
	if (urlString == nil)
		return nil;
	
	urlString = [self sanitizeString:[urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
	
	//sanitize the URL string before handing it off to NSURL
	//from Dan Wood, http://stackoverflow.com/questions/192944/whats-the-best-way-to-validate-a-user-entered-url-in-a-cocoa-application
	
	CFStringRef tempURLString = CFURLCreateStringByAddingPercentEscapes(NULL,
																		(CFStringRef)urlString,
																		(CFStringRef)@"%+#",	// Characters to leave unescaped
																		NULL,
																		kCFStringEncodingUTF8);
	
	urlString = [self sanitizeString:[NSMakeCollectable(tempURLString) autorelease]];
	
	return urlString;
}


-(void)handleHotKeyEvent:(id)sender {
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	NSString *urlString = nil;
	NSURL *url = nil;

	urlString = [USAppController sanitizeURLString:[[NSURL URLFromPasteboard:pboard] absoluteString]];
	
	if(urlString && [self validateURLString:urlString]){
		url = [NSURL URLWithString:urlString];
	}
	
	if(url){
		BOOL handled = NO;
		for(Class shrinkerClass in [[USShrinkController sharedShrinkController] allShrinkers]){
			if([shrinkerClass canExpandURL:url]){
				USURLShrinker *shrinker = [[shrinkerClass alloc] init];
				[shrinker expandURL:url target:self action:@selector(URLExpanded:)];
				handled = YES;
			}
		}
		if(!handled){
			USURLShrinker *shrinker = [[USShrinkController sharedShrinkController] shrinker];
			[shrinker shrinkURL:url target:self action:@selector(URLShrunk:)];
		}
	}
}

-(BOOL)validateURLString:(NSString *)urlString{
	NSAttributedString *tempURLString = [[NSAttributedString alloc] initWithString:urlString];
	NSURL *URL = [tempURLString URLAtIndex:0 effectiveRange:NULL];
	[tempURLString release];
	
	return (URL != nil);
}

-(void)URLExpanded:(NSURL *)newURL{
	if([newURL isKindOfClass:[NSString class]]){
		newURL = [NSURL URLWithString:(NSString *)newURL];
	}
	
	[self writeURL:newURL toPasteboard:[NSPasteboard generalPasteboard]];
}	

-(void)writeURL:(NSURL *)url toPasteboard:(NSPasteboard *)pboard{
	// Added the % decode for tinyarro.ws support, shouldn't affect other shorteners
	NSString *urlToCopy = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[pboard declareTypes:[NSArray arrayWithObjects:NSURLPboardType, NSStringPboardType,nil] owner:self];
	[pboard setString:urlToCopy forType:NSURLPboardType];
	[pboard setString:urlToCopy forType:NSStringPboardType];		
}

-(void)URLShrunk:(NSURL *)newURL{
	if([newURL isKindOfClass:[NSString class]]){
		newURL = [NSURL URLWithString:(NSString *)newURL];
	}
	
	[self writeURL:newURL toPasteboard:[NSPasteboard generalPasteboard]];
}

@end
