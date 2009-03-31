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
#import "PTHotKeyCenter.h"

OSStatus handleShrinkHotKey(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);

OSStatus handleShrinkHotKey(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData){
    NSLog(@"YEAY WE DID A GLOBAL HOTKEY");
	USAppController *self = (USAppController *)userData;
	[self shrinkURL:anEvent];
    return noErr;
}

@implementation USAppController

-(void)awakeFromNib{
    EventTypeSpec eventType;
	
	eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
	
	InstallApplicationEventHandler(&handleShrinkHotKey,1,&eventType,self,NULL);
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeyCombo:) name:kUSKeyComboChangedNotification object:nil];
	USSettingsController *settings = [USSettingsController sharedSettings];
	[settings showWindow:self];
}

-(void)updateKeyCombo:(NSNotification *)notif{
	PTKeyCombo *keyCombo = [notif object];

	if(!hotKey){
		hotKey = [[PTHotKey alloc] initWithIdentifier:@"whee" keyCombo:keyCombo];
		[hotKey setTarget:self];
		[hotKey setAction:@selector(shrinkURL:)];
	}else{
		[[PTHotKeyCenter sharedCenter] unregisterHotKey:hotKey];
		[hotKey setKeyCombo:keyCombo];
	}
	[[PTHotKeyCenter sharedCenter] registerHotKey:hotKey];
}

//-(void)shrinkURL:(EventRef)ev{
-(void)shrinkURL:(id)something{
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	NSArray *types = [pboard types];
	NSLog(@"types! %@",types);
	
	NSString *urlString = nil;
	NSURL *url = nil;
	
	if([types containsObject:NSURLPboardType]){
		urlString = [pboard stringForType:NSURLPboardType];
	}else if([types containsObject:NSStringPboardType]){
		urlString = [pboard stringForType:NSStringPboardType];
	}
	
	//sanitize the URL string before handing it off to NSURL
	//from Dan Wood, http://stackoverflow.com/questions/192944/whats-the-best-way-to-validate-a-user-entered-url-in-a-cocoa-application
	
	if(urlString){
		urlString = NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(NULL,
																  (CFStringRef)urlString,
																  (CFStringRef)@"%+#",	// Characters to leave unescaped
																  NULL,
																  kCFStringEncodingUTF8));
	}
	
	if(urlString && !url){
		url = [NSURL URLWithString:urlString];
	}
	
	if(url){
		NSLog(@"Shrinking URL %@",url);
		
		USURLShrinker *shrinker = [[USShrinkController sharedShrinkController] shrinker];
		[shrinker shrinkURL:url target:self action:@selector(URLShrunk:)];
	}
}

-(void)URLShrunk:(NSURL *)newURL{
	if([newURL isKindOfClass:[NSString class]]){
		newURL = [NSURL URLWithString:(NSString *)newURL];
	}
	NSLog(@"whee! %@",newURL);
	
	[[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:NSURLPboardType] owner:self];
	[newURL writeToPasteboard:[NSPasteboard generalPasteboard]];
}

@end
