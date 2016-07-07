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

-(instancetype)initWithIvar:(Ivar )ivar;

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

-(instancetype)objcValuekey:(id)dict;

-(NSMutableDictionary *)objcKeyValue;

- (BOOL)isNoClass;





@end
