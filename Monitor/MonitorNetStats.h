//
//  MonitorNetStats.h
//  Monitor
//
//  Created by fengde on 2019/9/22.
//  Copyright © 2019 fengde. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <net/if_var.h>
#import <net/route.h>
#import <limits.h>

@interface MonitorNetStats : NSObject {
    // Old data for containing prior reads
    NSMutableDictionary        *lastData;
    // Buffer we keep around
    size_t                    sysctlBufferSize;
    uint8_t                    *sysctlBuffer;
}

// Net usage info
- (NSDictionary *)netStatsForInterval:(NSTimeInterval)sampleInterval;

@end


