#import "Test.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>

#import "Empty.pbobjc.h"
#import "Messages.pbobjc.h"

@protocol RMTTestService <NSObject>

#pragma mark EmptyCall(Empty) returns (Empty)

- (void)emptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *response, NSError *error))handler;

- (ProtoRPC *)RPCToEmptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *response, NSError *error))handler;


#pragma mark UnaryCall(SimpleRequest) returns (SimpleResponse)

- (void)unaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *response, NSError *error))handler;

- (ProtoRPC *)RPCToUnaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *response, NSError *error))handler;


#pragma mark StreamingOutputCall(StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)streamingOutputCallWithRequest:(RMTStreamingOutputCallRequest *)request eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToStreamingOutputCallWithRequest:(RMTStreamingOutputCallRequest *)request eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;


#pragma mark StreamingInputCall(stream StreamingInputCallRequest) returns (StreamingInputCallResponse)

- (void)streamingInputCallWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RMTStreamingInputCallResponse *response, NSError *error))handler;

- (ProtoRPC *)RPCToStreamingInputCallWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RMTStreamingInputCallResponse *response, NSError *error))handler;


#pragma mark FullDuplexCall(stream StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)fullDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToFullDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;


#pragma mark HalfDuplexCall(stream StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)halfDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToHalfDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface RMTTestService : ProtoService<RMTTestService>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
