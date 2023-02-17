#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

typedef CGRect NSRect;
typedef int32_t CGWindowLevel;

#define kCGNormalWindowLevel            ((CGWindowLevel)0)
#define kCGFloatingWindowLevel          ((CGWindowLevel)3)
#define kCGTornOffMenuWindowLevel       ((CGWindowLevel)3)
#define kCGModalPanelWindowLevel        ((CGWindowLevel)8)
#define kCGUtilityWindowLevel           ((CGWindowLevel)19)
#define kCGDockWindowLevel              ((CGWindowLevel)20)
#define kCGMainMenuWindowLevel          ((CGWindowLevel)24)
#define kCGStatusWindowLevel            ((CGWindowLevel)25)
#define kCGPopUpMenuWindowLevel         ((CGWindowLevel)101)
#define kCGScreenSaverWindowLevel       ((CGWindowLevel)1000)

typedef NSInteger NSWindowLevel NS_TYPED_EXTENSIBLE_ENUM;
static const NSWindowLevel NSNormalWindowLevel = kCGNormalWindowLevel;
static const NSWindowLevel NSFloatingWindowLevel = kCGFloatingWindowLevel;
static const NSWindowLevel NSSubmenuWindowLevel = kCGTornOffMenuWindowLevel;
static const NSWindowLevel NSTornOffMenuWindowLevel = kCGTornOffMenuWindowLevel;
static const NSWindowLevel NSMainMenuWindowLevel = kCGMainMenuWindowLevel;
static const NSWindowLevel NSStatusWindowLevel = kCGStatusWindowLevel;
static const NSWindowLevel NSModalPanelWindowLevel = kCGModalPanelWindowLevel;
static const NSWindowLevel NSPopUpMenuWindowLevel = kCGPopUpMenuWindowLevel;
static const NSWindowLevel NSScreenSaverWindowLevel = kCGScreenSaverWindowLevel;

@interface NSAppearance : NSObject

@property (readonly, copy) NSString *name;
+ (nullable NSAppearance *)appearanceNamed:(NSString *)name;

@end

@interface NSWindow : NSObject

@property NSWindowLevel level;
@property CGFloat alphaValue;
@property(getter=isMainWindow, readonly) BOOL mainWindow;
@property(getter=isKeyWindow, readonly) BOOL keyWindow;
@property BOOL ignoresMouseEvents;

@property (nullable, strong) NSAppearance *appearance;
@property (readonly, strong) NSAppearance *effectiveAppearance;

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animateFlag;
@property (readonly) NSRect frame;

@end

typedef NSInteger NSControlStateValue NS_TYPED_EXTENSIBLE_ENUM;
static const NSControlStateValue NSControlStateValueMixed = -1;
static const NSControlStateValue NSControlStateValueOff = 0;
static const NSControlStateValue NSControlStateValueOn = 1;

@class NSMenu;

@interface NSMenuItem : NSObject

- (instancetype _Nonnull )initWithTitle:(NSString *_Nonnull)string action:(nullable SEL)selector keyEquivalent:(NSString *_Nonnull)charCode NS_DESIGNATED_INITIALIZER;

@property NSControlStateValue state;

@property (readonly) BOOL hasSubmenu;
@property (nullable, strong) NSMenu *submenu;

@end


@interface NSMenu : NSObject

- (instancetype)initWithTitle:(NSString *)title NS_DESIGNATED_INITIALIZER;
- (nullable NSMenuItem *)itemAtIndex:(NSInteger)index;
- (void)addItem:(NSMenuItem *_Nonnull)newItem;
- (void)insertItem:(NSMenuItem *_Nonnull)newItem atIndex:(NSInteger)index;

@property (copy) NSArray<NSMenuItem *> *itemArray;
@property (readonly) NSInteger numberOfItems;

@end


@interface NSApplication : NSObject

@property (class, readonly, strong) __kindof NSApplication * _Nonnull sharedApplication;

@property (nullable, readonly, weak) NSWindow *mainWindow;
@property (nullable, readonly, weak) NSWindow *keyWindow;
@property (readonly, copy) NSArray<NSWindow *> * _Nonnull windows;
@property (nullable, strong) NSMenu *mainMenu;

@end


@interface NSRunningApplication : NSObject

@property (nullable, readonly, copy) NSString *bundleIdentifier;

@end

@interface NSWorkspace : NSObject

@property (class, readonly, strong) NSWorkspace *sharedWorkspace;
@property (readonly, strong) NSNotificationCenter *notificationCenter;
@property (nullable, readonly, strong) NSRunningApplication *frontmostApplication;

@end

NS_ASSUME_NONNULL_END
