#import <objc/runtime.h>

#import "Swizzle.h"
#import "KDRDefines.h"

#if KDR_ENABLED

extern void swizzleMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    
    IMP originalImp = method_getImplementation(originalMethod);
    IMP swizzledImp = method_getImplementation(swizzledMethod);
    
    class_replaceMethod(originalClass,
                        swizzledSelector,
                        originalImp,
                        method_getTypeEncoding(originalMethod));
    class_replaceMethod(originalClass,
                        originalSelector,
                        swizzledImp,
                        method_getTypeEncoding(swizzledMethod));
}

extern void swizzleClassMethod(Class aClass, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getClassMethod(aClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

#endif
