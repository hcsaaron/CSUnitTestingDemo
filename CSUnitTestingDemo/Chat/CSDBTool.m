//
//  CSDBTool.m
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import "CSDBTool.h"
#import "CSAccountManager.h"

@implementation CSDBTool

+ (NSDictionary *)conversationObjectForConversationId:(NSString *)conversationId userId:(NSString *)userId {
    // 实际项目中是根据会话id在数据库中查询相应的会话信息
    if ([userId isEqualToString:[CSAccountManager defaultManager].loginUserId]) {
        if ([conversationId isEqualToString:@"111"]) {
            NSDictionary *dic = @{
                @"conversationId": conversationId,
                @"conversationName": @"李四",
                @"previewText": @"在吗？",
            };
            return dic;
        } else if ([conversationId isEqualToString:@"222"]) {
            NSDictionary *dic = @{
                @"conversationId": conversationId,
                @"conversationName": @"测试群222",
                @"previewText": @"今天天气怎么样...",
            };
            return dic;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end
