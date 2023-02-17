#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDRMainWindowHandler : NSObject

@property (assign, nonatomic) CGFloat backgroundAlpha;
@property (assign, nonatomic) BOOL backgroundIgnoresClicks;

@property (assign, nonatomic) BOOL toggledAppearance;
@property (assign, nonatomic, readonly) BOOL isDark;

/// nil: float on top of nothing, @[@"everything"]: float on top of everything, @[strings]: float of top of these bundle Identifiers
@property (strong, nonatomic, nullable) NSArray<NSString *> *floatOnTopOfBundleIdentifiers;

@property (assign, nonatomic) CGSize windowSize;

- (instancetype)initWithFloatOnTopBundleIdentifiers:(nullable NSArray<NSString *> *)floatOnTopOfBundleIdentifiers
                                    backgroundAlpha:(CGFloat)backgroundAlpha
                            backgroundIgnoresClicks:(BOOL)backgroundIgnoresClicks;

- (void)setWindowSize:(CGSize)windowSize animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
