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

#import "ChooseValueViewControllerDelegate.h"
#import "ChooseValueViewController.h"
#import "ChooseUnitViewControllerDelegate.h"
#import "ChooseUnitViewController.h"
#import "Constants.h"

NSUInteger const dateSection = 0;
NSUInteger const intervalSection = 1;
NSUInteger const valueRow = 0;
NSUInteger const unitRow = 1;

@interface MakeChoreViewController () <UITableViewDelegate, UITableViewDataSource, ChooseValueViewControllerDelegate, ChooseUnitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIDatePicker *startDatePicker;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSNumber *repeatIntervalValue;
@property (strong, nonatomic) NSString *repeatIntervalUnit;

@end

@implementation MakeChoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.startDate = [NSDate date];
    self.repeatIntervalValue = @(1);
    self.repeatIntervalUnit = [TimeService calendarUnitStrings][0];
    
    self.startDatePicker = [[UIDatePicker alloc] init];
    self.startDatePicker.frame = CGRectMake(0, 0, self.view.frame.size.width, self.startDatePicker.frame.size.height);
    [self.startDatePicker addTarget:self action:@selector(startDateDidChangeAction:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AssignChore"]) {
        AssignChoreViewController *assignChoreViewController = (AssignChoreViewController *)segue.destinationViewController;
        NSMutableDictionary *choreInfo = [NSMutableDictionary dictionaryWithDictionary:self.choreInfo];
        choreInfo[kChoreInfoKeyRepeatIntervalValue] = self.repeatIntervalValue;
        choreInfo[kChoreInfoKeyRepeatIntervalUnit] = self.repeatIntervalUnit;
        choreInfo[kChoreInfoKeyStartDate] = self.startDate;
        assignChoreViewController.choreInfo = choreInfo;
    }
    if ([segue.identifier isEqualToString: @"ChooseValue"]) {
        UINavigationController *navController = segue.destinationViewController;
        ChooseValueViewController *chooseValueViewController = navController.viewControllers.firstObject;
        chooseValueViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString: @"ChooseUnit"]) {
        UINavigationController *navController = segue.destinationViewController;
        ChooseUnitViewController *chooseUnitViewController = navController.viewControllers.firstObject;
        chooseUnitViewController.delegate = self;
    }
}

#pragma mark - Actions

- (void)startDateDidChangeAction:(UIDatePicker *)sender {
    self.startDate = sender.date;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == dateSection) {
        return self.startDatePicker.frame.size.height;
    }
    return self.tableView.rowHeight;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case dateSection:
            return 1;
        case intervalSection:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case dateSection:
            return @"Start Date";
        case intervalSection:
            return @"Repeat Interval";
        default:
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == intervalSection) {
        if (self.repeatIntervalValue && self.repeatIntervalUnit) {
            if (self.repeatIntervalValue.integerValue == 1) {
                return [NSString stringWithFormat:@"This alert will repeat every %@", self.repeatIntervalUnit.lowercaseString];
            }
            return [NSString stringWithFormat:@"This alert will repeat every %@ %@s", self.repeatIntervalValue, self.repeatIntervalUnit.lowercaseString];
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == dateSection) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Date"];
        [cell.contentView addSubview:self.startDatePicker];
    } else if (indexPath.section == intervalSection && indexPath.row == valueRow) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Value"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)self.repeatIntervalValue.integerValue];
    } else if (indexPath.section == intervalSection && indexPath.row == unitRow) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Unit"];
        cell.detailTextLabel.text = self.repeatIntervalUnit;
    }
    return cell;
}

#pragma mark - Choose Integer View Controller Delegate

- (void)chooseValueViewControllerDidSelectIntegerNumber:(NSNumber *)number {
    self.repeatIntervalValue = number;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)chooseValueViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Choose Unit View Controller Delegate

- (void)chooseUnitViewControllerDidSelectUnit:(NSString *)unit {
    self.repeatIntervalUnit = unit;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)chooseUnitViewControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
