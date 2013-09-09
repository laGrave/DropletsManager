//
//  RequestManager.m
//  Veropharm
//
//  Created by Игорь Мищенко on 14.02.13.
//  Copyright (c) 2013 itrack. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking.h>
#import <Availability.h>
#import "WebAPIHTTPClient.h"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

static RequestManager *_sharedItem;

@interface RequestManager ()<NSXMLParserDelegate>

@end

@implementation RequestManager

+(RequestManager*)sharedItem{

    @synchronized(self) {
        if (_sharedItem == nil) {
            _sharedItem = [[RequestManager alloc] init];
        }
    }
    return _sharedItem;
}


#pragma mark -
#pragma mark - getters

- (NSString *)clientID {

    return [[NSUserDefaults standardUserDefaults] valueForKey:@"Client ID"];
}


- (NSString *)apiKey {

    return [[NSUserDefaults standardUserDefaults] valueForKey:@"API Key"];
}


#pragma mark - requests

- (void)sendGetRequestWithPath:(NSString *)path
                    parameters:(NSDictionary *)parameters
               completionBlock:(void(^)(id JSON))completionBlock {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{@"client_id" : [self clientID], @"api_key" : [self apiKey]}];
    if (parameters)
        [params setValuesForKeysWithDictionary:parameters];
    WebAPIHTTPClient *client = [WebAPIHTTPClient sharedClient];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    NSURLRequest *request = [client requestWithMethod:@"GET"
                                                 path:path
                                           parameters:params];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        completionBlock(JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
        NSLog(@"error while getting info from server: %@", error);
        completionBlock(nil);
    }];
    [operation start];
}


//get information

- (void)getDropletsListWithCompletionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:@"droplets/?" parameters:nil completionBlock:^(id JSON){
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            completionBlock(JSON[@"droplets"]);
        }
    }];
}


- (void)getDetailsForDropletWithIdentifier:(NSString *)identifier
                            completionBlock:(void(^)(id JSON))completionBlock {

    
    [self sendGetRequestWithPath:[NSString stringWithFormat:@"droplets/%@?", identifier]
                      parameters:nil
                 completionBlock:^(id JSON){
                     NSString *status = JSON[@"status"];
                     if ([status isEqualToString:@"OK"]) {
                         completionBlock(JSON[@"droplet"]);
                     }
                 }];
}


- (void)getDetailsForImageWithIdentifier:(NSString *)identifier
                         completionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:[NSString stringWithFormat:@"images/%@/??", identifier]
                      parameters:nil
                 completionBlock:^(id JSON){
                     NSString *status = JSON[@"status"];
                     if ([status isEqualToString:@"OK"]) {
                         completionBlock(JSON[@"image"]);
                     }
                 }];
}


- (void)getSizesWithCompletionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:@"sizes/?" parameters:nil completionBlock:^(id JSON){
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            completionBlock(JSON[@"sizes"]);
        }
    }];
}


- (void)getImagesWithCompletionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:@"images/?" parameters:nil completionBlock:^(id JSON){
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            completionBlock(JSON[@"images"]);
        }
    }];
}


- (void)getRegionsWithCompletionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:@"regions/?" parameters:nil completionBlock:^(id JSON){
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            completionBlock(JSON[@"regions"]);
        }
    }];
}


//operations

- (void)newDropletWithName:(NSString *)dropletName
                    sizeID:(NSString *)sizeID
                   imageID:(NSString *)imageID
                  regionID:(NSString *)regionID
                   sshKeys:(NSArray *)sshKeys
           completionBlock:(void (^)(id))completionBlock {
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"name" : dropletName, @"size_id" : sizeID , @"image_id" : imageID, @"region_id" : regionID}];
    if (sshKeys && [sshKeys count]) {
        [parameters setValue:sshKeys forKey:@"ssh_key_ids"];
    }
    [self sendGetRequestWithPath:@"droplets/new?"
                      parameters:parameters
                 completionBlock:^(id JSON){
                     NSString *status = JSON[@"status"];
                     if ([status isEqualToString:@"OK"]) {
                         completionBlock(JSON[@"droplet"]);
                     }
                 }];
}


- (void)destroyDropletWithIdentifier:(NSString *)identifier
                     completionBlock:(void(^)(id JSON))completionBlock {

    [self sendGetRequestWithPath:[NSString stringWithFormat:@"droplets/%@/destroy/?", identifier]
                      parameters:nil completionBlock:^(id JSON){
        NSString *status = JSON[@"status"];
        if ([status isEqualToString:@"OK"]) {
            completionBlock(JSON[@"event_id"]);
        }
    }];
}


- (void)shutdownDropletWithIdentifier:(NSString *)identifier
                      completionBlock:(void (^)(id))completionBlock {

    [self sendGetRequestWithPath:[NSString stringWithFormat:@"/droplets/%@/shutdown/?", identifier]
                      parameters:nil
                 completionBlock:^(id JSON){
                     NSString *status = JSON[@"status"];
                     if ([status isEqualToString:@"OK"]) {
                         completionBlock(JSON[@"event_id"]);
                     }
                 }];
}


- (void)powerOnDropletWithIdentifier:(NSString *)identifier
                     completionBlock:(void (^)(id))completionBlock {
    
    [self sendGetRequestWithPath:[NSString stringWithFormat:@"/droplets/%@/power_on/?", identifier]
                      parameters:nil
                 completionBlock:^(id JSON){
                     NSString *status = JSON[@"status"];
                     if ([status isEqualToString:@"OK"]) {
                         completionBlock(JSON[@"event_id"]);
                     }
                 }];
}

@end
