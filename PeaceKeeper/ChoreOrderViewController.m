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
#import "CoreDataStackManager.h"
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
    NSString *choreName = (NSString *)self.choreInfo[kChoreInfoKeyTitleString];
    NSDate *choreStartDate = (NSDate *)self.choreInfo[kChoreInfoKeyStartDate];
    NSNumber *choreRepeatIntervalValue = (NSNumber *)self.choreInfo[kChoreInfoKeyRepeatIntervalValue];
    NSString *choreRepeatIntervalUnit = (NSString *)self.choreInfo[kChoreInfoKeyRepeatIntervalUnit];
    NSOrderedSet *people = [NSOrderedSet orderedSetWithArray:self.selectedPeople];
    Household *household = [[CoreDataStackManager sharedManager] fetchHousehold];
    NSString *choreImageName = self.choreInfo[kChoreInfoKeyImageName];
    
    [Chore choreWithName:choreName startDate:choreStartDate repeatIntervalValue:choreRepeatIntervalValue repeatIntervalUnit:choreRepeatIntervalUnit household:household people:people imageName:choreImageName];
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
