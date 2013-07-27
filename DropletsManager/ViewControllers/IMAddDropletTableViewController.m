//
//  IMAddDropletTableViewController.m
//  DropletsManager
//
//  Created by Игорь Мищенко on 26.07.13.
//  Copyright (c) 2013 Igor Mischenko. All rights reserved.
//

#import "IMAddDropletTableViewController.h"

#import "RequestManager.h"

@interface IMAddDropletTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIPickerView *pickerView;

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

@property (nonatomic, strong) NSMutableDictionary *dropletDict;

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
    
    [self.selectSizeButton setTitle:NSLocalizedString(@"Select Size", nil) forState:UIControlStateNormal];
    [self.selectImageButton setTitle:NSLocalizedString(@"Select Image", nil) forState:UIControlStateNormal];
    [self.selectRegionButton setTitle:NSLocalizedString(@"Select Region", nil) forState:UIControlStateNormal];
    
    self.dropletDict = [[NSMutableDictionary alloc] init];
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
    self.pickerView = pickerView;
    
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
    
    if ([self checkForParameters]) {
        [[RequestManager sharedItem] newDropletWithName:self.dropletDict[@"name"]
                                                 sizeID:self.dropletDict[@"size_id"]
                                                imageID:self.dropletDict[@"image_id"]
                                               regionID:self.dropletDict[@"region_id"]
                                                sshKeys:nil completionBlock:^(id JSON){
                                                    [self dismissViewControllerAnimated:YES completion:NULL];
                                                }];
    }
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
                         CGRect pickerViewFrame = self.pickerView.frame;
                         pickerViewFrame.origin.y += pickerViewFrame.size.height;
                         self.pickerView.frame = pickerViewFrame;
                         sender.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self getPickerViewValue];
                         [self.pickerView removeFromSuperview];
                     }];
}


- (void)getPickerViewValue {

    NSUInteger index = [self.pickerView selectedRowInComponent:0];
    NSArray *array = nil;
    NSString *key = nil;
    switch (self.pickerView.tag) {
        case 1:
            array = self.sizesArray;
            key = @"size_id";
            break;
        case 2:
            array = self.imagesArray;
            key = @"image_id";
            break;
        case 3:
            array = self.regionsArray;
            key = @"region_id";
            break;
        default:
            break;
    }
    NSDictionary *dict = array[index];
    [self.dropletDict setValue:dict[@"id"] forKey:key];
}


- (BOOL)checkForParameters {

    if (!self.dropletDict[@"name"])
        return NO;
    if (!self.dropletDict[@"size_id"])
        return NO;
    if (!self.dropletDict[@"image_id"])
        return NO;
    if (!self.dropletDict[@"region_id"])
        return NO;
    return YES;
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


#pragma mark -
#pragma mark - UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    [self.dropletDict setValue:textField.text forKey:@"name"];
    return YES;
}

@end
