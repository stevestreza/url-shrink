//
//  USSettingsController.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USSettingsController.h"

KeyCombo keyComboFromPTKeyCombo(PTKeyCombo *keyCombo){
	KeyCombo newCombo;
	newCombo.code = [keyCombo keyCode];
	newCombo.flags = [keyCombo modifiers];
	return newCombo;
}

PTKeyCombo* ptKeyComboFromKeyCombo(KeyCombo keyCombo){
	return [PTKeyCombo keyComboWithKeyCode:keyCombo.code modifiers:keyCombo.flags];
}

@implementation USSettingsController

objc_singleton(USSettingsController, sharedSettings)

-(id)init{
	if(self = [super initWithWindowNibName:@"Settings"]){
		id aKeyCombo = nil;
		NSDictionary *plist = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyCombo"];
		if(plist){
			aKeyCombo = [[[PTKeyCombo alloc] initWithPlistRepresentation:plist] autorelease];
		}
		if(!aKeyCombo){
			aKeyCombo = [PTKeyCombo keyComboWithKeyCode:7 // X 
											  modifiers:optionKey];
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeyCombo:) name:kUSKeyComboChangedNotification object:nil];
		[self setKeyCombo:aKeyCombo];
	}
	return self;
}

-(void)setKeyCombo:(PTKeyCombo *)aKeyCombo{
	if((keyCombo == aKeyCombo) || ([aKeyCombo isEqual:keyCombo])) return;
	
	[keyCombo release];
	keyCombo = [aKeyCombo retain];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kUSKeyComboChangedNotification object:keyCombo];
}

-(void)awakeFromNib{
	[recorder setDelegate:self];
	[self updateKeyCombo:nil];
}

-(void)updateKeyCombo:(NSNotification *)notif{
	[recorder setKeyCombo:keyComboFromPTKeyCombo(keyCombo)];
}

-(USShrinkController *)shrinkController{
	return [USShrinkController sharedShrinkController];
}

- (void)shortcutRecorder:(SRRecorderCell *)aRecorderCell keyComboDidChange:(KeyCombo)newKeyCombo{
	PTKeyCombo *aKeyCombo = ptKeyComboFromKeyCombo(newKeyCombo);
	[self setKeyCombo:aKeyCombo];
	
}
@end
