#import "RouteGuide.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>


@protocol RTGRouteGuide <NSObject>

#pragma mark GetFeature(Point) returns (Feature)

- (void)getFeatureWithRequest:(RTGPoint *)request handler:(void(^)(RTGFeature *response, NSError *error))handler;

- (ProtoRPC *)RPCToGetFeatureWithRequest:(RTGPoint *)request handler:(void(^)(RTGFeature *response, NSError *error))handler;


#pragma mark ListFeatures(Rectangle) returns (stream Feature)

- (void)listFeaturesWithRequest:(RTGRectangle *)request eventHandler:(void(^)(BOOL done, RTGFeature *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToListFeaturesWithRequest:(RTGRectangle *)request eventHandler:(void(^)(BOOL done, RTGFeature *response, NSError *error))eventHandler;


#pragma mark RecordRoute(stream Point) returns (RouteSummary)

- (void)recordRouteWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RTGRouteSummary *response, NSError *error))handler;

- (ProtoRPC *)RPCToRecordRouteWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(RTGRouteSummary *response, NSError *error))handler;


#pragma mark RouteChat(stream RouteNote) returns (stream RouteNote)

- (void)routeChatWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RTGRouteNote *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToRouteChatWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, RTGRouteNote *response, NSError *error))eventHandler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface RTGRouteGuide : ProtoService<RTGRouteGuide>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
