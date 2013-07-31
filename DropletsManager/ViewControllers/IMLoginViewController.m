//
//  IMLoginViewController.m
//  DropletsManager
//
//  Created by Igor Mishchenko on 31.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMLoginViewController.h"

@interface IMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *clientIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;

@end

@implementation IMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - Instance methods

- (BOOL)checkFields {

    return ([self.clientIDTextField.text length] && [self.apiKeyTextField.text length]);
}


- (IBAction)doneButtonPressed:(id)sender {
    
    if ([self checkFields]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.clientIDTextField.text forKey:@"Client ID"];
        [defaults setValue:self.apiKeyTextField.text forKey:@"API Key"];
        [defaults synchronize];
        
        if ([self.delegate conformsToProtocol:@protocol(IMLoginViewControllerDelegate)])
            [self.delegate loginVCShouldDismiss:self];
        else
            [self dismissViewControllerAnimated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all text fields" delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}



@end
