//
//  IMAddDropletTableViewController.m
//  DropletsManager
//
//  Created by Игорь Мищенко on 26.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMAddDropletTableViewController.h"

#import "RequestManager.h"

@interface IMAddDropletTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) UIPickerView *sizePickerView;

@property (nonatomic, strong) NSArray *sizesArray;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *regionsArray;

@property (weak, nonatomic) IBOutlet UIButton *selectSizeButton;
@property (weak, nonatomic) IBOutlet UIButton *enterSizeButton;

@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UIButton *enterImageButton;

@property (weak, nonatomic) IBOutlet UIButton *selectRegionButton;
@property (weak, nonatomic) IBOutlet UIButton *enterRegionButton;

@property (nonatomic, weak) UIButton *activeSelectButton;
@property (nonatomic, weak) UIButton *activeEnterButton;

@end

@implementation IMAddDropletTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[RequestManager sharedItem] getSizesWithCompletionBlock:^(id JSON){
        self.sizesArray = JSON;
    }];
    
    [[RequestManager sharedItem] getImagesWithCompletionBlock:^(id JSON){
        self.imagesArray = JSON;
    }];
    
    [[RequestManager sharedItem] getRegionsWithCompletionBlock:^(id JSON){
        self.regionsArray = JSON;
    }];
    
    [self.enterSizeButton   setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [self.enterImageButton  setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
    [self.enterRegionButton setTitle:NSLocalizedString(@"Enter", nil) forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark - Instance methods


- (void)showPickerWIthTag:(NSUInteger)tag senderButton:(UIButton *)senderButton {

    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.tag = tag;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    __block CGRect pickerViewFrame = pickerView.frame;
    pickerViewFrame.origin.y = self.view.bounds.size.height;
    pickerView.frame = pickerViewFrame;
    
    [self.view addSubview:pickerView];
    self.sizePickerView = pickerView;
    
    [UIView animateWithDuration:0.4 animations:^{
        pickerViewFrame.origin.y -= pickerViewFrame.size.height;
        pickerView.frame = pickerViewFrame;
        self.activeEnterButton.alpha = 1.0f;
    }];
}


- (IBAction)cancelButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)doneButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)selectButtonPressed:(UIButton *)sender {
    
    self.activeSelectButton = sender;
    
    switch (sender.tag) {
        case 1:
            self.activeEnterButton = self.enterSizeButton;
            break;
        case 2:
            self.activeEnterButton = self.enterImageButton;
            break;
        case 3:
            self.activeEnterButton = self.enterRegionButton;
            break;
        default:
            break;
    }
    
    [self showPickerWIthTag:sender.tag senderButton:sender];
}


- (IBAction)enterButtonPressed:(UIButton *)sender {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         CGRect pickerViewFrame = self.sizePickerView.frame;
                         pickerViewFrame.origin.y += pickerViewFrame.size.height;
                         self.sizePickerView.frame = pickerViewFrame;
                         
                         sender.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self.sizePickerView removeFromSuperview];
                     }];
}




#pragma mark -
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    switch (pickerView.tag) {
        case 1:
            return self.sizesArray.count;
            break;
        case 2:
            return self.imagesArray.count;
            break;
        case 3:
            return self.regionsArray.count;
            break;
        default:
            return 0;
            break;
    }
}


#pragma mark -
#pragma mark - UIPickerView delegate


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    switch (pickerView.tag) {
        case 1:{
            NSDictionary *sizeDict = [self.sizesArray objectAtIndex:row];
            return sizeDict[@"name"];
            break;
        }
        case 2: {
            NSDictionary *imagesDict = [self.imagesArray objectAtIndex:row];
            return imagesDict[@"name"];
            break;
        }
        case 3: {
            NSDictionary *regionsDict = [self.regionsArray objectAtIndex:row];
            return regionsDict[@"name"];
            break;
        }
        default:
            return @"";
            break;
    }
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 44;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    NSString *buttonText = @"";
    switch (pickerView.tag) {
        case 1:{
            NSDictionary *sizeDict = [self.sizesArray objectAtIndex:row];
            buttonText = sizeDict[@"name"];
            break;
        }
        case 2: {
            NSDictionary *imagesDict = [self.imagesArray objectAtIndex:row];
            buttonText = imagesDict[@"name"];
            break;
        }
        case 3: {
            NSDictionary *regionsDict = [self.regionsArray objectAtIndex:row];
            buttonText = regionsDict[@"name"];
            break;
        }
        default:
            buttonText = @"";
            break;
    }
    [self.activeSelectButton setTitle:buttonText forState:UIControlStateNormal];
}

@end
