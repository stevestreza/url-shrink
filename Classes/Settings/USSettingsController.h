//
//  USSettingsController.h
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SRRecorderControl.h"
#import "USShrinkController.h"
#import "PTKeyCombo.h"

#define kUSKeyComboChangedNotification @"kUSKeyComboChangedNotification"

@interface USSettingsController : NSWindowController {
	IBOutlet SRRecorderControl *recorder;
	
	PTKeyCombo *keyCombo;
}

+(USSettingsController *)sharedSettings;
-(USShrinkController *)shrinkController;

@end
