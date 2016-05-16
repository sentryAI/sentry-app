#import "RouteGuide.pbrpc.h"

#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriter+Immediate.h>

static NSString *const kPackageName = @"routeguide";
static NSString *const kServiceName = @"RouteGuide";

@implementation RTGRouteGuide

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


#pragma mark GetFeature(Point) returns (Feature)

- (void)getFeatureWithRequest:(RTGPoint *)request handler:(void(^)(RTGFeature *response, NSError *error))handler{
  [[self RPCToGetFeatureWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToGetFeatureWithRequest:(RTGPoint *)request handler:(void(^)(RTGFeature *response, NSError *error))handler{
  return [self RPCToMethod:@"GetFeature"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RTGFeature class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark ListFeatures(Rectangle) returns (stream Feature)

- (void)listFeaturesWithRequest:(RTGRectangle *)request eventHandler:(void(^)(BOOL done, RTGFeature *response, NSError *error))eventHandler{
  [[self RPCToListFeaturesWithRequest:request eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToListFeaturesWithRequest:(RTGRectangle *)request eventHandler:(void(^)(BOOL done, RTGFeature *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"ListFeatures"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[RTGFeature class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
#pragma mark RecordRoute(stream Point) returns (RouteSummary)

- (void)recordRouteWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RTGRouteSummary *response, NSError *error))handler{
  [[self RPCToRecordRouteWithRequestsWriter:requestWriter handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToRecordRouteWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RTGRouteSummary *response, NSError *error))handler{
  return [self RPCToMethod:@"RecordRoute"
            requestsWriter:requestWriter
             responseClass:[RTGRouteSummary class]
        responsesWriteable:[GRXWriteable writeableWithSingleHandler:handler]];
}
#pragma mark RouteChat(stream RouteNote) returns (stream RouteNote)

- (void)routeChatWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RTGRouteNote *response, NSError *error))eventHandler{
  [[self RPCToRouteChatWithRequestsWriter:requestWriter eventHandler:eventHandler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToRouteChatWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RTGRouteNote *response, NSError *error))eventHandler{
  return [self RPCToMethod:@"RouteChat"
            requestsWriter:requestWriter
             responseClass:[RTGRouteNote class]
        responsesWriteable:[GRXWriteable writeableWithEventHandler:eventHandler]];
}
@end
