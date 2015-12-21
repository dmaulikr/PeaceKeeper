//
//  ChoreOrderViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ChoreOrderViewController.h"
#import "Constants.h"
#import "Household.h"
#import "Chore.h"
#import "NSManagedObjectContext+Category.h"
#import "TimeService.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ChoreOrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoreOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(UIBarButtonItem *)sender {
    // Save the chore
    NSString *choreName = (NSString *)self.choreInfo[kChoreInfoKeyTitleString];
    NSDate *choreStartDate = (NSDate *)self.choreInfo[kChoreInfoKeyStartDate];
    NSString *choreIntervalString = (NSString *)self.choreInfo[kChoreInfoKeyIntervalString];
    NSOrderedSet *people = [NSOrderedSet orderedSetWithArray:self.selectedPeople];
    Household *household = [Household fetchHousehold];
    [Chore choreWithName:choreName startDate:choreStartDate repeatIntervalValue:@(1) repeatIntervalUnit:choreIntervalString household:household people:people];
    
    // Schedule the notification
    NSCalendarUnit repeatInterval = [TimeService calendarUnitForString:choreIntervalString];
    NSString *alertTitle = [NSString stringWithFormat:@"“%@” Due", choreName];
    NSString *alertBody = [NSString stringWithFormat:@"“%@” is due today. Next alert in one %@", choreName, [choreIntervalString lowercaseString]];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:choreName forKey:kChoreNameKey];
    [TimeService scheduleLocalNotificationInUsersTimeZoneAndCalendarWithFireDate:choreStartDate repeatInterval:repeatInterval alertTitle:alertTitle alertBody:alertBody userInfo:userInfo category:kChoreNotificationCategoryIdentifier];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    Person *person = self.selectedPeople[indexPath.row];
    cell.textLabel.text = [person fullName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Person *selectedPerson = [self.selectedPeople objectAtIndex:sourceIndexPath.row];
    [self.selectedPeople removeObjectAtIndex:sourceIndexPath.row];
    [self.selectedPeople insertObject:selectedPerson atIndex:destinationIndexPath.row];
}

#pragma mark - UITableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
