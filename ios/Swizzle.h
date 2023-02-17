#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern void swizzleMethod(Class originalClass, SEL originalSelector, Class swizzledClass, SEL swizzledSelector);

extern void swizzleClassMethod(Class aClass, SEL originalSelector, SEL swizzledSelector);

NS_ASSUME_NONNULL_END
