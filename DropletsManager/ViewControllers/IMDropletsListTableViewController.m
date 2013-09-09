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
#import "IMSettingsViewController.h"

@interface IMDropletsListTableViewController () <UIAlertViewDelegate, IMSettingsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *droplets;
@property (nonatomic, strong) NSIndexPath *selectedDropletIndexPath;

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
    
    if ([self checkForAPIKeys]) {
        [self refresh:nil];
    }
    else {
        IMSettingsViewController *SettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:[[IMSettingsViewController class] description]];
        SettingsVC.delegate = self;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:SettingsVC];
        [self presentViewController:navVC animated:YES completion:NULL];
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - instance methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"Show settings"]) {
        UINavigationController *navVC = segue.destinationViewController;
        IMSettingsViewController *settingsVC = (IMSettingsViewController *)navVC.topViewController;
        settingsVC.delegate = self;
    }
}

- (BOOL)checkForAPIKeys {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ([[defaults valueForKey:@"Client ID"] length] && [[defaults valueForKey:@"API Key"] length]);
}


- (void)refresh:(UIRefreshControl *)refresh {

    [[RequestManager sharedItem] getDropletsListWithCompletionBlock:^(id JSON){
        NSLog(@"%@", JSON);
        self.droplets = [NSMutableArray arrayWithArray:JSON];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
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
    
    if (droplet[@"name"] != [NSNull null])
        cell.titleLabel.text = droplet[@"name"];
    else cell.titleLabel.text = @"";
    if (droplet[@"ip_address"] != [NSNull null])
        cell.adressLabel.text = droplet[@"ip_address"];
    else cell.adressLabel.text = @"";
    cell.active = ([droplet[@"status"] isEqualToString:@"active"]) ? YES : NO;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedDropletIndexPath = indexPath;
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
    dropletDetailsTableVC.dropletDict = droplet;
    [self.navigationController pushViewController:dropletDetailsTableVC animated:YES];
}


#pragma mark -
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == alertView.firstOtherButtonIndex) {
        NSDictionary *dropletDict = [self.droplets objectAtIndex:alertView.tag];
        [[RequestManager sharedItem] destroyDropletWithIdentifier:dropletDict[@"id"] completionBlock:^(id JSON){
            [self refresh:nil];
        }
                                                     failureBlock:^(id JSON){
                                                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:JSON[@"message"]
                                                                                                        delegate:nil cancelButtonTitle:@"OK"
                                                                                               otherButtonTitles:nil];
                                                         [alert show];
                                                     }];
    }
}


#pragma mark -
#pragma mark - IMSettingsViewControllerDelegate

- (void)SettingsVCShouldDismiss:(IMSettingsViewController *)SettingsVC {

    [self dismissViewControllerAnimated:YES completion:^{
        [self refresh:nil];
    }];
}

@end
