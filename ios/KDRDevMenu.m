#import "KDRDevMenu.h"

#import "KDRDefines.h"

#import "KDRDevHelper.h"
#import "array_map.h"
#import "KDRMainWindowHandler.h"

#import <React/RCTBridge.h>
#import <React/RCTDevSettings.h>
#import <React/RCTReloadCommand.h>

#if __has_include(<React/RCTDevMenu.h>)
#import <React/RCTDevMenu.h>
#endif

@import EXDevMenu;

#if KDR_ENABLED

@interface RCTDevMenu ()
- (NSArray<RCTDevMenuItem *> *)_menuItemsToPresent;
@end

@interface MenuResponder : UIResponder

@property (weak, nonatomic) UIResponder *_nextResponder;
@property (strong, nonatomic, readonly) NSMutableArray<dispatch_block_t> *handlers;

- (SEL)generateSelector:(dispatch_block_t)handler;

@end

@implementation MenuResponder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _handlers = [NSMutableArray array];
    }
    return self;
}

- (UIResponder *)nextResponder
{
    return __nextResponder;
}

- (SEL)generateSelector:(dispatch_block_t)handler
{
    NSString *stringSelector = [NSString stringWithFormat:@"handler_%lu", _handlers.count];
    SEL selector = NSSelectorFromString(stringSelector);
    
    [_handlers addObject:handler];
    
    return selector;
}

- (BOOL)isHandler:(SEL)aSelector
{
    NSString *selector = NSStringFromSelector(aSelector);
    return [selector hasPrefix:@"handler_"];
}

