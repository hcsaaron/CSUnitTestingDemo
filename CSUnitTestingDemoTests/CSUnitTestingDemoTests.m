//
//  CSUnitTestingDemoTests.m
//  CSUnitTestingDemoTests
//
//  Created by hcs on 2020/10/26.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "CSChatTool.h"

@interface CSUnitTestingDemoTests : XCTestCase

@end

@implementation CSUnitTestingDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testFetchConversation {
    
    // 制造模拟数据
    NSString *mockUserId = [NSUUID UUID].UUIDString;
    NSString *mockConversationId = [NSUUID UUID].UUIDString;
    NSString *mockConversationName = @"会话名称";
    NSString *mockPreviewText = @"这是一条消息";
    
    NSDictionary *mockDic = @{
        @"conversationId": mockConversationId,
        @"conversationName": mockConversationName,
        @"previewText": mockPreviewText,
    };
    
    CSConversationModel *mockModel = [[CSConversationModel alloc] init];
    mockModel.conversationId = mockConversationId;
    mockModel.conversationName = mockConversationName;
    mockModel.previewText = mockPreviewText;
    
    // mock 账号管理单例方法，及loginUserId返回值
    id mockAccountManager = OCMClassMock([CSAccountManager class]);
    [OCMStub([mockAccountManager defaultManager]) andReturn:mockAccountManager];
    [OCMStub([mockAccountManager loginUserId]) andReturn:mockUserId];
    
    // mock db工具查询会话信息的返回值
    id mockDBTool = OCMClassMock([CSDBTool class]);
    [OCMStub([mockDBTool conversationObjectForConversationId:mockConversationId userId:mockUserId]) andReturn:mockDic];
    
    // 调用CSChatTool覆盖+conversationModelForConversationId:方法，
    CSConversationModel *model = [CSChatTool conversationModelForConversationId:mockConversationId];

    XCTAssertTrue([model.conversationId isEqualToString:mockConversationId], @"会话id不正确");
    XCTAssertTrue([model.conversationName isEqualToString:mockConversationName], @"会话名称不正确");
    XCTAssertTrue([model.previewText isEqualToString:mockPreviewText], @"消息预览不正确");
    
    // 模拟查询不到数据的情况
    [mockDBTool stopMocking];
    mockDBTool = OCMClassMock([CSDBTool class]);
    [OCMStub([mockDBTool conversationObjectForConversationId:mockConversationId userId:mockUserId]) andReturn:nil];
    
    CSConversationModel *emptyModel = [CSChatTool conversationModelForConversationId:mockConversationId];
    XCTAssertNil(emptyModel, @"不应该查到会话model");
    
    // 释放
    [mockAccountManager stopMocking];
    [mockDBTool stopMocking];
}

@end
