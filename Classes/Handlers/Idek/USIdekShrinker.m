//
//  USIdekShrinker.m
//  URL Shrink
//
//  Created by Jorge Pedroso 
//  Twitter: http://twitter.com/jpedroso
//  Email:   jpedroso@unsolicitedfeedback.com
//  All code is provided under the New BSD license.
//

#import "USIdekShrinker.h"

#define kUSIdekAppKey             @"http://github.com/amazingsyco/url-shrink"
#define kUSIdekShrinkerAPIEnpoint @"http://idek.net/c.php?idek-api=true&idek-ref=%@&idek-url=%@"
#define kUSIdekExpanderAPIEnpoint @"%@?idek-api=true"

@implementation USIdekShrinker

+ (NSString *)name 
{
    return @"idek";
}


+ (BOOL)canExpandURL:(NSURL *)URL 
{
	return [[URL host] isEqualToString:@"idek.net"];
}


- (void)performShrinkOnURL:(NSURL *)URL 
{
    // prepare request
    NSString *s = [NSString stringWithFormat:kUSIdekShrinkerAPIEnpoint, 
                   kUSIdekAppKey, [URL absoluteString]];
    NSURL *shrinkURL = [NSURL URLWithString:s]; // assumes that the original URL is sanitized.
    
    // do request
    NSString *shrinkResult = [NSString stringWithContentsOfURL:shrinkURL];
    
    // wrap result and delegate
    NSURL *shrunkenURL = [NSURL URLWithString:shrinkResult];
    [self doneShrinking:shrunkenURL];
}


- (void)performExpandOnURL:(NSURL *)URL
{
    // prepare request
    NSString *s = [NSString stringWithFormat:kUSIdekExpanderAPIEnpoint, [URL absoluteString]];
    NSURL *expandURL = [NSURL URLWithString:s];
    
    //do request
    NSString *expandResult = [NSString stringWithContentsOfURL:expandURL];
    
    // wrap result and delegate
    NSURL *expandedURL = [NSURL URLWithString:expandResult];
    [self doneExpanding:expandedURL];
}

@end
