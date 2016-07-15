//
//  NSObject+SQLExtension.m
//  SQliteExample
//
//  Created by detu on 16/7/7.
//  Copyright © 2016年 demoDu. All rights reserved.
//

#import "NSObject+SQLExtension.h"  


NSString *const typeInt_ = @"i";
NSString *const typeShort_ = @"s";
NSString *const tyoeFloat_ = @"f";
NSString *const typeDouble_ = @"d";
NSString *const typeLong_ = @"l";
NSString *const typeLongLong_ = @"q";
NSString *const typeChar_ = @"c";
NSString *const typeBool_ = @"b";
NSString *const typebool_ = @"B";



@implementation SQLProperty
-(instancetype)initWithIvar:(Ivar)ivar class:(__unsafe_unretained Class)c{
    if (self= [super init]) {
        
        _modelClass = c;
        
         //属性名字
        NSMutableString *key  = [NSMutableString stringWithUTF8String:ivar_getName(ivar)];
        [key replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
        _propertyName = [key copy];
        
        //属性类型
         NSMutableString *type  = [NSMutableString  stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        _type = [type mutableCopy];
        //对象类型
        if ([type hasPrefix:@"@"]) {
            _type =  [type substringWithRange:NSMakeRange(2, type.length-3)];
            
            _ClassType = NSClassFromString(_type);
            
            
            if (_ClassType ==  [NSArray class]||
                _ClassType ==  [NSMutableArray class] ||
                _ClassType ==  [NSString class] ||
                _ClassType ==  [NSMutableString class] ||
                _ClassType ==  [NSMutableDictionary class]||
                _ClassType ==  [NSDictionary class]||
                _ClassType ==  [NSData class] ||
                _ClassType ==  [NSMutableData class] ||
                _ClassType ==  [NSMutableSet class] ||
                _ClassType ==  [NSSet class] ||
                _ClassType ==  [NSNumber class] ||
                _ClassType ==  [NSURL class] ||
                _ClassType ==  [NSDate class]
                
                ) {
                _isModelClass = NO;   //不是模型类
            }else{
                _isModelClass = YES;   //是模型类
                
            }
     
        }
        
        //get 方法
        _getSel = NSSelectorFromString(_propertyName);
        
      
        
        //处理set方法
            NSString *cap = [key substringToIndex:1].uppercaseString;
            [key replaceCharactersInRange:NSMakeRange(0, 1) withString:cap];
            [key insertString:@"set" atIndex:0];
            [key appendString:@":"];
            _setSel = NSSelectorFromString(key);
        
        
        
  
  
    }
    return self;
}


@end

@implementation NSObject (SQLExtension)

- (void)propertyKey:(NSString **)key{
    
    if ([self.class respondsToSelector:@selector(replacePropertyName)]) {
        
        NSString *replaceName = [self.class replacePropertyName][*key];
        
        
        if (replaceName) {
            *key = replaceName;
            
        }
    }
 
}


- (void)enumerateProperty:(void(^)(SQLProperty *property))block{
    
    Class c = self.class;
    while (c!=nil) {
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(c, &ivarCount);
    for (int i = 0;  i < ivarCount; i++) {
         //如果是NSObject 就不用遍历
        if ([NSStringFromClass(c) isEqualToString:@"NSObject"]) {
            break;
        }
        Ivar ivar = ivars[i];
        
        SQLProperty *property = [[SQLProperty alloc] initWithIvar:ivar class:c];
        
      
        if (block) {
            block(property);
        }
        
    }
        
    c = class_getSuperclass(c);
        
  }
}

-(instancetype)objcKeyValue:(id)dict{

    NSAssert([[dict class] isSubclassOfClass:[NSDictionary class]], @"不是字典");
    
    if ([self isNoClass]!= NO) {
        
        return nil;
    }
    
    
    [self enumerateProperty:^(SQLProperty *property) {
        NSString *key = property.propertyName;
        NSString *type = property.type;
        Class classType  = property.ClassType;
        SEL selector = property.setSel;
        [self propertyKey:&key];
        
        id value = dict[key];
        if (value == nil) {
            return ;
        }
        
        if (classType) {
        
        //是模型类型
        if (property.isModelClass && ([value isKindOfClass:[NSMutableDictionary class]]||[value isKindOfClass:[NSDictionary class]])) {
            id obj = [classType new];
            [obj objcKeyValue:value];
            ((void(*)(id,SEL,Class))(void *)objc_msgSend)(self,selector,obj);
        }else{
            if (classType==[NSString class] && [value isKindOfClass:[NSURL class]]) {
                NSURL *urlStirngValue = (NSURL *)value;
                ((void(*)(id,SEL,NSString *))(void *)objc_msgSend)(self,selector,urlStirngValue.absoluteString);
            }else if ([value isKindOfClass:[NSString class]] && classType == [NSURL class]){
                NSURL *urlValue = (NSURL *)value;
                ((void(*)(id,SEL,NSURL *))(void *)objc_msgSend)(self,selector,urlValue);
            }else if(classType==[NSDate class] && [value isKindOfClass:[NSString class]]){
                {
                NSDateFormatter *formatter = [NSDateFormatter  new];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *date =  [formatter dateFromString:(NSString *)value];
                if (date) {
                  ((void(*)(id,SEL,NSDate *))(void *)objc_msgSend)(self,selector,date);
                }
                }
                {
                NSDateFormatter *formatter = [NSDateFormatter  new];
                formatter.dateFormat = @"yyyy-MM-dd ";
                NSDate *date =  [formatter dateFromString:(NSString *)value];
                if (date) {
                ((void(*)(id,SEL,NSDate *))(void *)objc_msgSend)(self,selector,date);
                }
                }
                {
                NSDateFormatter *formatter = [NSDateFormatter  new];
                formatter.dateFormat = @"HH:mm:ss";
                NSDate *date =  [formatter dateFromString:(NSString *)value];
                if (date) {
                ((void(*)(id,SEL,NSDate *))(void *)objc_msgSend)(self,selector,date);
                }
                
            }
                
            }else{
                ((void(*)(id,SEL,id))(void *)objc_msgSend)(self,selector,value);
            }
            
        }
    
        }else{
        
        if ([type isEqualToString:typeInt_]) {
         
            ((void(*)(id,SEL,int))(void *)objc_msgSend)(self,selector,[value intValue]);
         
        }else if ([type isEqualToString:tyoeFloat_]){
            
            ((void(*)(id,SEL,float))(void *)objc_msgSend)(self,selector,[value floatValue]);
        
        }else if ([type isEqualToString:typeDouble_]){
         
            ((void(*)(id,SEL,double))(void *)objc_msgSend)(self,selector,[value doubleValue]);
       
        }else if ([type isEqualToString:typeBool_] ){
           
            ((void(*)(id,SEL,BOOL))(void *)objc_msgSend)(self,selector,[value boolValue]);
           
        }else if ([type isEqualToString:typeLongLong_]){
         
            ((void(*)(id,SEL,long long))(void *)objc_msgSend)(self,selector,[value longLongValue]);
        
         }else if ([type isEqualToString:typeChar_] || [type isEqualToString:typebool_]){
          
            if ([value isKindOfClass:[NSString class]]) {
                
                if ([value isEqualToString:@"YES"] ||
                    [value isEqualToString:@"yes"]) {
                    
                    ((void(*)(id,SEL,BOOL))(void *)objc_msgSend)(self,selector,1);
                    
                }else if ([value isEqualToString:@"true"] ||
                          [value isEqualToString:@"NO"] ||
                          [value isEqualToString:@"no"]){
                   
                    ((void(*)(id,SEL,BOOL))(void *)objc_msgSend)(self,selector,0);
                    
                }else{
                    
                    NSString *charStr = (NSString *) value;
                    
                    ((void(*)(id,SEL,char))(void *)objc_msgSend)(self,selector,(char )charStr.UTF8String);
                }
             
            }else{
              ((void(*)(id,SEL,char))(void *)objc_msgSend)(self,selector,[value charValue]);
                
            }
            
        }else if ([type isEqualToString:typeLong_]){
            ((void(*)(id,SEL,long))(void *)objc_msgSend)(self,selector,[value longValue]);
        }
    
        }
        
    }];
    
    return self;
    
}

- (NSArray *)classs{
    return @[@"NSString",
             @"NSSMutableString",
             @"NSMutableArray",
             @"NSArray",
             @"NSMutableDictionary",
             @"NSDictionary",
             @"NSMutableSet",
             @"NSSet",
             @"NSNumber",
             @"NSURL",
             @"NSData",
             @"NSMutableData",
             @"NSDate"
             
             ];
 
}



- (BOOL)isNoClass{
    
    NSString *className = NSStringFromClass(self.class);
    
    __block BOOL isC = NO;
    [[self classs] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([className isEqualToString:obj]) {
            
            isC = YES;
            *stop = YES;
            
        }
        
    }];
    return isC;
    
    
}

- (NSMutableDictionary *)valueKey{

    if ([self isNoClass]) return nil;
    
  __block   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [self enumerateProperty:^(SQLProperty *property) {
        
        NSString *key = property.propertyName;
        Class  classType = property.ClassType;
        
        id value = nil;
        
        if (classType&&property.isModelClass) { //模型属性
            
              id model = [self valueForKey:key];
              value = [model valueKey];
            
        }else{
            value = [self valueForKey:key];
        }
        
    //赋值
        if (value!=nil && value != [NSNull null] ) {
         dict[key] = value;
        }
    }];
  
    return dict;
    
   
}


-(instancetype)objcValuekey:(id)dict{
     if ([dict class]==[NSString class]) {
      dict =   [NSJSONSerialization JSONObjectWithData:[((NSString *)dict) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    return [self objcKeyValue:dict];
    
}

-(NSMutableDictionary *)objcKeyValue{
    
    return [self valueKey];
    
}

+(NSDictionary *)replacePropertyName{
    return nil;
}



@end
