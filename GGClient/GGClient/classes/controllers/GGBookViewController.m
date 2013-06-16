//
//  GGDetailViewController.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGBookViewController.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "UIViewController+CatalogService.h"


@interface GGBookViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)configureView;
@end


@implementation GGBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
}

- (void)setBook:(GGBook *)book
{
    if (_book != book) {
        _book = book;
        [self configureView];
    }
}

- (void)configureView
{
    if (self.book) {
        self.navigationItem.title = self.book.title;
        self.titleLabel.text  = self.book.title;
        self.authorLabel.text = self.book.author;
//        self.priceLabel.text  = self.book.price;
        if (self.book.imageURL) {
            [self.imageView setImageWithURL:self.book.imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

@end