- (NSInteger)handlerIndex:(SEL)aSelector
{
    NSString *selector = NSStringFromSelector(aSelector);
    NSArray<NSString *> *components = [selector componentsSeparatedByString:@"_"];
    return [components[1] integerValue];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (![self isHandler:aSelector]) {
        return [super respondsToSelector:aSelector];
    } else {
        NSInteger handlerIndex = [self handlerIndex:aSelector];
        return handlerIndex < _handlers.count;
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    if (![self isHandler:anInvocation.selector]) {
        [super forwardInvocation:anInvocation];
    } else {
        NSInteger handlerIndex = [self handlerIndex:anInvocation.selector];
        _handlers[handlerIndex]();
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (![self isHandler:aSelector]) {
        return [super methodSignatureForSelector:aSelector];
    } else {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
}

@end

@interface KDRDevMenu (MenuGenerators)
- (UIMenuElement *)resizeMenuForTitle:(NSString *)title deviceSize:(CGSize)size;
- (UIMenuElement *)alphaMenuForTitle:(NSString *)title alpha:(CGFloat)alpha;
@end


@interface KDRDevMenu ()

@property (strong, nonatomic) UIMenu *devMenu NS_AVAILABLE_IOS(13.0);
@property (strong, nonatomic) MenuResponder *menuResponder;
@property (weak, nonatomic, readonly) RCTBridge *bridge;

+ (BOOL)devSettingsEnabledForBridge:(RCTBridge *)bridge;
+ (NSArray<RCTDevMenuItem *> *)devMenuItemsForBridge:(RCTBridge *)bridge;

@end

@interface RCTDevMenuItem ()

- (void)callHandler;
- (NSString *)title;

@end

@implementation KDRDevMenu

+ (BOOL)isRunningOnMac
{
    if (@available(iOS 14.0, *)) {
        return [NSProcessInfo processInfo].isiOSAppOnMac;
    } else {
        return false;
    }
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}

- (void)setupWithBuilder:(id<UIMenuBuilder>)builder NS_AVAILABLE_IOS(13.0);
{
    _menuResponder = [[MenuResponder alloc] init];
    
    SEL floatOnTopAction = [_menuResponder generateSelector:^{
        [[KDRDevHelper sharedHelper] toggleFloatOnTopOfEverything];
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }];
    
    UICommand *stayOnTop = [UICommand commandWithTitle:@"Float On Top"
                                                 image:nil
                                                action:floatOnTopAction
                                          propertyList:@{@"hello": @"world!"}];
    
    stayOnTop.state = [KDRDevHelper sharedHelper].floatsOnTopOfEverything ? UIMenuElementStateOn : UIMenuElementStateOff;
    
    SEL floatOnTopOfEditorsAction = [_menuResponder generateSelector:^{
        [[KDRDevHelper sharedHelper] toggleFloatOnTopOfEditors];
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }];
    
    UICommand *stayOnTopOfEditors = [UICommand commandWithTitle:@"Float On Top of Visual Studio Code"
                                                          image:nil
                                                         action:floatOnTopOfEditorsAction
                                                   propertyList:nil];
    stayOnTopOfEditors.state = [KDRDevHelper sharedHelper].floatsOnTopOfEditors ? UIMenuElementStateOn : UIMenuElementStateOff;
    
    BOOL isToggled = [KDRDevHelper sharedHelper].windowHandler.toggledAppearance;

    SEL toggleDarkModeAction = [_menuResponder generateSelector:^{
        
        KDRMainWindowHandler *win = [KDRDevHelper sharedHelper].windowHandler;
        win.toggledAppearance = !isToggled;
        
        UIUserInterfaceStyle newStyle = isToggled
                            ? UIUserInterfaceStyleUnspecified
                            : (win.isDark ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight);
        
        for (UIWindow *win in [UIApplication sharedApplication].windows) {
            win.overrideUserInterfaceStyle = newStyle;
        }

        
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }];
    
    UICommand *toggleDarkMode = [UIKeyCommand commandWithTitle:@"Toggle Dark Mode"
                                                         image:nil
                                                        action:toggleDarkModeAction
                                                         input:@"A"
                                                 modifierFlags:UIKeyModifierCommand | UIKeyModifierShift
                                                  propertyList:nil];
    
    toggleDarkMode.state = isToggled ? UIMenuElementStateOn : UIMenuElementStateOff;
    
    SEL reloadMenuAction = [_menuResponder generateSelector:^{
        RCTTriggerReloadCommandListeners(@"Dev Request");
    }];
    
    UIKeyCommand *reloadMenu = [UIKeyCommand commandWithTitle:@"Reload"
                                                        image:nil
                                                       action:reloadMenuAction
                                                        input:@"R"
                                                modifierFlags:UIKeyModifierCommand | UIKeyModifierControl
                                                 propertyList:@"Reload!"];
    
    SEL showDevMenuAction = [_menuResponder generateSelector:^{
        [[DevMenuManager shared] toggleMenu];
    }];
    
    UICommand *showDevMenu = [UIKeyCommand commandWithTitle:@"Toggle Expo Dev Menu"
                                                      image:nil
                                                     action:showDevMenuAction
                                                      input:@"Z"
                                              modifierFlags:UIKeyModifierCommand | UIKeyModifierControl
                                               propertyList:nil];
    
    UIMenu *resizeMenu = [UIMenu menuWithTitle:@"Resize"
                                      children:@[
        [self resizeMenuForTitle:@"iPhone 12" deviceSize:CGSizeMake(390, 844)],
        [self resizeMenuForTitle:@"iPhone 12 mini" deviceSize:CGSizeMake(375, 812)],
        [self resizeMenuForTitle:@"iPhone 12 max" deviceSize:CGSizeMake(428, 926)],
        [self resizeMenuForTitle:@"iPhone SE" deviceSize:CGSizeMake(375, 667)]
    ]];
    
    SEL ignoresClicksAction = [self.menuResponder generateSelector:^{
        [KDRDevHelper sharedHelper].backgroundIgnoresClicks = ![KDRDevHelper sharedHelper].backgroundIgnoresClicks;
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }];
    
    UICommand *ignoresClicksMenu = [UICommand commandWithTitle:@"Ignores Clicks"
                                                         image:nil
                                                        action:ignoresClicksAction
                                                  propertyList:nil];
    ignoresClicksMenu.state = [KDRDevHelper sharedHelper].backgroundIgnoresClicks ? UIMenuElementStateOn : UIMenuElementStateOff;
    
    UIMenu *windowAlphaMenu = [UIMenu menuWithTitle:@"Inactive Window"
                                           children:@[
        ignoresClicksMenu,
        [self alphaMenuForTitle:@"Alpha 100%" alpha:1.0],
        [self alphaMenuForTitle:@"Alpha 75%" alpha:0.75],
        [self alphaMenuForTitle:@"Alpha 50%" alpha:0.5],
        [self alphaMenuForTitle:@"Alpha 25%" alpha:0.25]
    ]];
    
    NSArray *menuItems = @[
        stayOnTop,
        stayOnTopOfEditors,
        reloadMenu,
        toggleDarkMode,
        resizeMenu,
        windowAlphaMenu,
        showDevMenu,
    ];
    
    _devMenu = [UIMenu menuWithTitle:@"🛠️ Dev" children:menuItems];
    
    [builder insertSiblingMenu:_devMenu beforeMenuForIdentifier:UIMenuHelp];
}

- (id)nextResponderInsteadOfResponder:(id)nextResponder
{
    _menuResponder._nextResponder = nextResponder;
    return _menuResponder;
}

+ (BOOL)devSettingsEnabledForBridge:(RCTBridge *)bridge
{
    return bridge.devSettings != nil;
}

#if __has_include(<React/RCTDevMenu.h>)
+ (NSArray<RCTDevMenuItem *> *)devMenuItemsForBridge:(RCTBridge *)bridge
{
    if ([self devSettingsEnabledForBridge:bridge]) {
        return [bridge.devMenu _menuItemsToPresent];
    } else {
        return @[];
    }
}

#else
+ (NSArray<RCTDevMenuItem *> *)devMenuItemsForBridge:(RCTBridge *)bridge
{
    return @[];
}
#endif

@end

@implementation KDRDevMenu (MenuGenerators)

- (UIMenuElement *)resizeMenuForTitle:(NSString *)title deviceSize:(CGSize)deviceSize
{
    // macOS scales the UI of iOS apps so we need to scale it as well
    CGSize windowSize = CGSizeMake(deviceSize.width / 1.3, deviceSize.height / 1.3);
    SEL action = [_menuResponder generateSelector:^{
        [[KDRDevHelper sharedHelper].windowHandler setWindowSize:windowSize animated:YES];
    }];
    
    return [UICommand commandWithTitle:title
                                 image:nil
                                action:action
                          propertyList:nil];
}

- (UIMenuElement *)alphaMenuForTitle:(NSString *)title alpha:(CGFloat)alpha
{
    SEL action = [_menuResponder generateSelector:^{
        [KDRDevHelper sharedHelper].backgroundAlpha = alpha;
        [[UIMenuSystem mainSystem] setNeedsRebuild];
    }];
    
    UICommand *command = [UICommand commandWithTitle:title
                                               image:nil
                                              action:action
                                        propertyList:nil];
    
    command.state = [KDRDevHelper sharedHelper].backgroundAlpha == alpha ? UIMenuElementStateOn : UIMenuElementStateOff;
    
    return command;
}


@end

#endif
