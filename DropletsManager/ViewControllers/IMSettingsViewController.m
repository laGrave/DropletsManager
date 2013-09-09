//
//  IMSettingsViewController.m
//  DropletsManager
//
//  Created by Igor Mishchenko on 31.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMSettingsViewController.h"
#import "IMWebViewController.h"

@interface IMSettingsViewController () <IMWebViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *clientIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;

@end

@implementation IMSettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Settings", nil);
    self.clientIDTextField.placeholder = NSLocalizedString(@"enter client ID", nil);
    self.apiKeyTextField.placeholder = NSLocalizedString(@"enter API key", nil);
}


#pragma mark -
#pragma mark - Instance methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"fetch"]) {
        IMWebViewController *vc = segue.destinationViewController;
        [vc setDelegate:self];
    }
}

- (BOOL)checkFields {

    return ([self.clientIDTextField.text length] && [self.apiKeyTextField.text length]);
}


- (IBAction)doneButtonPressed:(id)sender {
    
    if ([self checkFields]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.clientIDTextField.text forKey:@"Client ID"];
        [defaults setValue:self.apiKeyTextField.text forKey:@"API Key"];
        [defaults synchronize];
        
        if ([self.delegate conformsToProtocol:@protocol(IMSettingsViewControllerDelegate)])
            [self.delegate SettingsVCShouldDismiss:self];
        else
            [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all text fields" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


- (void)updateFields {

    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    self.clientIDTextField.text = [defaults valueForKey:@"Client ID"];
    self.apiKeyTextField.text = [defaults valueForKey:@"API Key"];
}


#pragma mark -
#pragma mark - IMWebViewControllerDelegate

- (void)webVewControllerDidFetchParams:(NSDictionary *)params {

    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setValue:params[@"Client ID"] forKey:@"Client ID"];
    [defaults setValue:params[@"API Key"] forKey:@"API Key"];
    [defaults synchronize];
    [self updateFields];
}


@end
