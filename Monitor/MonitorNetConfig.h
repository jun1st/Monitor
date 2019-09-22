//
//  MonitorNetConfig.h
//  Monitor
//
//  Created by fengde on 2019/9/21.
//  Copyright © 2019 fengde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <IOKit/IOKitLib.h>
#import <IOKit/network/IOEthernetInterface.h>
#import <IOKit/network/IONetworkInterface.h>
#import <IOKit/network/IOEthernetController.h>
#import <mach/mach_port.h>
#import "MonitorNet.h"


@interface MonitorNetConfig : NSObject {

    // Values for SystemConfiguration sessions
    SCDynamicStoreRef            scSession;
    CFRunLoopSourceRef            scRunSource;
    // Mach port for IOKit
    mach_port_t                    masterPort;
    // Caches of current data
    NSArray                        *cachedInterfaceDetails;
    NSString                    *cachedPrimaryName;
    NSString                    *cachedPrimaryService;
    NSMutableDictionary            *cachedServiceToName;
    NSMutableDictionary            *cachedNameToService;
    NSMutableDictionary            *cachedServiceSpeed;
    NSMutableDictionary            *cachedUnderlyingInterface;
    NSMutableDictionary            *cachedInterfaceUp;

}

// Network config info
- (NSString *)computerName;
- (NSDictionary *)interfaceConfigForInterfaceName:(NSString *)name;
- (NSArray *)interfaceDetails;
- (NSString *)primaryInterfaceName;
- (NSString *)primaryServiceID;
- (NSString *)serviceForInterfaceName:(NSString *)interfaceName;
- (NSString *)interfaceNameForServiceID:(NSString *)serviceID;
- (NSNumber *)speedForServiceID:(NSString *)serviceID;
- (NSString *)underlyingInterfaceNameForServiceID:(NSString *)serviceID;
- (BOOL)interfaceNameIsUp:(NSString *)interfaceName;

@end
