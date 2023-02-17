#import "KDRAppDelegate.h"
#import "KDRDefines.h"

#import <React/RCTLinkingManager.h>

#import "KDRDevHelper.h"
#import "Swizzle.h"

#import <React/RCTBridge.h>

#if KDR_ENABLED

@implementation KDRAppDelegate

+ (void)load
{
    [KDRAppDelegate swizzle:@"AppDelegate"];
}

+ (void)swizzleDelegateMethod:(SEL)originalSelector forAppDelegate:(Class)appDelegateClass;
{
    NSString *swizzledSelectorName = [NSString stringWithFormat:@"swizzled_%@", NSStringFromSelector(originalSelector)];
    SEL swizzledSelector = NSSelectorFromString(swizzledSelectorName);
    
    NSAssert([self instancesRespondToSelector:swizzledSelector], @"%@ not implemented and can't be swizzled", swizzledSelectorName);
    
    swizzleMethod(appDelegateClass, originalSelector, self, swizzledSelector);
}

+ (void)swizzle:(NSString *)delegateClassName
{
    Class appDelegateClass = NSClassFromString(delegateClassName);
    NSAssert(appDelegateClass != nil, @"No App Delegate!");
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        for(NSString *selectorString in @[
            @"buildMenuWithBuilder:",
            @"nextResponder",
            @"application:didFinishLaunchingWithOptions:"
        ]) {
            [self swizzleDelegateMethod:NSSelectorFromString(selectorString)
                         forAppDelegate:appDelegateClass];
        }
    });
}

- (BOOL)swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    BOOL result = [self swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
    
    application.idleTimerDisabled = YES;
    
    [[UIApplication sharedApplication].connectedScenes enumerateObjectsUsingBlock:^(UIScene * _Nonnull scene, BOOL * _Nonnull stop) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            ((UIWindowScene *)scene).sizeRestrictions.minimumSize = CGSizeMake(284, 512);
        }
    }];
    
    return result;
}

- (void)swizzled_buildMenuWithBuilder:(id<UIMenuBuilder>)builder API_AVAILABLE(ios(13.0))
{
    if ([self respondsToSelector:@selector(swizzled_buildMenuWithBuilder:)]) {
        [self swizzled_buildMenuWithBuilder:builder];
    }
    
    if (builder.system == [UIMenuSystem mainSystem]) {
        [[KDRDevHelper sharedHelper] buildMenuWithBuilder:builder];
    }
}

- (UIResponder *)swizzled_nextResponder
{
    UIResponder *nextResponder = [self respondsToSelector:@selector(swizzled_nextResponder)] ?
    [self swizzled_nextResponder] : nil;
    return  [[KDRDevHelper sharedHelper] nextResponderInsteadOfResponder:nextResponder];
}

@end

#endif
