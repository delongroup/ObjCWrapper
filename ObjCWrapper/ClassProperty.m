//
//  ClassProperty.m
//  Demo
//
//  Created by chendailong2014@126.com on 14-4-17.
//  Copyright (c) 2014年 chendailong2014@126.com. All rights reserved.
//

#import "ClassProperty.h"

@implementation ClassProperty
- (void)dealloc
{
    self.name = nil;
    self.class = nil;
    
    [super dealloc];
}
@end
