#SQLiteSave
###1.一行代码存储model类,面向对象存储，无需写一句sql语句
###2.模型转换  json -  model   model - json。
  
# <a id="Examples"></a> Examples【示例】 
### <a id="Model"></a> The most simple  Model【最简单的数据存储】  
```ruby 
@interface Person01 : NSObject
@property (copy , nonatomic) NSString *working;
@property (copy , nonatomic) NSString *car;
@end

@interface Persion : Person01
@property (assign , nonatomic)  int age;
@property (copy   , nonatomic)  NSString *name;
@property (copy   , nonatomic)  NSString *word;
@property (copy   , nonatomic)  NSString *girlfriend;
@property (assign , nonatomic)  CGFloat  price;
@end
```

```objc
// 1.初始化一个Person 对象 
Persion *per = [[Persion alloc] init];
per.age = 10;
per.name = @"DumengDemo";
per.girlfriend = @"美女";
per.price = 100000;

// 2.存入数据库  通过一个key
BOOL isyes =   [per dd_insertDataWithId:@"per1"];
if (isyes) {
NSLog(@"插入数据成功");
}else{

NSLog(@"插入数据失败");
}  

// 3.获取对应的数据
Persion *per1  =  [Persion dd_getDataFromId:@"per1"];
NSLog(@"获取对应的key age = %d name = %@ girlfriend  = %@ price=%f",per1.age,per1.name,per1.girlfriend,per1.price); 

// 4.获取全部数据,数组里面装的全部都是Person类
 NSArray *objects = [Persion dd_getAllData]; 

// 5.删除对应的数据   
BOOL isyes = [Persion dd_deleteFromId:@"per1"];
if (isyes) {
NSLog(@"删除成功");
}else{
NSLog(@"删除失败");
}  

// 6.删除全部的数据   
BOOL isyes = [Persion dd_deleteAll];
if (isyes) {
NSLog(@"删除成功");
}else{
NSLog(@"删除失败");
} 


// 7.支持在model类中实现属性替换
+(NSDictionary *)replacePropertyName{

return @{@"ID" : @"id",
@"age1":@"id1",
@"age2":@"id2"

};

}
//替换属性
NSDictionary *dcit = @{
@"id":@"dumeng",
@"id1":@"我是id1",
@"id2":@"我是id2"


};

Persion *per = [[Persion alloc] init];

per =  [per objcValuekey:dcit];

NSLog(@"ID :  %@ age1 :  %@  age2 :%@",per.ID, per.age1, per.age2);


//其实这个还可以做简单的数据转模型




// 8.更新数据 直接用对应的key在存一下就完全可以
```
 


 
