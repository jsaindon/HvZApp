//
//  CRSFGetter.m
//  HVZApp
//
//  Created by jarthurcs on 4/22/14.
//  Copyright (c) 2014 LSD. All rights reserved.
//

#import "CRSFGetter.h"
#import "ASIFormDataRequest.h"

@implementation CRSFGetter

+ (NSString *)getCRSFToken:(NSURL *)url
{
    // Get the login page of the site, so that our csrf validation token can be
    // scraped from it.
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (error) {
        NSLog(@"Connection failed.");
        return @"error";
    }
    NSString *response = [request responseString];
    
    
    // Parse the csrf token out of the html returned
    NSRegularExpression *csrfToken = [NSRegularExpression regularExpressionWithPattern:@"<input type='hidden' name='csrfmiddlewaretoken' value='.*>"  options:0 error:NULL];
    
    NSRange rangeOfCell = [csrfToken rangeOfFirstMatchInString:response options:0 range:NSMakeRange(0, [response length])];
    NSString *cell = [response substringWithRange:rangeOfCell];
    NSRange tokenRange = NSMakeRange(55, 32); // The html is programmatically validated. I would not
    // do this if I didn't moderate the site in question.
    NSString *token = [cell substringWithRange:tokenRange];
    NSLog(@"%@", token);
    NSLog(@"Parsed string, returning CRSF token.");
    
    return token;
}

@end
