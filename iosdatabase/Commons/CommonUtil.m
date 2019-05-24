//
//  CommonUtil.m
//  iosdatabase
//
//  Created by Jethro Acosta on 23/05/2019.
//  Copyright © 2019 Jethro Acosta. All rights reserved.
//

#import "CommonUtil.h"

@implementation CommonUtil

+ (NSString*)getUUID{
    CFUUIDRef udid = CFUUIDCreate(NULL);
    NSString *udidString = [NSString stringWithFormat:@"%@", CFUUIDCreateString(NULL, udid)];
    return udidString;
}

@end
