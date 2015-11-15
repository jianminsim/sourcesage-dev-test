//
//  User.h
//  QAndAApplication
//
//  Created by Hung Trinh on 11/15/15.
//  Copyright © 2015 HungTrinh. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface User : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSString *userName;
@end
