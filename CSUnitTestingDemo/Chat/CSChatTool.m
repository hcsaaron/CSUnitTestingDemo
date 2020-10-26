//
//  CSChatTool.m
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import "CSChatTool.h"

@implementation CSChatTool

+ (CSConversationModel *)conversationModelForConversationId:(NSString *)conversationId {
    // 获取当前userId
    NSString *userId = [CSAccountManager defaultManager].loginUserId;
    // 通过conversationId、userId查询会话信息
    NSDictionary *dic = [CSDBTool conversationObjectForConversationId:conversationId userId:userId];
    if (dic) {
        // 如果查到会话信息，则转成model并返回
        CSConversationModel *model = [[CSConversationModel alloc] init];
        model.conversationId = dic[@"conversationId"];
        model.conversationName = dic[@"conversationName"];
        model.previewText = dic[@"previewText"];
        return model;
    } else {
        // 查询不到则返回nil
        return nil;
    }
}

@end
