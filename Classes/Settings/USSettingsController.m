//
//  USSettingsController.m
//  URL Shrink
//
//  Created by Steve Streza on 3/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "USSettingsController.h"


@implementation USSettingsController

-(id)init{
	if(self = [super initWithWindowNibName:@"Settings"]){
		
	}
	return self;
}

-(USShrinkController *)shrinkController{
	return [USShrinkController sharedShrinkController];
}

@end
