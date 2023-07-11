// When `use_frameworks!` is used, the generated Swift header is inside MacDevTools module.
// Otherwise, it's available only locally with double-quoted imports.
#if __has_include(<MacDevTools/MacDevTools-Swift.h>)
#import <MacDevTools/MacDevTools-Swift.h>
#else
#import "MacDevTools-Swift.h"
#endif
