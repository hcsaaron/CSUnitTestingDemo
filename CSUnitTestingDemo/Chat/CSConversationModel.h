//
//  CSConversationModel.h
//  CSUnitTestingDemo
//
//  Created by hcs on 2020/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSConversationModel : NSObject
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, copy) NSString *conversationName;
@property (nonatomic, copy) NSString *previewText;
@end

NS_ASSUME_NONNULL_END
