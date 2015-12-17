//
//  PBMTool.h
//  PleaseBaoMe
//
//  Created by why on 7/8/15.
//  Copyright (c) 2015 why. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPLogging.h"

#ifdef DEBUG
static const int httpLogLevel = HTTP_LOG_LEVEL_INFO | HTTP_LOG_FLAG_TRACE;
#else
static const int httpLogLevel = HTTP_LOG_LEVEL_OFF;
#endif

@interface PBMTool : NSObject

+ (void)start;

+ (void)setDBFilePath:(NSString*)path;

+ (NSString*)URL;

@end
