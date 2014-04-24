//
//  ClassProperty.h
//  Demo
//
//  Created by chendailong2014@126.com on 14-4-17.
//  Copyright (c) 2014年 chendailong2014@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassObject;
@interface ClassProperty : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,retain) ClassObject *class;
@end
