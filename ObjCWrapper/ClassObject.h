//
//  ClassObject.h
//  Demo
//
//  Created by chendailong2014@126.com on 14-4-17.
//  Copyright (c) 2014年 chendailong2014@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassObject : NSObject
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,readonly) NSArray *propertys;
@property(nonatomic,readonly) ClassObject *superClass;

+ (ClassObject *)classObjectWithNativeClass:(Class)class;
+ (ClassObject *)classObjectWithObject:(id)object;
+ (ClassObject *)classObjectWithName:(NSString *)name;

- (BOOL)testClass:(Class)class;
- (BOOL)testClassObject:(ClassObject *)classObject;
- (id)newObject;

@end
