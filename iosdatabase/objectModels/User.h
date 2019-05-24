//
//  User.h
//  iosdatabase
//
//  Created by Jethro Acosta on 23/05/2019.
//  Copyright © 2019 Jethro Acosta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : RLMObject

@property NSString *userID;
@property NSString *name;
@property NSString *image;
@property NSInteger age;

@end

NS_ASSUME_NONNULL_END
