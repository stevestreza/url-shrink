#import <Cocoa/Cocoa.h>

#define objc_singleton(x, y) static x * y = nil; \
+ ( x * ) y {@synchronized(self) {if ( y == nil) {[[self alloc] init];}} return y;} \
+ (id)allocWithZone:(NSZone *)zone{@synchronized(self){if( y == nil) { y = [super allocWithZone:zone]; return y ;}} return nil;} \
- (id)copyWithZone:(NSZone *)zone{return self;} \
- (id)retain{return self;} \
- (unsigned)retainCount{return UINT_MAX;} \
- (void)release{} \
- (id)autorelease{return self;}

#define kUSShrinkChoiceDefaultsKey @"Shrinker"