//
//  UIControl+FCAcceptEventInteravl.m
//  fincar
//
//  Created by CaydenK on 2016/12/21.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import "UIControl+FCAcceptEventInteravl.h"
#import <objc/runtime.h>
@implementation UIControl (FCAcceptEventInteravl)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";
- (NSTimeInterval )Dd_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setDd_acceptEventInterval:(NSTimeInterval)Dd_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(Dd_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )Dd_acceptEventTime{
    return [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setDd_acceptEventTime:(NSTimeInterval)Dd_acceptEventTime{
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(Dd_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取着两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(Dd_sendAction:to:forEvent:));
    SEL mySEL = @selector(Dd_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在了
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
}

- (void)Dd_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    if (NSDate.date.timeIntervalSince1970 - self.Dd_acceptEventTime < self.Dd_acceptEventInterval) {
        return;
    }
    
    if (self.Dd_acceptEventInterval > 0) {
        self.Dd_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self Dd_sendAction:action to:target forEvent:event];
}


@end
