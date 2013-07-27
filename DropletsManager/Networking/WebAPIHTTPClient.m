//
//  WebAPIHTTPClient.m
//  Veropharm
//
//  Created by Игорь Мищенко on 11.03.13.
//  Copyright (c) 2013 itrack. All rights reserved.
//

#import "WebAPIHTTPClient.h"

static WebAPIHTTPClient *_sharedItem;

@implementation WebAPIHTTPClient

+(WebAPIHTTPClient*)sharedClient{
    @synchronized(self) {
        if (_sharedItem == nil) {
            _sharedItem = (WebAPIHTTPClient*)[AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"https://api.digitalocean.com/"]];
        }
    }
    return _sharedItem;
}

@end
