//
//  SDHotKeyController.h
//  ClassDumper
//
//  Created by Steven on 10/16/08.
//  Copyright 2008 Giant Robot Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PTHotKey;
@class PTKeyCombo;
@class SRRecorderControl;

@interface SDGlobalShortcutsController : NSObject {
	NSMutableArray *storedHotKeys;
}

// Use this method to get a hold of the singleton (do not create your own instance).
+ (SDGlobalShortcutsController*) sharedShortcutsController;

// Use when attacging a hotkey to a user-defaults key, control, target, and selector.
// The user-defaults key is used for automatic persistence, and is used internally
// as a unique identifier for your shortcut control and global hot key.
- (void) addShortcutFromDefaultsKey:(NSString*)defaultsKey
						withControl:(SRRecorderControl*)recorderControl
							 target:(id)target
						   selector:(SEL)action;

// This method does the same as the one above, except it sends nil for the argument
// "recorderControl". This technique is useful if you want to load a global shortcut
// earlier than the control is displayed (for example, in your preference panel).
// Simply load add the shortcut in your App Delegate, for instance, and attach later
// to the defaults key in your Preferences Controller.
- (void) addShortcutFromDefaultsKey:(NSString*)defaultsKey
							 target:(id)target
						   selector:(SEL)action;

// Use this method to attach a shortcut control to the global shortcut, via the user-
// defaults key, as described in the above method.
- (void) attachControl:(SRRecorderControl*)recorderControl
		 toDefaultsKey:(NSString*)defaultsKey;

@end
