//
//  CSAccountManager.h
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSAccountManager : NSObject
@property (nonatomic, copy) NSString *loginUserId;  // 登录用户的userId
+ (instancetype)defaultManager;
@end

NS_ASSUME_NONNULL_END
