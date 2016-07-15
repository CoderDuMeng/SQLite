//
//  main.m
//  SQliteExample
//  示例demo  参考


#import <Foundation/Foundation.h>
#import "Persion.h"
#import "SQLObject.h"    //存储管理    分类
#import "SQLiteTool.h"  
#import "NSObject+SQLExtension.h"

//以下方法自己调用试试


//----------------------------------------SQLObject  model 分类


//存储一个简单的人类   和读取
void insertObject(){
    //初始化一个模型
    Persion *per = [[Persion alloc] init];
    per.age = 10;
    per.name = @"DumengDemo";
    per.girlfriend = @"美女";
    per.price = 100000;
    per.working = @"iOS";
    per.car = @"路虎";
    
    //存入数据库  通过一个key
  BOOL isyes =   [per dd_insertDataWithId:@"per1"];
    if (isyes) {
        NSLog(@"插入数据成功");
    }else{
        
        NSLog(@"插入数据失败");
    }
    
    
    
}

//读取对应的key
void getObjectForKey(){
    Persion *per = [[Persion alloc] init];
    //获取对应的数据
    Persion *per1  =  [per dd_getDataFromId:@"per1"];
    NSLog(@"获取对应的key age = %d name = %@ girlfriend  = %@ price=%f  working %@  car %@",per1.age,per1.name,per1.girlfriend,per1.price,per1.working,per1.car);
}

//获取全部的Person
void getObjectAll(){
    
   //数组里面装的全部都是Person
   NSArray *objects = [Persion dd_getAllData];
   
   NSLog(@"获取全部数据  %@",objects);
    
 
    for (Persion *per in objects) {
        
        NSLog(@"%@",[per objcKeyValue]);
        
        
    }
    
   
}


//删除对应key
void deleteForKey(){
   BOOL isyes = [Persion dd_deleteFromId:@"per1"];
    if (isyes) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }
}

void deleteAll(){
    
    BOOL isyes = [Persion dd_deleteAll];
    if (isyes) {
        NSLog(@"删除成功");
    }else{
        NSLog(@"删除失败");
    }

    
}


//----------------------------------------SQLiteTool  建议用这类自己在封装一个

NSString* path(){
        NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *tableName = [@"persondb" stringByAppendingPathExtension:@"sqlite"];
        dbPath =  [dbPath stringByAppendingPathComponent:tableName];
        return dbPath;
 
    return dbPath;
    
}


//插入数据
void sqliteToolInsert(){
    
    SQLiteTool *tool = [[SQLiteTool alloc] initWithdbPath:path()];
    
    Persion *persion  = [[Persion alloc] init];
    
    persion.name = @"Dumeng ios";
    persion.age = 20;
    persion.name = @"DumengDemo";
    persion.girlfriend = @"美女";
    persion.price = 10;
    
    BOOL isyes =   [tool insertObject:persion intoTableName:@"person" intoSaveID:@"per1"];
    
    
    if (isyes) {
        NSLog(@"成功");
        
    }else{
        NSLog(@"失败");
     
    }
   
}


//查找对应的数据
void sqliteToolGetForKey(){
    
    
    SQLiteTool *tool = [[SQLiteTool alloc] initWithdbPath:path()];
    
    //读取对应的数据
    
    Persion *per =  [tool getObjectfromTableName:@"person" intoSaveID:@"per1" withClass:[Persion class]];
    
    
    NSLog(@"%@ %d",per.name , per.age);
    
  
    
}
//删除对应的数据

void sqliteToolDeleteForKey(){
    SQLiteTool *tool = [[SQLiteTool alloc] initWithdbPath:path()];
    //删除对应的数据
     BOOL isyes =  [tool deleteObjectfromTableName:@"person" SaveID:@"per1"];
    if (isyes) {
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
   
}

//删除全部的数据
void sqliteToolDeleteAll(){
    SQLiteTool *tool = [[SQLiteTool alloc] initWithdbPath:path()];
     BOOL isyes =  [tool deleteAllObjectfromTableName:@"person"];
    
    if (isyes) {
        NSLog(@"成功");
    }else{
        NSLog(@"失败");
    }
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        insertObject();
//        
//        sleep(2);
//        
//        
//        getObjectForKey();
//        
//        sleep(2);
//        
//        getObjectAll();
//        
//        
//        
//        sleep(2);
        
        //2016-07-15 01:03:30 +0000
        //替换属性
        NSDictionary *dcit = @{
                               @"age":@"1412412",
                               @"id":@"dumeng",
                               @"id1":@"我是id1",
                               @"id2":@"我是id2",
                               @"url":[NSURL URLWithString:@"www.baidu.com"],
                               @"urls":@"www.baidu.com",
                               @"models":@[@"1",@"12",@"1241"],
                               @"c1" : @"1",
                               @"date":@"2016-07-15 01:03:30",
                               @"dates":[NSDate date],
                               @"is":@"YES",
                               @"iss" :@"yes"
                               
                               
                               };
        
        Persion *per = [[Persion alloc] init];
        
         per =  [per objcValuekey:dcit];
        
        NSLog(@"ID :  %@ age1 :  %@  age2 :%@  age %zi  url:%@  urls %@ models %@",per.ID, per.age1, per.age2,per.age,per.url,per.urls, per.models);
        
        
        
        NSLog(@"per is  %d",per.is);
        
        
        
        NSLog(@"%@",[per objcKeyValue]);
        
        
        
        
    }
    return 0;
}
