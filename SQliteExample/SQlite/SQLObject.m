//
//  NSObject+SQL.m
//  DMDownload
//
//  Created by detu on 16/3/16.
//  Copyright © 2016年 com.ggapple. All rights reserved.
//

#import "SQLObject.h"
#import "SQLiteTool.h"
#import <objc/runtime.h>

@implementation NSObject (SQL)
- (NSString *)getClassName{
    return NSStringFromClass(self.class);
}
-(NSString *)tableName{
    return [self getClassName];
}
- (NSString *)path{
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *tableName = [@"mm" stringByAppendingPathExtension:@"sqlite"];
    dbPath =  [dbPath stringByAppendingPathComponent:tableName];
    return dbPath;
}
- (SQLiteTool *)sqliteTool{
    id object =   [SQCache getObjectForKey:[self tableName]];
    if (!object) {
        return [[SQLiteTool alloc] initWithdbPath:[self path]];
    }
    return object;
}
- (BOOL)dbOpen{
    SQLiteTool *tool = [self sqliteTool];
    if (tool) {
        return [tool opendb];
    }else{
          SQLiteTool *sq = [[SQLiteTool alloc] initWithdbPath:[self path]];
        if ([sq checkTable:[self tableName]]) {
            [SQCache setObjectKey:[self tableName] value:sq];
            return YES;
        }
    }
    
    SQLog(@"not tableName  error : %@ ",[self tableName]);
    return NO;
}
-(BOOL)mm_insertDataWithId:(NSString *)ID{
    SQLiteTool *tool = [[SQLiteTool alloc] initWithdbPath:[self path]];
    [tool createTableWithName:[self getClassName]];
    BOOL isinsert  = [tool insertObject:self intoTableName:[self tableName] intoSaveID:ID];
    if (isinsert) {
        if ([SQCache getObjectForKey:[self tableName]]) {
        }else {
            [SQCache setObjectKey:[self tableName] value:tool];
        }
    }
    return isinsert;
}
-(NSArray *)mm_getAllData{
    if (![self dbOpen]) {return nil;}
   NSArray *allObjects = [[self sqliteTool] getAllObjectfromTableName:[self tableName] withClass:self.class];
    return allObjects;
}
+(NSArray *)mm_getAllData{
    id class = [[self class]new];
    NSArray *allObjects = [class mm_getAllData];
    return allObjects;
}
-(id)mm_getDataFromId:(NSString *)ID{
      [self dbOpen];

    id selfObject =  [[self sqliteTool] getObjectfromTableName:[self tableName] intoSaveID:ID withClass:[self class]];
    return selfObject;
}
+(id)mm_getDataFromId:(NSString *)ID{
    id class = [[self class] new];
    return [class mm_getDataFromId:ID];
}

-(BOOL)mm_deleteAll{
    if (![self dbOpen]) {return NO;}
     BOOL isdeleteAll =  [[self sqliteTool] deleteAllObjectfromTableName:[self tableName]];
     if (isdeleteAll == YES) {  //如果删除表的话， 把缓存里面的对应的Key也要删除
        if ([[SQCache  cacheDictionary].allKeys containsObject:[self tableName]]) {
            [SQCache removeObjectForKey:[self tableName]];
        }
    }
    return isdeleteAll;
}
+(BOOL)mm_deleteAll{
    id class = [[self class]new];
    BOOL isdeleteAll = [class mm_deleteAll];
    return isdeleteAll;
    
}

-(BOOL)mm_deleteFromId:(NSString *)ID{
    if (![self dbOpen]) {return NO;}
  BOOL isdeleteID = [[self sqliteTool]deleteObjectfromTableName:[self tableName] SaveID:ID];
  return isdeleteID;
    
}
+(BOOL)mm_deleteFromId:(NSString *)ID{
    id class = [[self class]new];
    BOOL isdeleteID = [class mm_deleteFromId:ID];
    return isdeleteID;
}
@end
const void *cacheKey;
@implementation SQCache
+(void)setObjectKey:(id<NSCopying>)objectkey value:(id)value{
    NSMutableDictionary *cacheDic = objc_getAssociatedObject(self, &cacheKey);
    if (cacheDic == nil) {
        cacheDic = [NSMutableDictionary  dictionary];
        objc_setAssociatedObject(self, &cacheKey, cacheDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    cacheDic[objectkey] = value;
}
+(id)getObjectForKey:(id)key{
    return [self cacheDictionary][key];
}
+(void)removeObjectForKey:(id)key{
   [[self cacheDictionary] removeObjectForKey:key];
}
+(NSMutableDictionary *)cacheDictionary{
    return objc_getAssociatedObject(self, &cacheKey);
}
@end
