# CSUnitTestingDemo
iOS单元测试，复杂场景使用OCMock轻松化解

## Mock的使用技巧
实际项目中，很多方法内部实现依赖许多其他类/实例方法
而单元测试中没有实际运行环境中具备的条件或数据，单元测试难以下手

### 例如测试以下类方法
**【存在的问题】**
1) 该方法需要conversationId，单元测试中无法预知conversationId是什么
2) 查询会话信息需要登录者的userId，单元测试中无进行登录操作，CSAccountManager单例获取不到有效的loginUserId
3) 数据库中无数据，无法查询到会话信息
**【结果】**
调用该方法肯定只能覆盖到else代码块，覆盖不了if代码块
```
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
```

### 下面使用第三方库OCMock解决
1) mock掉CSAccountManager的单例对象
```
id mockAccountManager = OCMClassMock([CSAccountManager class]);
[OCMStub([mockAccountManager defaultManager]) andReturn:mockAccountManager];
```
2) mock掉CSAccountManager单例的loginUserId返回值
```
[OCMStub([mockAccountManager loginUserId]) andReturn:mockUserId];
```
3) mock掉CSDBTool类方法获取会话信息的返回值
```
id mockDBTool = OCMClassMock([CSDBTool class]);
[OCMStub([mockDBTool conversationObjectForConversationId:mockConversationId userId:mockUserId]) andReturn:mockDic];
```
4) 调用待测方法（此时该方法内部调用到的方法都会返回mock出来的数据，而不会真正执行那些方法，这样就绕过了阻碍）
```
CSConversationModel *model = [CSChatTool conversationModelForConversationId:mockConversationId];
```
5) 同时，如果待测试方法内部有多个if else代码块，为了能覆盖所有代码块，可以mock出不同的条件已达到全覆盖
6) 最后将mock出来的对象调用stopMocking，防止影响后续其他测试

### 示例
```
// 单元测试-查询会话
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
```

### 单元测试覆盖率
![显示代码覆盖率](https://github.com/hcsaaron/CSUnitTestingDemo/blob/main/显示覆盖率.png?raw=true)
![查看代码覆盖率](https://github.com/hcsaaron/CSUnitTestingDemo/blob/main/查看覆盖率.png?raw=true)
![代码执行次数](https://github.com/hcsaaron/CSUnitTestingDemo/blob/main/代码执行次数.png?raw=true)
