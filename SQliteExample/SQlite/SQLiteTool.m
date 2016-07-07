//
//  SQLiteTool.m
//  DMDownload
//
//  Created by detu on 16/3/1.
//  Copyright © 2016年 com.ggapple. All rights reserved.
//

#import "SQLiteTool.h"   
#import "NSObject+SQLExtension.h" 
#import <sqlite3.h>


@interface SQLiteTool(){
    sqlite3 *_db;
    NSString *_dbPath;
}
@property (strong , nonatomic) NSMutableDictionary *columnNameToIndexMap;
@end
@implementation SQLiteTool
-(instancetype)initWithdbPath:(NSString *)dbPath{
    if (self=[super init]) {
        
        if (dbPath.length && dbPath) {
            _dbPath = [dbPath copy];
        }else{
         _dbPath = SqliteDBDetu;
        }
        [self closedb];
        if ([self opendb]) {
            SQLog(@"open db sqlite succes");
        }else{
            SQLog(@"open db sqlite filure");
        }
    }
    return self;
}

-(instancetype)init{
    return [self initWithdbPath:nil];
}
-(BOOL)checkTable:(NSString *)tableName{
    [self opendb];
    char *err;
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",tableName];
    const char *sql_stmt = [sql UTF8String];
    if(sqlite3_exec(_db, sql_stmt, NULL, NULL, &err) == SQLITE_OK){
        
        return YES;
    }else{
        return NO;
        
    }
    return NO;
}
#pragma makr 打开数据库
- (BOOL)opendb{
    if (_dbPath == nil || _dbPath.length == 0) return  NO;
   int  results =  sqlite3_open(_dbPath.UTF8String, &_db);
    if (results == SQLITE_OK) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 关闭数据库
- (BOOL)closedb{
   int results = sqlite3_close(_db);
    if (results == SQLITE_OK){
        SQLog(@"db close success");
        return YES;
    }else{
        SQLog(@"sb close filure");
        return NO;
    }
}
#pragma mark 创建表格
- (BOOL)dbexecute:(NSString *)sqName{
    NSString *sql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ (id TEXT NOT NULL,object TEXT NOT NULL,time TEXT NOT NULL,PRIMARY KEY(id))",sqName];
    char *error = nil;
    int results  = sqlite3_exec(_db,sql.UTF8String, NULL, NULL, &error);
    if (results == SQLITE_OK) {
        SQLog(@"create table success");
        return YES;
    }else{
        SQLog(@"create table filure: %s",error);
        return NO;
    }
}
- (BOOL)insertObject:(NSString *)object tableName:(NSString *)tableName intoSaveID:(NSString *)saveID{
    
    sqlite3_stmt *statement;
    NSString *sql  = [NSString stringWithFormat:@"REPLACE INTO %@ (id,object,time) values(?,?,?);",tableName];
    NSString *date = [NSDate date].description;
    int results =   sqlite3_prepare_v2(_db, sql.UTF8String, -1, &statement, NULL);
    if (results != SQLITE_OK) {
        SQLog(@"insert data filure");
      return NO;
    }
    sqlite3_bind_text(statement, 1, saveID.UTF8String, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, object.UTF8String, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 3, date.UTF8String, -1, SQLITE_TRANSIENT);

    results = sqlite3_step(statement);
     sqlite3_finalize(statement);  //释放
    if (results == SQLITE_ERROR) {
        SQLog(@"insert data filure");
      return NO;
    }else{
        SQLog(@"insert data success");
     return YES;
    }
}

-(BOOL)createTableWithName:(NSString *)tableName{
    return [self dbexecute:tableName];
}
- (NSString *)jsonObjecfromObject:(id)object{
    if ([object isNoClass]) {
        SQLog(@"插入类型模型不合法");
        return nil;
    }
    
    NSMutableDictionary *dictObject = nil;
    dictObject = [object objcKeyValue];  //模型转成字典
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictObject options:0 error:&error];
    if (error) {
        SQLog(@"insert json error");
        return nil;
    }
    NSString *jsonObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonObject;
    
}

-(BOOL)insertObject:(id)object intoTableName:(NSString *)tableName intoSaveID:(NSString *)saveID{
    NSString *jsonObject = [self jsonObjecfromObject:object];
    if (jsonObject == nil){ SQLog(@"insert json error");return NO;}
     BOOL isinsert =  [self insertObject:jsonObject tableName:tableName intoSaveID:saveID];
    return isinsert;
}

