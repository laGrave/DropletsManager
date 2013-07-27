//
//  RequestManager.h
//  Veropharm
//
//  Created by Игорь Мищенко on 14.02.13.
//  Copyright (c) 2013 itrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Question;

@interface RequestManager : NSObject

+ (RequestManager*)sharedItem;


//get information
- (void)getDropletsListWithCompletionBlock:(void(^)(id JSON))completionBlock;
- (void)getDetailsForDropletWithIdentifier:(NSString *)identifier
                        completionBlock:(void(^)(id JSON))completionBlock;
- (void)getDetailsForImageWithIdentifier:(NSString *)identifier
                         completionBlock:(void(^)(id JSON))completionBlock;
- (void)getSizesWithCompletionBlock:(void(^)(id JSON))completionBlock;
- (void)getImagesWithCompletionBlock:(void(^)(id JSON))completionBlock;
- (void)getRegionsWithCompletionBlock:(void(^)(id JSON))completionBlock;


//operations
- (void)newDropletWithName:(NSString *)dropletName
                    sizeID:(NSString *)sizeID
                   imageID:(NSString *)imageID
                  regionID:(NSString *)regionID
                   sshKeys:(NSArray *)sshKeys
           completionBlock:(void (^)(id))completionBlock;
- (void)destroyDropletWithIdentifier:(NSString *)identifier
                     completionBlock:(void(^)(id JSON))completionBlock;
- (void)shutdownDropletWithIdentifier:(NSString *)identifier
                      completionBlock:(void(^)(id JSON))completionBlock;
- (void)powerOnDropletWithIdentifier:(NSString *)identifier
                     completionBlock:(void (^)(id))completionBlock;


@end