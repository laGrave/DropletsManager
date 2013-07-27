//
//  WebAPIHTTPClient.h
//  Veropharm
//
//  Created by Игорь Мищенко on 11.03.13.
//  Copyright (c) 2013 itrack. All rights reserved.
//

#import "AFHTTPClient.h"

@interface WebAPIHTTPClient : AFHTTPClient

+(WebAPIHTTPClient*)sharedClient;

@end
