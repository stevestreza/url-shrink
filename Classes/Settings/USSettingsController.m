//
//  USSettingsController.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USSettingsController.h"
#import "MAAttachedWindow.h"

@implementation USSettingsController

objc_singleton(USSettingsController, sharedSettings)

-(id)init{
	if(self = [super initWithWindowNibName:@"Settings"]){
		[self setWindow:[USSettingsController bubbleWindowForWindow:[self window]]];
	}
	return self;
}

+(MAAttachedWindow *)bubbleWindowForWindow:(NSWindow *)window{
	NSRect frame = [[NSScreen mainScreen] frame];
	
	MAAttachedWindow *newWindow = [[MAAttachedWindow alloc] initWithView:[window contentView] 
														 attachedToPoint:NSMakePoint(frame.size.width / 2, frame.size.height-25) 
																  onSide:(MAWindowPosition)MAPositionBottom	];
	
	[newWindow setBorderWidth:1.0];
	[newWindow setBorderColor:[NSColor colorWithCalibratedWhite:0.2 alpha:0.75]];
	
	return [newWindow autorelease];
}

-(USShrinkController *)shrinkController{
	return [USShrinkController sharedShrinkController];
}

@end
