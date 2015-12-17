//
//  MakeChoreViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "MakeChoreViewController.h"
#import "TimeService.h"
#import "AssignChoreViewController.h"
#import "Constants.h"

@interface MakeChoreViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *choreNameField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *repeatIntervalPicker;

@end

@implementation MakeChoreViewController

- (void)viewDidLoad {
    self.repeatIntervalPicker.delegate = self;
    self.repeatIntervalPicker.dataSource = self;
    self.choreNameField.delegate = self;
    self.navigationItem.rightBarButtonItem.enabled = false;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AssignChore"]) {
        AssignChoreViewController *assignChoreViewController = (AssignChoreViewController *)segue.destinationViewController;
        NSMutableDictionary *choreInfo = [NSMutableDictionary dictionary];
        choreInfo[kChoreInfoKeyIntervalString] = [TimeService calendarUnitStrings][[self.repeatIntervalPicker selectedRowInComponent:0]];
        choreInfo[kChoreInfoKeyStartDate] = self.startDatePicker.date;
        choreInfo[kChoreInfoKeyTitleString] = self.choreNameField.text;
        assignChoreViewController.choreInfo = choreInfo;
    }
}


#pragma mark - Actions
- (IBAction)doneMakingChoreAction:(UIBarButtonItem *)sender {
    NSLog(@"Chore action!");
}
- (IBAction)choreNameFieldEditingChanged:(UITextField *)sender {
    NSString *trimmedString = [sender.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedString.length == 0) {
        self.navigationItem.rightBarButtonItem.enabled = false;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = true;
    }
}

#pragma mark - UIPickerViewDelegate 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [TimeService calendarUnitStrings][row];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [TimeService calendarUnitStrings].count;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return false;
}


@end
