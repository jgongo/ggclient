//
//  GGMasterViewController.m
//  GGClient
//
//  Created by Jose Gonzalez Gomez on 15/06/13.
//  Copyright (c) 2013 OPEN input. All rights reserved.
//

#import "GGCatalogViewController.h"
#import "UIViewController+CatalogService.h"
#import "GGBookViewController.h"
#import "INPaginator.h"
#import "INOffsetBasedPaginationState.h"


@interface GGCatalogPaginator : NSObject <INPageRetriever>
@property (nonatomic        ) NSUInteger        itemsPerPage;
@property (nonatomic, strong) GGCatalogService *catalogService;
- (id)initWithCatalogService:(GGCatalogService *)catalogService;
@end


@implementation GGCatalogPaginator

- (id)initWithCatalogService:(GGCatalogService *)catalogService {
    self = [super init];
    if (self) {
        _catalogService = catalogService;
    }
    return self;
}

- (void)retrieveFirstPageWithItems:(NSUInteger)itemsPerPage onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(itemsPerPage > 0, @"Items per page should be greater than 0.");
    self.itemsPerPage = itemsPerPage;
    NSDictionary *modifiers = @{GGRequestModifierCountKey: @(self.itemsPerPage)};
    [self.catalogService getBookListWithModifiers:modifiers onSuccess:^(NSArray *books) {
        if (onSuccess) {
            INOffsetBasedPaginationState *paginationState = [[INOffsetBasedPaginationState alloc] initWithTotal:books.count <= self.itemsPerPage ? books.count : NSUIntegerMax offset:books.count];
            onSuccess(books, paginationState);
        }
    } onError:^(NSError *error) {
        if (onError) { onError(error); }
    }];
}

- (void)retrieveNextPageFrom:(id<INPaginationState>)paginationState onSuccess:(PageRetrievalSuccessBlock)onSuccess onError:(PageErrorBlock)onError {
    NSAssert(self.itemsPerPage > 0, @"Items per page should be greater than 0. Maybe you haven't invoked first page?");
    INOffsetBasedPaginationState *offsetBasedState = paginationState;
    NSDictionary *modifiers = @{GGRequestModifierCountKey: @(self.itemsPerPage), GGRequestModifierOffsetKey: @(offsetBasedState.offset)};
    [self.catalogService getBookListWithModifiers:modifiers onSuccess:^(NSArray *books) {
        if (onSuccess) {
            INOffsetBasedPaginationState *paginationState = [[INOffsetBasedPaginationState alloc] initWithTotal:books.count <= self.itemsPerPage ? offsetBasedState.offset + books.count : NSUIntegerMax
                                                                                                         offset:offsetBasedState.offset + books.count];
            onSuccess(books, paginationState);
        }
    } onError:^(NSError *error) {
        if (onError) { onError(error); }
    }];
}

@end


#pragma mark - Class extension

@interface GGCatalogViewController ()
@property (nonatomic, strong) GGCatalogPaginator   *paginator;
@property (nonatomic, strong) id<INPaginationState> paginationState;
@property (nonatomic, strong) NSMutableArray       *books;
@end


#pragma mark - Class implementation

@implementation GGCatalogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.paginator = [[GGCatalogPaginator alloc] initWithCatalogService:self.catalogService];
    [self.paginator retrieveFirstPageWithItems:5 onSuccess:^(NSArray *page, id<INPaginationState> paginationState) {
        self.books = [NSMutableArray arrayWithArray:page];
        self.paginationState = paginationState;
        [self.tableView reloadData];
    } onError:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BOOK_CELL" forIndexPath:indexPath];

    GGBook *book = self.books[indexPath.row];
    cell.textLabel.text = book.title;
    return cell;
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
