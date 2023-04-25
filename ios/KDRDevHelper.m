#import "KDRDevHelper.h"

#import "KDRDefines.h"
#import "KDRDevMenu.h"
#import "KDRMainWindowHandler.h"

@interface KDRDevHelper ()

@property (strong, nonatomic) KDRDevMenu *devMenu;

@end

@implementation KDRDevHelper

#if KDR_ENABLED

+ (BOOL)enabled
{
    return [self isRunningOnMac];
}

+ (nullable KDRDevHelper *)sharedHelper;
{
    if (![self isRunningOnMac]) {
        return  nil;
    }
    static KDRDevHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KDRDevHelper alloc] init];
    });
    return sharedInstance;
}

+ (BOOL)isRunningOnMac
{
    if (@available(iOS 14.0, *)) {
        return [NSProcessInfo processInfo].isiOSAppOnMac;
    } else {
        return false;
    }
}

- (instancetype)init
{
    self = [super init];
    
    if (self != nil) {
        _devMenu = [[KDRDevMenu alloc] init];
        _windowHandler = [[KDRMainWindowHandler alloc] initWithFloatOnTopBundleIdentifiers:self.floatOnTopOfBundleIdentifiers
                                                                           backgroundAlpha:self.backgroundAlpha
                                                                   backgroundIgnoresClicks:self.backgroundIgnoresClicks];
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }
    
    return self;
}

- (void)buildMenuWithBuilder:(id<UIMenuBuilder>)builder NS_AVAILABLE_IOS(13.0);
{
    [_devMenu setupWithBuilder:builder];
}

- (UIResponder *)nextResponderInsteadOfResponder:(UIResponder *)nextResponder
{
    return [_devMenu nextResponderInsteadOfResponder:nextResponder];
}

- (BOOL)floatsOnTopOfEverything
{
    return [self.floatOnTopOfBundleIdentifiers isEqualToArray:@[@"everything"]];
}

- (void)toggleFloatOnTopOfEverything
{
    NSArray *identifiers = nil;
    if ([self floatsOnTopOfEverything]) {
        identifiers = nil;
    } else {
        identifiers = @[@"everything"];
    }
    
    self.floatOnTopOfBundleIdentifiers = identifiers;
    self.windowHandler.floatOnTopOfBundleIdentifiers = identifiers;
}

- (NSArray<NSString *> *)editorBundleIdentifiers
{
    return @[@"com.microsoft.VSCodeInsiders", @"com.microsoft.VSCode"];
}

- (BOOL)floatsOnTopOfEditors
{
    return [self.floatOnTopOfBundleIdentifiers isEqualToArray:[self editorBundleIdentifiers]];
}

- (void)toggleFloatOnTopOfEditors
{
    NSArray *identifiers = nil;
    if ([self floatsOnTopOfEditors]) {
        identifiers = nil;
    } else {
        identifiers = [self editorBundleIdentifiers];
    }
    
    self.floatOnTopOfBundleIdentifiers = identifiers;
    self.windowHandler.floatOnTopOfBundleIdentifiers = identifiers;
}

@end

@implementation KDRDevHelper (Settings)

- (NSArray<NSString *> *)floatOnTopOfBundleIdentifiers
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:@"DEV_floatOnTopOfBundleIdentifiers"];
}

- (void)setFloatOnTopOfBundleIdentifiers:(NSArray<NSString *> *)floatOnTopOfBundleIdentifiers
{
    [[NSUserDefaults standardUserDefaults] setObject:floatOnTopOfBundleIdentifiers
                                              forKey:@"DEV_floatOnTopOfBundleIdentifiers"];
}

- (CGFloat)backgroundAlpha
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:@"DEV_windowBackgroundAlpha"] ?: 1.0;
}

- (void)setBackgroundAlpha:(CGFloat)alpha
{
    [[NSUserDefaults standardUserDefaults] setFloat:alpha forKey:@"DEV_windowBackgroundAlpha"];
    _windowHandler.backgroundAlpha = alpha;
}

- (BOOL)backgroundIgnoresClicks
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"DEV_windowBackgroundIgnoresClicks"];
}

- (void)setBackgroundIgnoresClicks:(BOOL)backgroundIgnoresClicks
{
    [[NSUserDefaults standardUserDefaults] setBool:backgroundIgnoresClicks
                                            forKey:@"DEV_windowBackgroundIgnoresClicks"];
    _windowHandler.backgroundIgnoresClicks = backgroundIgnoresClicks;
}

#else

+ (BOOL)enabled
{
    return NO;
}

#endif

@end
