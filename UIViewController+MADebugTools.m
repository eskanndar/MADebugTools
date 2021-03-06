//
//  UIViewController+MADebugTools.m
//  http://github.com/michaelarmstrong
//
//  Created by Michael Armstrong on 17/04/2013.
//  Copyright (c) 2013 Michael Armstrong. All rights reserved.
//
//  Just import this class into your project and add it into your Prefix.pch
//  More features are coming later... I have a day job and a night job... so whenever theres time :)
//  http://mike.kz / @italoarmstrong
//

#import "UIViewController+MADebugTools.h"
#import <objc/runtime.h>

@implementation UIViewController (MADebugTools)

void Swizzle(Class c, SEL sourceSelector, SEL destSelector)
{
    Method sourceMethod = class_getInstanceMethod(c, sourceSelector);
    Method destMethod = class_getInstanceMethod(c, destSelector);
    if(class_addMethod(c, sourceSelector, method_getImplementation(destMethod), method_getTypeEncoding(destMethod))) {
        class_replaceMethod(c, destSelector, method_getImplementation(sourceMethod), method_getTypeEncoding(sourceMethod));
    } else {
        method_exchangeImplementations(sourceMethod, destMethod);
    }
}

+ (void)load
{
    Swizzle(self, @selector(viewDidLoad), @selector(override_viewDidLoad));
}

- (void)override_viewDidLoad
{
    // run existing implementation
    [self override_viewDidLoad];
    
    // now run custom code
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithUTF8String:class_getName ([self class])];
    [label sizeToFit];
    [self.view addSubview:label];
}


@end
