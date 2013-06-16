//
//  GGMasterViewController.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGCatalogViewController.h"
#import "UIViewController+CatalogService.h"
#import <TSMessages/TSMessage.h>
#import "GGBookViewController.h"
#import "GGCatalogPageRetriever.h"


#pragma mark Class extension

@interface GGCatalogViewController ()
@property (nonatomic, strong) GGCatalogPageRetriever *paginator;
@property (nonatomic, strong) id<INPaginationState>   paginationState;
@property (nonatomic, strong) NSMutableArray         *books;

@property (nonatomic, getter = isActivityIndicatorVisible) BOOL activityIndicatorVisible;
@end


#pragma mark - Class implementation

@implementation GGCatalogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paginator = [[GGCatalogPageRetriever alloc] initWithCatalogService:self.catalogService];
    [self.paginator retrieveFirstPageWithItems:5 onSuccess:^(NSArray *page, id<INPaginationState> paginationState) {
        self.books = [NSMutableArray arrayWithArray:page];
        self.paginationState = paginationState;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        [TSMessage showNotificationInViewController:self withTitle:@"Error" withMessage:@"Ups, there was some error retrieving book list" withType:TSMessageNotificationTypeError withDuration:3.0];
    }];
}

#pragma mark - Page retrieval

- (NSArray *)indexPathsFromRow:(NSUInteger)firstRow toRow:(NSUInteger)lastRow {
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (NSUInteger row = firstRow; row < lastRow; row++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }
    return indexPaths;
}

- (void)retrieveNextPageOfCatalog {
    self.activityIndicatorVisible = YES;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.books.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.paginator retrieveNextPageFrom:self.paginationState onSuccess:^(NSArray *page, id<INPaginationState> paginationState) {
        self.paginationState = paginationState;
        self.activityIndicatorVisible = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.books.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.books addObjectsFromArray:page];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsFromRow:self.books.count - page.count toRow:self.books.count] withRowAnimation:UITableViewRowAnimationFade];
    } onError:^(NSError *error) {
        self.activityIndicatorVisible = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.books.count inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [TSMessage showNotificationInViewController:self withTitle:@"Error" withMessage:@"Ups, there was some error retrieving book list" withType:TSMessageNotificationTypeError withDuration:3.0];
    }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count + (self.isActivityIndicatorVisible ? 1 : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.books.count - 1 && [self.paginationState hasMorePages]) {
        [self performSelector:@selector(retrieveNextPageOfCatalog) withObject:nil afterDelay:0.1];
    }
    if (indexPath.row < self.books.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BOOK_CELL" forIndexPath:indexPath];
        GGBook *book = self.books[indexPath.row];
        cell.textLabel.text = book.title;
        return cell;
    } else {
        return [self.tableView dequeueReusableCellWithIdentifier:@"ACTIVITY_CELL" forIndexPath:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segue.book"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GGBook *book = self.books[indexPath.row];
        [[segue destinationViewController] setBook:book];
    }
}

@end
