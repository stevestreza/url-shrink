//
//  USAppController.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Ambrosia Software. All rights reserved.
//

#import "USAppController.h"
#import <Carbon/Carbon.h>

OSStatus handleShrinkHotKey(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData);

OSStatus handleShrinkHotKey(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData){
    NSLog(@"YEAY WE DID A GLOBAL HOTKEY");
	USAppController *self = (USAppController *)userData;
	[self shrinkURL:anEvent];
    return noErr;
}

@implementation USAppController

-(void)awakeFromNib{
	EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec eventType;
	
	eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
	
	InstallApplicationEventHandler(&handleShrinkHotKey,1,&eventType,NULL,NULL);
	
	myHotKeyID.signature='mhk1';
    myHotKeyID.id=1;
	
	RegisterEventHotKey(7, optionKey, myHotKeyID, GetApplicationEventTarget(), self, &myHotKeyRef);
}

-(void)shrinkURL:(EventRef)ev{
	
}

@end
