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

OSStatus USAppController_handleHotKeyPress(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData){
	USAppController *self = (USAppController *)userData;
	[self handleHotKeyEvent:anEvent];
    return noErr;	
}

@implementation USAppController

-(void)awakeFromNib{
	USSettingsController *settings = [USSettingsController sharedSettings];
	[settings showWindow:self];
	
	[self setupKeyboardHandlers];
}

-(void)setupKeyboardHandlers{
	EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec eventType;
	
	eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
	
	InstallApplicationEventHandler(&USAppController_handleHotKeyPress,1,&eventType,(void*)self,NULL);
	
	myHotKeyID.signature='mhk1';
    myHotKeyID.id=1;
	
	RegisterEventHotKey(49, shiftKey+optionKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
}

+(NSString *)sanitizeURLString:(NSString *)urlString{
	if(!urlString) return;
	
	NSString *newString = nil;

#define SanitizeString(__fn) do{newString=(__fn); if(newString){ urlString = newString; }}while(0)

	SanitizeString([urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
	
	//sanitize the URL string before handing it off to NSURL
	//from Dan Wood, http://stackoverflow.com/questions/192944/whats-the-best-way-to-validate-a-user-entered-url-in-a-cocoa-application
	
	SanitizeString(NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(NULL,
																		  (CFStringRef)urlString,
																		  (CFStringRef)@"%+#",	// Characters to leave unescaped
																		  NULL,
																		  kCFStringEncodingUTF8)));

	return urlString;
#undef SanitizeString
}

//-(void)shrinkURL:(id)something{
-(void)handleHotKeyEvent:(EventRef)ev{
	NSPasteboard *pboard = [NSPasteboard generalPasteboard];
	NSArray *types = [pboard types];

	NSString *urlString = nil;
	NSURL *url = nil;
	
	if([types containsObject:NSURLPboardType]){
		urlString = [pboard stringForType:NSURLPboardType];
	}else if([types containsObject:NSStringPboardType]){
		urlString = [pboard stringForType:NSStringPboardType];
	}
	
	urlString = [USAppController sanitizeURLString:urlString];
	
	if(urlString && [self validateURLString:urlString]){
		url = [NSURL URLWithString:urlString];
	}
	
	if(url){
		NSLog(@"Shrinking URL %@",url);
		
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
	BOOL isValid = YES;
	if(![[[urlString substringToIndex:4] lowercaseString] isEqualToString:@"http"]){
		isValid = NO;
	}
	
	return isValid;
}

-(void)URLExpanded:(NSURL *)newURL{
	if([newURL isKindOfClass:[NSString class]]){
		newURL = [NSURL URLWithString:(NSString *)newURL];
	}
	
	[self writeURL:newURL toPasteboard:[NSPasteboard generalPasteboard]];
}	

-(void)writeURL:(NSURL *)url toPasteboard:(NSPasteboard *)pboard{
	[pboard declareTypes:[NSArray arrayWithObjects:NSURLPboardType, NSStringPboardType,nil] owner:self];
	[pboard setString:[url absoluteString] forType:NSURLPboardType];
	[pboard setString:[url absoluteString] forType:NSStringPboardType];		
}

-(void)URLShrunk:(NSURL *)newURL{
	if([newURL isKindOfClass:[NSString class]]){
		newURL = [NSURL URLWithString:(NSString *)newURL];
	}
	
	[self writeURL:newURL toPasteboard:[NSPasteboard generalPasteboard]];
}

@end