-(NSArray *)getAllObjectfromTableName:(NSString *)tableName {
 __block   NSMutableArray *objecs = [NSMutableArray array];
    NSString *sqlQuery = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
      [self getAllInfoToSql:sqlQuery successInfo:^(NSMutableDictionary *intoDict) {
           [objecs addObject:intoDict[@"object"]];
      }];
    return objecs;
}

- (void)getAllInfoToSql:(NSString *)sql successInfo:(void(^)(NSMutableDictionary *intoDict))successinfo{
    if (sql.length== 0 || sql ==nil) {SQLog(@"sql filure"); return;}
    
    sqlite3_stmt * statement = [self statement_stmtSql:sql];
    if (statement) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            const unsigned char *IDs = sqlite3_column_text(statement, 0);
            const unsigned char *objects = sqlite3_column_text(statement, 1);
            const unsigned char *times = sqlite3_column_text(statement, 2);
            NSString *ID = [NSString stringWithUTF8String:(const char *)IDs];
            NSString *object = [NSString stringWithUTF8String:(const char *)objects];
            NSString *time = [NSString stringWithUTF8String:(const char *)times];
            NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
            infoDict[@"ID"] = ID;
            infoDict[@"object"] = [NSJSONSerialization JSONObjectWithData:[object dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            infoDict[@"time"]   = time;
            if (successinfo) {
                successinfo(infoDict);
            }
        }
    }
    
}

- (BOOL)updateObjectSql:(NSString *)sql callbackBlock:(void(^)(bool isSuccess))block{
   NSString *sq = [sql copy];
    char *error = nil;
    int results  = sqlite3_exec(_db,sq.UTF8String, NULL, NULL, &error);
    if (results == SQLITE_OK) {
        if (block)block(YES);
        return YES;
    }else{
        if (block)block(NO);
        return NO;
    }
}


- (sqlite3_stmt *)statement_stmtSql:(NSString *)sql{
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(_db,[sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        return statement;
    }else{
        return nil;
    }
}

-(NSArray *)getAllObjectfromTableName:(NSString *)tableName withClass:(Class)cl{
    if (cl == nil) return [self getAllObjectfromTableName:tableName];
    if ([[cl new] isNoClass]) {
        SQLog(@"读取类型模型不合法"); return @[];
    }
    NSArray *object = [self getAllObjectfromTableName:tableName];
    NSMutableArray *classObject = [NSMutableArray array];
    for (id obdict in object) {
        id ob = [[cl alloc] init];
        [ob objcValuekey:obdict];
        [classObject addObject:ob];
    }
  return classObject;
}

-(id)getObjectfromTableName:(NSString *)tableName intoSaveID:(NSString *)saveID withClass:(Class)cl{
    NSString *sql = [NSString stringWithFormat:@"SELECT  *from %@ where id = \"%@\"",tableName,saveID];
   __block id object = nil;
   [self getAllInfoToSql:sql successInfo:^(NSMutableDictionary *intoDict) {
        object = [[cl alloc]init];
       [object objcValuekey:intoDict[@"object"]];
   }];
    return object;
}

-(NSArray *)getAllOjbectsfromTableName:(NSString *)tableName sql:(NSString *)sql{
    NSString *sq = [sql copy];
    __block  NSMutableArray *objects = [NSMutableArray new];
    [self getAllInfoToSql:sq successInfo:^(NSMutableDictionary *intoDict) {
        [objects addObject:intoDict];
    }];
    return objects;
    
}
-(BOOL)deleteAllObjectfromTableName:(NSString *)tableName {
    NSString *sql = [NSString stringWithFormat:@"DELETE  from %@",tableName];
    BOOL isDelete = [self updateObjectSql:sql callbackBlock:nil];
    return isDelete;
}
-(BOOL)deleteObjectfromTableName:(NSString *)tableName SaveID:(NSString *)saveID{
    NSString *sql = [NSString stringWithFormat:@"DELETE from %@ where id = \"%@\"",tableName,saveID];
    BOOL isDelete = [self updateObjectSql:sql callbackBlock:nil];
    return isDelete;
}
- (void)deleteObjectsfromTableName:(NSString *)tableName saveIDs:(NSArray *)saveIDs completion:(void (^)(BOOL))completion{
    NSArray *deleteSaveIDs = [saveIDs mutableCopy];
    for (NSString *saveID in deleteSaveIDs) {
       BOOL isSuccess = [self deleteObjectfromTableName:tableName SaveID:saveID];
        !completion ? :completion(isSuccess);
    }
}
@end


