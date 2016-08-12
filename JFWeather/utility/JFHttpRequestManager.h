//
//  JFHttpRequestManager.h
//  JFWeather
//
//  Created by ramborange on 16/7/27.
//  Copyright © 2016年 BlueSky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFHttpRequestManager : NSObject

+ (void)getDataWithURL:(NSString *)urlString param:(NSDictionary *)dic requestType:(NSString *)type successed:(void(^)(NSString *type,NSDictionary *response))success failed:(void(^)(NSString *type,NSError *error))fail;

+ (void)postDataWithURL:(NSString *)utlString param:(NSDictionary *)dic requestType:(NSString *)type success:(void(^)(NSString *type,NSDictionary *response))success fail:(void(^)(NSString *type,NSError *error))fail;

@end
