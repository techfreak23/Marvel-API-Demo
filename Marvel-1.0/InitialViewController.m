//
//  InitialViewController.m
//  API demo
//
//  Created by Art Sevilla on 2/20/2015.
//  Copyright (c) 2015 Art Sevilla. All rights reserved.
//

#define kMarvelBaseURL [NSURL URLWithString:@"https://gateway.marvel.com/"]

#import "InitialViewController.h"
#import "ListViewController.h"
#import "CategoryCell.h"

@interface InitialViewController ()

@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, strong) NSArray *dummyCategories;

@end

@implementation InitialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Categories";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"purple_background"]];
    
    self.categoryArray = @[@"Characters", @"Comics", @"Creators", @"Events", @"Series", @"Stories"];
    self.dummyCategories = @[@"characters", @"comics", @"creators", @"events", @"series", @"stories"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    
    [self.tableView deselectRowAtIndexPath:selectedPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell configureLabel:[self.categoryArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showList" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedPath = [self.tableView indexPathForSelectedRow];
    
    ListViewController *controller = segue.destinationViewController;
    controller.titleString = [self.categoryArray objectAtIndex:selectedPath.row];
    controller.endString = [self.dummyCategories objectAtIndex:selectedPath.row];
    NSLog(@"Selected cell: %@", [self.dummyCategories objectAtIndex:selectedPath.row]);
}

@end
