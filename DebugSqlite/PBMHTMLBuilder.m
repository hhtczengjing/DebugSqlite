//
//  PBMHTMLBuilder.m
//  PleaseBaoMe
//
//  Created by why on 7/7/15.
//  Copyright (c) 2015 why. All rights reserved.
//

#import "PBMHTMLBuilder.h"

@implementation PBMHTMLBuilder

+(NSString*)getTableListWithTables:(NSArray*)tables {
    
    NSArray *headers = @[@"序号", @"名称", @"记录条数", @"操作"];
    
    NSMutableString *pageSource = [NSMutableString string];
    [pageSource appendFormat:@"<thead><tr>"];
    for (NSString *key in headers) {
        [pageSource appendFormat:@"<th>%@</th>", key];
    }
    [pageSource appendFormat:@"</tr></thead>"];
    
    int lines = tables.count;
    [pageSource appendFormat:@"<tbody>"];
    for (int i = 0; i < lines; i++) {
        [pageSource appendFormat:@"<tr>"];
        [pageSource appendFormat:@"<td>%@</td>", @(i+1)];
        [pageSource appendFormat:@"<td>%@</td>", tables[i]];
        [pageSource appendFormat:@"<td>%@</td>", @""];
        [pageSource appendFormat:@"<td><a href='result.html?action=drop&table=%@'>清空</a> | <a href='result.html?action=table&table=%@'>查看</a></td>", tables[i], tables[i]];
        [pageSource appendFormat:@"</tr>"];
    }
    [pageSource appendFormat:@"</tbody>"];
    
    return pageSource;
}

+ (NSString *)getTableContentWithHeaders:(NSArray *)headers andContent:(NSDictionary *)dictionary {
    if (dictionary.allValues.count < 1) {
        return @"";
    }
    NSArray *fisrtArray = dictionary.allValues[0];
    NSInteger lines = fisrtArray.count;
    NSMutableString *pageSource = [NSMutableString string];
    
    // build table header
    [pageSource appendFormat:@"<thead><tr>"];
    for (NSString *key in headers) {
        [pageSource appendFormat:@"<th>%@</th>", key];
    }
    [pageSource appendFormat:@"</tr></thead>"];
    
    // build table
    [pageSource appendFormat:@"<tbody>"];
    for (int i = 0; i < lines; i++) {
        [pageSource appendFormat:@"<tr>"];
        for (int j = 0; j < headers.count; j++) {
            NSString *colName = headers[j];
            NSArray *tempArray = dictionary[colName];
            [pageSource appendFormat:@"<td>%@</td>", tempArray[i]];
        }
        [pageSource appendFormat:@"</tr>"];
    }
    [pageSource appendFormat:@"</tbody>"];
    return pageSource;
}



@end
