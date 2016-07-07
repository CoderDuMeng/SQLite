//
//  Persion.h
//  SQliteExample
//

#import <Foundation/Foundation.h>
//存储人的信息
//存储人的信息

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

@property (copy , nonatomic) NSString *ID;
@property (copy , nonatomic) NSString *age1;
@property (assign , nonatomic)NSString *age2;


@end
