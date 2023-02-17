#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

extern int KDRApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);

@interface KDRAppDelegate : UIResponder <UIApplicationDelegate>

#if KDR_ENABLED
+ (void)swizzle:(NSString *)delegateClassName;
#endif

@end

NS_ASSUME_NONNULL_END
