//
//  CSDBTool.h
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSDBTool : NSObject
+ (nullable NSDictionary *)conversationObjectForConversationId:(NSString *)conversationId userId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
