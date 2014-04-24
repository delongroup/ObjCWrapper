//
//  ClassObject.m
//  Demo
//
//  Created by chendailong2014@126.com on 14-4-17.
//  Copyright (c) 2014年 chendailong2014@126.com. All rights reserved.
//

#import "ClassObject.h"
#import "ClassProperty.h"
#import <objc/runtime.h>

static NSMutableDictionary *ClassObject_Propertys = nil;
@implementation ClassObject
{
    Class _class;
    NSString *_name;
}

+ (void)load
{
    ClassObject_Propertys = [[NSMutableDictionary alloc] init];
}

+ (ClassObject *)classObjectWithNativeClass:(Class)class
{
    return [[[ClassObject alloc] initWithClass:class] autorelease];
}

+ (ClassObject *)classObjectWithObject:(id)object
{
    Class class = object_getClass(object);
    return [[[ClassObject alloc] initWithClass:class] autorelease];
}

+ (ClassObject *)classObjectWithName:(NSString *)name
{
    Class class = objc_getClass([name UTF8String]);
    return [[[ClassObject alloc] initWithClass:class] autorelease];
}

- (NSString *)name
{
    if (!_name)
    {
        _name = [[NSString stringWithUTF8String:class_getName(_class)] retain];
    }
    
    return _name;
}

- (NSArray *)propertys
{
    NSArray *classPropertys = nil;
    @synchronized(self)
    {
        NSValue *classKey = [NSValue valueWithPointer:_class];
        classPropertys = ClassObject_Propertys[classKey];
        if (!classPropertys)
        {
            classPropertys = [self classPropertys:_class];
            ClassObject_Propertys[classKey] = classPropertys;
        }
    }
    
    return classPropertys;
}

- (ClassObject *)superClass
{
    Class superclass = class_getSuperclass(_class);
    return superclass ? [ClassObject classObjectWithNativeClass:superclass] : NULL;
}

- (id)initWithClass:(Class)class
{
    self = [super init];
    if (self)
    {
        self->_class = class;
        if (!class)
        {
            [self release];
            return nil;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [_name release];
    
    [super dealloc];
}

- (BOOL)testClass:(Class)class
{
    return [_class isSubclassOfClass:class];
}

- (BOOL)testClassObject:(ClassObject *)classObject
{
    return [_class isSubclassOfClass:classObject->_class];
}

- (id)newObject
{
    return [[_class alloc] init];
}

- (ClassObject *)classObjectForAttribute:(NSString *)propertyAttribute
{
    Class class = nil;
    NSRange range = [propertyAttribute rangeOfString:@","];
    if (range.length > 0)
    {
        range.length   = range.location - 1;
        range.location = 1;
        propertyAttribute = [propertyAttribute substringWithRange:range];
    }
    
    if ([propertyAttribute hasPrefix:@"@"])
    {
        range.location = 2;
        range.length   = propertyAttribute.length - range.location - 1;
        propertyAttribute = [propertyAttribute substringWithRange:range];
        class = objc_getClass([propertyAttribute UTF8String]);
    } else {
        class = [NSNumber class];
    }
    
    return class ? [ClassObject classObjectWithNativeClass:class] : NULL;
}

- (NSArray *)classPropertys:(Class)class
{
    NSMutableArray *classPropertys = [NSMutableArray array];
    
    NSMutableArray *classes = [NSMutableArray array];
    [classes addObject:[NSValue valueWithPointer:class]];
    
    Class superclass = nil;
    Class topClass = [NSObject class];
    while ((superclass = class_getSuperclass(class)) != topClass)
    {
        [classes addObject:[NSValue valueWithPointer:superclass]];
        class = superclass;
    }
    
    NSEnumerator *enumerator = [classes reverseObjectEnumerator];
    Class currentClass = nil;
    while ((currentClass = enumerator.nextObject) != nil)
    {
        unsigned int propertyCount = 0;
        objc_property_t *propertys = class_copyPropertyList([currentClass pointerValue], &propertyCount);
        for (NSUInteger propertyIndex = 0; propertyIndex < propertyCount; propertyIndex++)
        {
            objc_property_t property = propertys[propertyIndex];
            
            ClassProperty *classProperty = [[ClassProperty alloc] init];
            
            NSString *name = [NSString stringWithUTF8String:property_getName(property)];
            NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
            classProperty.name = name;
            classProperty.class = [self classObjectForAttribute:attribute];
            
            [classPropertys addObject:classProperty];
            [classProperty release];
        }
    }
    
    return classPropertys;
}

@end
