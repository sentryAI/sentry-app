// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: test.proto

#import "GPBProtocolBuffers_RuntimeSupport.h"
#import "Test.pbobjc.h"
#import "Empty.pbobjc.h"
#import "Messages.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma mark - RMTTestRoot

@implementation RMTTestRoot

+ (GPBExtensionRegistry*)extensionRegistry {
  // This is called by +initialize so there is no need to worry
  // about thread safety and initialization of registry.
  static GPBExtensionRegistry* registry = nil;
  if (!registry) {
    GPBDebugCheckRuntimeVersion();
    registry = [[GPBExtensionRegistry alloc] init];
    [registry addExtensions:[RMTEmptyRoot extensionRegistry]];
    [registry addExtensions:[RMTMessagesRoot extensionRegistry]];
  }
  return registry;
}

@end


// @@protoc_insertion_point(global_scope)