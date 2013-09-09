//
//  IMDropletDetailsTableViewController.m
//  DropletsManager
//
//  Created by Игорь Мищенко on 26.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMDropletDetailsTableViewController.h"

#import <MBProgressHUD.h>

#import "RequestManager.h"

@interface IMDropletDetailsTableViewController ()

@property (nonatomic, strong) NSDictionary *imageDict;

@end

@implementation IMDropletDetailsTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self updateDropletInfo];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance methods

- (void)updateDropletInfo {

    self.title = self.dropletDict[@"name"];
    [self updateInfoForImageWithIdentifier:self.dropletDict[@"image_id"]];
    [[RequestManager sharedItem] getDetailsForDropletWithIdentifier:self.dropletDict[@"id"]
                                                    completionBlock:^(id JSON){
                                                        self.dropletDict = JSON;
//                                                        [self updateInfoForImageWithIdentifier:JSON[@"image_id"]];
                                                        [self.tableView reloadData];
                                                    }];
}

- (void)updateInfoForImageWithIdentifier:(NSString *)identifier {

    [[RequestManager sharedItem] getDetailsForImageWithIdentifier:identifier
                                                  completionBlock:^(id JSON){
                                                      self.imageDict = JSON;
                                                      [self.tableView reloadData];
                                                  }];
}


- (BOOL)dropletIsActive {

    return [self.dropletDict[@"status"] isEqualToString:@"active"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = @"Cell";
    static NSString *cellIdentifier2 = @"ActionCell";
    NSString *identifier = (indexPath.section == 0) ? cellIdentifier1 : cellIdentifier2;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *titleText = @"";
    NSString *subtitleText = @"";
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                titleText = @"IP";
                subtitleText = self.dropletDict[@"ip_address"];
                break;
            case 1:
                titleText = NSLocalizedString(@"Status", nil);
                subtitleText = NSLocalizedString(self.dropletDict[@"status"], nil);
                break;
            case 2:
                titleText = NSLocalizedString(@"Image", nil);
                subtitleText = self.imageDict[@"name"];
            default:
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
                titleText = ([self dropletIsActive]) ? NSLocalizedString(@"Shutdown", nil) :
                                                       NSLocalizedString(@"Boot", nil);
                break;
            default:
                break;
        }
    }
    
    cell.textLabel.text = titleText;
    cell.detailTextLabel.text = subtitleText;
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return NSLocalizedString(@"Details", nil);
    }
    return NSLocalizedString(@"Operations", nil);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if ([self dropletIsActive]) {
            [[RequestManager sharedItem] shutdownDropletWithIdentifier:self.dropletDict[@"id"]
                                                       completionBlock:^(id JSON){
                                                           [self updateDropletInfo];
                                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
        }
        else {
            [[RequestManager sharedItem]powerOnDropletWithIdentifier:self.dropletDict[@"id"]
                                                     completionBlock:^(id JSON){
                                                         [self updateDropletInfo];
                                                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }];
        }
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        NSString *text = @"";
        if ([self dropletIsActive])
            text = NSLocalizedString(@"This method allows you to shutdown a running droplet. The droplet will remain in your account.", nil);
        else text = NSLocalizedString(@"This method allows you to poweron a powered off droplet.", nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

@end
