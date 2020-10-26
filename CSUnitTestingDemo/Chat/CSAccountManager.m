//
//  CSAccountManager.m
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import "CSAccountManager.h"

@implementation CSAccountManager

+ (instancetype)defaultManager {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CSAccountManager alloc] init];
    });
    return instance;
}

- (NSString *)loginUserId {
    return @"zhangsan";
}

@end
