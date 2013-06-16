//
//  GGDetailViewController.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGBookViewController.h"


@interface GGBookViewController ()
- (void)configureView;
@end


@implementation GGBookViewController

#pragma mark - Managing the detail item

- (void)setBook:(GGBook *)book
{
    if (_book != book) {
        book = book;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.book) {
        self.detailDescriptionLabel.text = self.book.title;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
