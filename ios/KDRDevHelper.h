#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UIMenuBuilder;
@class UIResponder;
@class RCTBridge;
@class KDRMainWindowHandler;
@class KDRDevMenu;

@interface KDRDevHelper : NSObject

+ (nullable KDRDevHelper *)sharedHelper;
+ (BOOL)isRunningOnMac;
+ (BOOL)enabled;

- (void)buildMenuWithBuilder:(id<UIMenuBuilder>)builder NS_AVAILABLE_IOS(13.0);

- (UIResponder *)nextResponderInsteadOfResponder:(UIResponder *)nextResponder;

- (BOOL)floatsOnTopOfEverything;
- (void)toggleFloatOnTopOfEverything;
- (BOOL)floatsOnTopOfEditors;
- (void)toggleFloatOnTopOfEditors;

@property (strong, nonatomic, readonly) KDRMainWindowHandler *windowHandler;
@property (strong, nonatomic, readonly) KDRDevMenu *devMenu;

@end


@interface KDRDevHelper (Settings)

/// nil: float on top of nothing, @[@"everything"]: float on top of everything, @[strings]: float of top of these bundle Identifiers
@property (strong, nonatomic, nullable) NSArray<NSString *> *floatOnTopOfBundleIdentifiers;
@property (assign, nonatomic) CGFloat backgroundAlpha;
@property (assign, nonatomic) BOOL backgroundIgnoresClicks;

@end

NS_ASSUME_NONNULL_END
