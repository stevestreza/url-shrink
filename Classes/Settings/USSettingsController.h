//
//  USSettingsController.h
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "USShrinkController.h"

@interface USSettingsController : NSWindowController {
	IBOutlet NSStatusItem *statusItem;
}

+(USSettingsController *)sharedSettings;
-(USShrinkController *)shrinkController;

@end
