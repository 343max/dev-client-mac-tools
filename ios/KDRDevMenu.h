#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTBridge;
@class RCTDevMenuItem;
@class UIResponder;

@protocol UIMenuBuilder;
@class RCTBridge;

@interface KDRDevMenu : NSObject

- (void)setupWithBuilder:(id<UIMenuBuilder>)builder NS_AVAILABLE_IOS(13.0);

- (UIResponder *)nextResponderInsteadOfResponder:(UIResponder *)nextResponder;

@end

NS_ASSUME_NONNULL_END
