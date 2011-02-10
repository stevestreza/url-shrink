//
//  USSettingsController.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USSettingsController.h"
#import "MAAttachedWindow.h"
#import <SDGlobalShortcuts/SDGlobalShortcuts.h>

@interface USSettingsController (Private)
- (void) setupStatusItem;
+(MAAttachedWindow *)bubbleWindowForWindow:(NSWindow *)window atFrame:(NSRect)hackFrame;
@end

@implementation USSettingsController

-(id)init{
	if(self = [super initWithWindowNibName:@"Settings"]){
		[self setupStatusItem];
		[self setWindow:[USSettingsController bubbleWindowForWindow:[self window]
															atFrame:[statusItemWindow frame]]];
	}
	return self;
}

- (void) awakeFromNib {
	[[SDGlobalShortcutsController sharedShortcutsController] attachControl:recorderControl
															 toDefaultsKey:kSDShortenURLGLobalShortcutKey];
}

-(void)setupStatusItem{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	
	[statusItem setView:[[[NSView alloc] init] autorelease]];
	statusItemWindow = [[statusItem view] window];
	[statusItem setView:nil];
	
	NSImage *menuBarIcon = [NSImage imageNamed:@"menubar-icon"];
	[statusItem setImage:menuBarIcon];
	
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

+(MAAttachedWindow *)bubbleWindowForWindow:(NSWindow *)window atFrame:(NSRect)hackFrame {
//	NSDisableScreenUpdates();
//	NSEnableScreenUpdates();
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
