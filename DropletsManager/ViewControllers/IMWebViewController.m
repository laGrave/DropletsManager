//
//  IMWebViewController.m
//  DropletsManager
//
//  Created by Igor Mishchenko on 09.09.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMWebViewController.h"
#import "NSString+SearchAdditions.h"

@interface IMWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fetchBarButtonItem;
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation IMWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"https://www.digitalocean.com/api_access"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}


#pragma mark -
#pragma mark - Instance methods


- (IBAction)fetchButtonPressed:(id)sender {
    
    if (self.params) {
        [self.delegate webVewControllerDidFetchParams:self.params];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSString *sourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
    //client id
    NSString *firstClientIDSubstring = @"<strong>Client ID:</strong>\n<code>";
    NSString *secondClientIDString = @"</code>";
    NSString *clientID = [sourceCodeString stringBetweenString:firstClientIDSubstring andString:secondClientIDString];
    
    //api key
    NSString *firstAPIKeySubstring = @"<strong>API Key:</strong>\n<code>";
    NSString *secondAPIKeySubstring = @"</code>";
    NSString *apiKey = [sourceCodeString stringBetweenString:firstAPIKeySubstring andString:secondAPIKeySubstring];
    if (clientID.length && apiKey.length) {
        NSLog(@"client id : %@", clientID);
        NSLog(@"api key: %@", apiKey);
        self.params = @{@"Client ID" : clientID, @"API Key" : apiKey};
        self.fetchBarButtonItem.title = @"Fetch";
    }
}


@end
