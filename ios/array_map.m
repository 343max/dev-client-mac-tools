#import "array_map.h"

#import "KDRDefines.h"

#if KDR_ENABLED

extern NSArray * array_map(NSArray *array, id (^mapper)(id obj, NSUInteger idx))
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:mapper(obj, idx)];
    }];
    return [result copy];

}

#endif
