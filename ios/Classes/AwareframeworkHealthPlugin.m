#import "AwareframeworkHealthPlugin.h"
#import <awareframework_health/awareframework_health-Swift.h>

@implementation AwareframeworkHealthPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkHealthPlugin registerWithRegistrar:registrar];
}
@end
