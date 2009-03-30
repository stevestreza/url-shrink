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

@interface USSettingsController : NSWindowController {
	IBOutlet SRRecorderControl *recorder;
}

-(USShrinkController *)shrinkController;

@end
