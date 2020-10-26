//
//  CSChatTool.h
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import <Foundation/Foundation.h>
#import "CSAccountManager.h"
#import "CSDBTool.h"
#import "CSConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSChatTool : NSObject
+ (CSConversationModel *)conversationModelForConversationId:(NSString *)conversationId;
@end

NS_ASSUME_NONNULL_END
