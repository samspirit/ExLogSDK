//
//  NSString+Log.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "NSString+Log.h"
#import <objc/runtime.h>

@implementation NSString (Log)

@end

#pragma mark - NSObject+Log
@implementation NSObject (Log)
- (NSString *)objectDescription
{
    NSString *desc = @"\n{";
    //
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //获取property的C字符串
        const char * propName = property_getName(property);
        if (propName) {
            //获取NSString类型的property名字
            NSString *prop = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
            //获取property对应的值
            id obj = prop;
            if ([self respondsToSelector:@selector(valueForKey:)]) {
                obj = [self valueForKey:prop];
            }
            //将属性名和属性值拼接起来
            desc = [desc stringByAppendingFormat:@"%@: %@,\n",prop,obj];
        }
    }
    desc = [desc stringByAppendingFormat:@"}\n"];
    free(properties);

    return desc;
}
@end

#pragma mark - NSDictionary+Log
@implementation NSDictionary (Log)
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *str = [NSMutableString stringWithString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [str appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [str appendString:@"}"];
    return str;
}
@end

#pragma mark - NSArray+Log
@implementation NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *str = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [str appendFormat:@"\t%@,\n", obj];
    }];
    [str appendString:@")"];
    return str;
}

@end
