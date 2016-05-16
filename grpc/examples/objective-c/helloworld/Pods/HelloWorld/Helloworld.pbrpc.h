#import "Helloworld.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>


@protocol HLWGreeter <NSObject>

#pragma mark SayHello(HelloRequest) returns (HelloReply)

- (void)sayHelloWithRequest:(HLWHelloRequest *)request handler:(void(^)(HLWHelloReply *response, NSError *error))handler;

- (ProtoRPC *)RPCToSayHelloWithRequest:(HLWHelloRequest *)request handler:(void(^)(HLWHelloReply *response, NSError *error))handler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface HLWGreeter : ProtoService<HLWGreeter>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
