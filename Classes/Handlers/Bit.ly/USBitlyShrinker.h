//
//  USBitlyShrinker.h
//  URL Shrink
//
//  Created by Christopher Najewicz on 3/11/10.
//  Copyright 2010 Futuremedia Interactive. All rights reserved.
//

#import "USURLShrinker.h"
#import "USIncludes.h"

@interface USBitlyShrinker : USURLShrinker {
	NSString *login, *apiKey;
}
@property(copy) NSString *login, *apiKey;

-(id)init;
-(id)initWithLogin:(NSString*)inlogin APIKey:(NSString*)apikey;

@end
