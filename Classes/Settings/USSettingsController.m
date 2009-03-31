//
//  USSettingsController.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USSettingsController.h"
#import "MAAttachedWindow.h"

@interface NSStatusItem (hack)
- (NSRect)hackFrame;
@end

@implementation NSStatusItem (hack)
- (NSRect)hackFrame
{
	return [_fWindow frame];
}
@end

@implementation USSettingsController

objc_singleton(USSettingsController, sharedSettings)

-(id)init{
	if(self = [super initWithWindowNibName:@"Settings"]){
		[self setupStatusItem];
		[self setWindow:[USSettingsController bubbleWindowForWindow:[self window]
														 statusItem:statusItem]];
	}
	return self;
}

-(void)setupStatusItem{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	NSImage *clipboardImage = [NSImage imageNamed:@"clipboard"];
	[statusItem setImage:clipboardImage];
	
	[statusItem setHighlightMode:YES];
	
	[statusItem setTarget:self];
	[statusItem setAction:@selector(toggleWindow:)];
}

-(void)toggleWindow:sender{
	if(![[self window] isVisible]){
		[self showWindow:sender];
	}else{
		[self close];
	}
}

+(MAAttachedWindow *)bubbleWindowForWindow:(NSWindow *)window statusItem:(NSStatusItem *)aStatusItem{
	NSRect hackFrame = [aStatusItem hackFrame];
	NSPoint centerPoint = NSMakePoint(hackFrame.origin.x + (hackFrame.size.width/2.), 
									  hackFrame.origin.y - (hackFrame.size.height*3/4.));
	
	MAAttachedWindow *newWindow = [[MAAttachedWindow alloc] initWithView:[window contentView] 
														 attachedToPoint:centerPoint
																  onSide:(MAWindowPosition)MAPositionBottom	];
	
	[newWindow setLevel:NSStatusWindowLevel+1];
	
	[newWindow setBorderWidth:1.0];
	[newWindow setBorderColor:[NSColor colorWithCalibratedWhite:0.2 alpha:0.75]];
	
	return [newWindow autorelease];
}

-(USShrinkController *)shrinkController{
	return [USShrinkController sharedShrinkController];
}

@end
