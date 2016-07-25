//
//  Persion.m
//  SQliteExample
//
//  Created by detu on 16/4/22.
//  Copyright © 2016年 demoDu. All rights reserved.
//

#import "Persion.h" 
#import "NSObject+SQLExtension.h"
@implementation Person01

@end


@implementation Persion
-(void)dealloc{
    
    NSLog(@"Person 销毁");
    
}
+(NSDictionary *)replacePropertyName{
    
    return @{@"ID" : @"id",
             @"age1":@"id1",
             @"age2":@"id2",
             @"age100":@"person.counts.counts.du",
             @"dumeng":@"person.int.intage.dumeng",
             @"mutableDict":@"person.mutableDict",
             @"mutableArray" :@"person.mutableDict.mutableArray"
             
             
             };
    
}


@end
