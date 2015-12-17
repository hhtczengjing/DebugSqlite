//
//  PBMHTTPConnection.m
//  PleaseBaoMe
//
//  Created by why on 7/7/15.
//  Copyright (c) 2015 why. All rights reserved.
//



#import "FMDB.h"
#import "HTTPDynamicFileResponse.h"
#import "PBMHTTPConnection.h"
#import "PBMHTMLBuilder.h"
#import "NSURL+Param.h"

static NSString *kDBPath;

@implementation PBMHTTPConnection

#pragma mark - HTTPConnection Override

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
    
    NSLog(@"%@", path);
    
    if ([path hasPrefix:@"/bower_components"]) {
        return [super httpResponseForMethod:method URI:path];
    }
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:[NSURL URLWithString:@"http://blog.devzeng.com"]];
    NSLog(@"%@ %@", [url path], [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    
    FMDatabase *db = [FMDatabase databaseWithPath:kDBPath];
    if (![db open]) {
        return nil;
    }
    
    NSArray *tableNames = [self htmlForTableNameListWithDB:db];
    NSString *tableListHTML = [PBMHTMLBuilder getTableListWithTables:tableNames];

    NSDictionary *dict = nil;
    NSString *redirectURL = @"/index.html";
    if([path isEqualToString:@"/"]) {
        dict = @{@"PLEASE_BAO_ME": tableListHTML};
    }
    else if ([[url path] isEqualToString:@"/result.html"]) {
        redirectURL = @"/result.html";
        NSDictionary *params = [url parameters];
        NSString *action = [params objectForKey:@"action"];
        if([action isEqualToString:@"table"]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [params objectForKey:@"table"]];
            NSString *tableListHTML = [self getTableContentWithDB:db andSQL:sql];
            dict = @{@"PLEASE_BAO_ME": tableListHTML, @"SQL_QUERY":sql};
        }
        else if ([action isEqualToString:@"drop"]) {
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", [params objectForKey:@"table"]];
            if([db executeUpdate:sql]) {
                dict = @{@"PLEASE_BAO_ME": @"<tr><td>删除完成.</td></tr>", @"SQL_QUERY":[params objectForKey:@"sql"]};
            }
            else {
                dict = @{@"PLEASE_BAO_ME": @"<tr><td>删除出错.</td></tr>", @"SQL_QUERY":[params objectForKey:@"sql"]};
            }
        }
        else if ([action isEqualToString:@"sql"]) {
            NSString *tableListHTML = [self getTableContentWithDB:db andSQL:[params objectForKey:@"sql"]];
            dict = @{@"PLEASE_BAO_ME": tableListHTML, @"SQL_QUERY":[params objectForKey:@"sql"]};
        }
    }
    
    [db close];
    
    return [[HTTPDynamicFileResponse alloc] initWithFilePath:[self filePathForURI:redirectURL]
                                                  forConnection:self
                                                      separator:@"%%"
                                          replacementDictionary:dict];
}


#pragma mark - Private

- (NSArray*)htmlForTableNameListWithDB:(FMDatabase*)db {
    FMResultSet *s = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type = 'table'"];
    NSMutableArray *tableNameArray = [NSMutableArray array];
    while ([s next]) {
        [tableNameArray addObject:[s stringForColumnIndex:0]];
    }
    return tableNameArray;
}

- (NSString*)getTableContentWithDB:(FMDatabase*)db andSQL:(NSString*)sql {
    FMResultSet *s = [db executeQuery:sql];
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    NSMutableOrderedSet *cols = [NSMutableOrderedSet orderedSet];
    while ([s next]) {
        for (int i = 0; i < s.columnCount; i++) {
            NSString *colName = [s columnNameForIndex:i];
            NSString *value   = [NSString stringWithFormat:@"%@", [s objectForColumnIndex:i]];
            NSMutableArray *array = [NSMutableArray arrayWithArray:resultDic[colName]];
            [array addObject:value];
            resultDic[colName] = array;
            [cols addObject:colName];
        }
    }
    return [PBMHTMLBuilder getTableContentWithHeaders:[cols array] andContent:resultDic];
}


#pragma mark - Public
+(void)setDBFilePath:(NSString*)path {
    kDBPath = path;
}
@end
