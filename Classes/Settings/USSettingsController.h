//
//  USSettingsController.h
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "USShrinkController.h"

#import <ShortcutRecorder/ShortcutRecorder.h>

@interface USSettingsController : NSWindowController {
	NSStatusItem *statusItem;
	NSWindow *statusItemWindow;
	IBOutlet SRRecorderControl *recorderControl;
}

+(USSettingsController *)sharedSettings;
-(USShrinkController *)shrinkController;

@end
