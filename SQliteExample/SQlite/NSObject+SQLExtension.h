//
//  NSObject+SQLExtension.h
//  SQliteExample
//
//  Created by detu on 16/7/7.
//  Copyright © 2016年 demoDu. All rights reserved.
//

#import <Foundation/Foundation.h> 
#import <objc/runtime.h>
#import <objc/message.h>



extern NSString *const typeBool_;
extern NSString *const typebool_;
extern NSString *const typeInt_;
extern NSString *const tyoeFloat_;
extern NSString *const typeDouble_;
extern NSString *const typeLongLong_;
extern NSString *const typeLong_;
extern NSString *const typeChar_;
extern NSString *const typeShort_;


//
//extern NSString *const typeSEL_;
//extern NSString *const typeBlock_;
//extern NSString *const typeClass_;





@interface SQLProperty : NSObject

-(instancetype)initWithIvar:(Ivar )ivar class:(Class )c;

/**
 *  转模型的类 
 */
@property (assign , nonatomic , readonly) Class modelClass;


/**
 *  属性的名字  
 */
@property (copy , nonatomic , readonly) NSMutableString *propertyName;


/**
 *  对象类型
 */
@property (assign , nonatomic ,readonly) Class ClassType;


/**
 *  判断属性的类型
 */
@property (copy ,nonatomic, readonly) NSString *type;
/**
 *  get 方法返回数据
 */
@property (assign , nonatomic ,readonly) SEL getSel;
/**
 *  set 方法设置数据
 */
@property (assign , nonatomic ,readonly) SEL setSel;


/**
 *  属性是模型类 
 */
@property (assign , nonatomic ,readonly) BOOL isModelClass;


@end


/*
 *  处理属性
 */

@interface NSObject (SQLExtension)
/**
 *  字典转模型
 *
 *  @param dict  传入字典 或者的json 字符串
 *
 *  @return 返回转换完的对象
 */
-(instancetype)objcValuekey:(id)dict;


/**
 *  模型对象 转换成字典
 *
 *  @return 返回转好的字典
 */
-(NSMutableDictionary *)objcKeyValue;


/**
 *  有那些属性需要替换名字的 
 {
   要替换的名字 ： 字典的对应的key
 }
 *
 *  @return 返回要替换的key
 */
+(NSDictionary *)replacePropertyName;

//这里是会报警告的代码







- (BOOL)isNoClass;





@end
