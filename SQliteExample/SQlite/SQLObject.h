//
//  NSObject+SQL.h
//  DMDownload
//
//  Created by detu on 16/3/16.
//  Copyright © 2016年 com.ggapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SQL)
/**
 *  传入进去一个ID 保存当前对象的值
 *  @return 返回成功 失败
 */
- (BOOL)dd_insertDataWithId:(NSString *)ID;

/**
 *  获取全部的信息
 */
- (NSArray *)dd_getAllData;
+ (NSArray *)dd_getAllData;

/**
   @return 返回传入进去ID 对应的数据
 */
- (id)dd_getDataFromId:(NSString *)ID;
+ (id)dd_getDataFromId:(NSString *)ID;

/**
 *  @return 全部删除  这个删除是把表直接删除
 */
- (BOOL)dd_deleteAll;
+ (BOOL)dd_deleteAll;
/**
  @return 删除对应ID的数据
 */
- (BOOL)dd_deleteFromId:(NSString *)ID;
+ (BOOL)dd_deleteFromId:(NSString *)ID;



@end
@interface SQCache : NSObject

+(void)setObjectKey:(id<NSCopying>)objectKey value:(id)value;

+(id)getObjectForKey:(id)key;

+(void)removeObjectForKey:(id)key;

+(NSMutableDictionary *)cacheDictionary;


@end

