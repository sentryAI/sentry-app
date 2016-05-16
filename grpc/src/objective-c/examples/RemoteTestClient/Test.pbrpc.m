#import "Test.pbrpc.h"

#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

static NSString *const kPackageName = @"grpc.testing";
static NSString *const kServiceName = @"TestService";

@implementation RMTTestService

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  return (self = [super initWithHost:host packageName:kPackageName serviceName:kServiceName]);
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}

+ (instancetype)serviceWithHost:(NSString *)host {
  return [[self alloc] initWithHost:host];
}


#pragma mark EmptyCall(Empty) returns (Empty)

- (void)emptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *response, NSError *error))handler{
  [[self RPCToEmptyCallWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToEmptyCallWithRequest:(RMTEmpty *)request handler:(void(^)(RMTEmpty *response, NSError *error))handler{
  return [self RPCToMethod:@"EmptyCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RMTEmpty class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark UnaryCall(SimpleRequest) returns (SimpleResponse)

- (void)unaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *response, NSError *error))handler{
  [[self RPCToUnaryCallWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToUnaryCallWithRequest:(RMTSimpleRequest *)request handler:(void(^)(RMTSimpleResponse *response, NSError *error))handler{
  return [self RPCToMethod:@"UnaryCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RMTSimpleResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark StreamingOutputCall(StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)streamingOutputCallWithRequest:(RMTStreamingOutputCallRequest *)request eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  [[self RPCToStreamingOutputCallWithRequest:request eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToStreamingOutputCallWithRequest:(RMTStreamingOutputCallRequest *)request eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"StreamingOutputCall"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RMTStreamingOutputCallResponse class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
#pragma mark StreamingInputCall(stream StreamingInputCallRequest) returns (StreamingInputCallResponse)

- (void)streamingInputCallWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RMTStreamingInputCallResponse *response, NSError *error))handler{
  [[self RPCToStreamingInputCallWithRequestsWriter:requestWriter handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToStreamingInputCallWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RMTStreamingInputCallResponse *response, NSError *error))handler{
  return [self RPCToMethod:@"StreamingInputCall"
            requestsWriter:requestWriter
             responseClass:[RMTStreamingInputCallResponse class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark FullDuplexCall(stream StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)fullDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  [[self RPCToFullDuplexCallWithRequestsWriter:requestWriter eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToFullDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"FullDuplexCall"
            requestsWriter:requestWriter
             responseClass:[RMTStreamingOutputCallResponse class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
#pragma mark HalfDuplexCall(stream StreamingOutputCallRequest) returns (stream StreamingOutputCallResponse)

- (void)halfDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  [[self RPCToHalfDuplexCallWithRequestsWriter:requestWriter eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToHalfDuplexCallWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RMTStreamingOutputCallResponse *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"HalfDuplexCall"
            requestsWriter:requestWriter
             responseClass:[RMTStreamingOutputCallResponse class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
@end
