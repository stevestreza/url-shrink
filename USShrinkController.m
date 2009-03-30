//
//  USShrinkController.m
//  URL Shrink
//
//  Created by Steve on 3/30/09.
//  Copyright 2009 Ambrosia Software. All rights reserved.
//

#import "USShrinkController.h"

@implementation USShrinkController

objc_singleton(USShrinkController, sharedShrinkController);

-(void)registerShrinkClass:(Class)aClass { 
	if(aClass == [USURLShrinker class]){
		NSLog(@"isa matches, not registering");
		return;
	}
		
	if(nil == shrinkers) { 
		shrinkers = [[NSMutableDictionary alloc] init];
	}
	
	NSString *className = [aClass name];
	if([shrinkers objectForKey:className]) return;
	
	NSLog(@"Adding class for %@",className);
	[shrinkers setObject:aClass forKey:className];
}

-(USURLShrinker *)shrinker{
	Class shrinkerClass = NULL;
	
	//get the user's preferred class
	NSString *defaultsValue = [[NSUserDefaults standardUserDefaults] stringForKey:kUSShrinkChoiceDefaultsKey];
	if(defaultsValue && [shrinkers objectForKey:defaultsValue]){
		shrinkerClass = [shrinkers objectForKey:defaultsValue];
	}
	
	//if there is none, grab one at random
	if(!shrinkerClass){
		NSArray *keys = [shrinkers allKeys];
		NSUInteger index = 0;
		if(keys.count > 1){
#define GetRandom(_min,_max) ((rand() % ((_max) - (_min) - 1)) + (_min))
			index = GetRandom(1, [keys count]) - 1;
		}
	
		shrinkerClass = [shrinkers objectForKey:[keys objectAtIndex:index]];
	}

	//if it exists, make one
	if(shrinkerClass){
		return [[[shrinkerClass alloc] init] autorelease];
	}else return nil;
}

@end
