//
//  ExLogPopAction.m
//  ExLogSDK
//
//  Created by ecarx on 2020/1/8.
//

#import "ExLogPopAction.h"

@implementation ExLogPopAction

+ (instancetype)actionWithTitle:(NSString *)titleNormal selectTitle:(NSString *)titleSelect handler:(void (^)(ExLogPopAction *action))handler
{
    ExLogPopAction *action = [[self alloc] init];
    action.titleNormal = titleNormal;
    action.titleSelect = titleSelect;
    action.selecte = NO;
    action.handler = handler;
    return action;
}
@end
