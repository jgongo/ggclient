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
#import "GGCatalogPageRetriever.h"


#pragma mark Class extension

@interface GGCatalogViewController ()
@property (nonatomic, strong) GGCatalogPageRetriever *paginator;
@property (nonatomic, strong) id<INPaginationState>   paginationState;
@property (nonatomic, strong) NSMutableArray         *books;
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
