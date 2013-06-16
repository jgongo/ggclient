//
//  GGDetailViewController.h
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBook.h"


@interface GGBookViewController : UIViewController
@property (nonatomic, strong) GGBook *book;
@property (nonatomic, weak  ) IBOutlet UILabel *detailDescriptionLabel;
@end
