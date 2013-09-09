//
//  IMDropletsListTableViewController.m
//  DropletsManager
//
//  Created by Игорь Мищенко on 25.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMDropletsListTableViewController.h"
#import "RequestManager.h"
#import "IMDropletTableViewCell.h"
#import "IMDropletDetailsTableViewController.h"

@interface IMDropletsListTableViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *droplets;

@end

@implementation IMDropletsListTableViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}


- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self refresh:nil];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - instance methods

- (void)refresh:(UIRefreshControl *)refresh {

    [[RequestManager sharedItem] getDropletsListWithCompletionBlock:^(id JSON){
        NSLog(@"%@", JSON);
        self.droplets = JSON;
//        [self.tableView reloadData];
        [refresh endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.droplets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    IMDropletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *droplet = [self.droplets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = droplet[@"name"];
    cell.detailTextLabel.text = droplet[@"ip_address"];
    cell.active = ([droplet[@"status"] isEqualToString:@"active"]) ? YES : NO;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Вы уверены, что хотите удалить данный сервер?" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        deleteAlert.tag = indexPath.row;
        [deleteAlert show];
    }   
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *droplet = [self.droplets objectAtIndex:indexPath.row];
    
    IMDropletDetailsTableViewController *dropletDetailsTableVC = [self.storyboard instantiateViewControllerWithIdentifier:[[IMDropletDetailsTableViewController class] description]];
    dropletDetailsTableVC.dropletID = droplet[@"id"];
    [self.navigationController pushViewController:dropletDetailsTableVC animated:YES];
}


#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == alertView.firstOtherButtonIndex) {
//        [self.table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
//                              withRowAnimation:UITableViewRowAnimationFade];
        NSDictionary *dropletDict = [self.droplets objectAtIndex:alertView.tag];
        [[RequestManager sharedItem] destroyDropletWithIdentifier:dropletDict[@"id"] completionBlock:^(id JSON){
//            [self.tableView reloadData];
        }];
    }
}

@end
