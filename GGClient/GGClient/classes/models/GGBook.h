//
//  GGBook.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GGBook : NSObject
@property (nonatomic, copy  ) NSString        *identifier;
@property (nonatomic, copy  ) NSString        *title;
@property (nonatomic, copy  ) NSString        *author;
@property (nonatomic, strong) NSURL           *imageURL;
@property (nonatomic, strong) NSDecimalNumber *price;
@end
