//
//  GGDetailViewController.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGBookViewController.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <TSMessages/TSMessage.h>
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
    [self.catalogService getBookWithId:self.book.identifier onSuccess:^(GGBook *book) {
        self.book = book;
    } onError:^(NSError *error) {
        [TSMessage showNotificationInViewController:self withTitle:@"Error" withMessage:@"Ups, there was some error retrieving book info" withType:TSMessageNotificationTypeError withDuration:3.0];
    }];
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
    static NSNumberFormatter *priceFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        priceFormatter = [[NSNumberFormatter alloc] init];
        [priceFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    });
    
    if (self.book) {
        self.navigationItem.title = self.book.title;
        self.titleLabel.text  = self.book.title;
        self.authorLabel.text = self.book.author;
        self.priceLabel.text  = [priceFormatter stringFromNumber:self.book.price];
        if (self.book.imageURL) {
            [self.imageView setImageWithURL:self.book.imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

@end
