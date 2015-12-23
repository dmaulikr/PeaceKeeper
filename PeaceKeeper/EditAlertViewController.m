//
//  EditAlertViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/22/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "EditAlertViewController.h"
#import "TimeService.h"

@interface EditAlertViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *repeatIntervalPicker;

@end

@implementation EditAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.repeatIntervalPicker.delegate = self;
    self.repeatIntervalPicker.dataSource = self;
    self.startDatePicker.date = self.initialDate;
    NSInteger initialRow = [[TimeService calendarUnitStrings] indexOfObject:self.initialRepeatIntervalString];
    [self.repeatIntervalPicker selectRow:initialRow inComponent:0 animated:NO];
}

#pragma mark - Actions

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    [self.delegate editAlertViewControllerDidCancel];
}

- (IBAction)doneAction:(UIBarButtonItem *)sender {
    NSString *repeatIntervalString = [TimeService calendarUnitStrings][[self.repeatIntervalPicker selectedRowInComponent:0]];
    [self.delegate editAlertViewControllerDidSelectStartDate:self.startDatePicker.date repeatIntervalValue:@(1) repeatIntervalUnit:repeatIntervalString];
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

@end
