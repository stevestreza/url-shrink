//
//  USAppController.h
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Steve Streza. All rights reserved.
//

#import "USIncludes.h"
#import "USURLShrinker.h"

#import "USSettingsController.h"

@interface USAppController : NSObject {
	USSettingsController *settings;
}

-(BOOL)validateURLString:(NSString *)urlString;

@end
