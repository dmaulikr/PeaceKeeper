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

@interface ChoreOrderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoreOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setEditing:true animated:true];
    NSLog(@"tempDictionary: %@", self.tempDictionary);
    NSLog(@"selectedPeople: %@", self.selectedPeople);
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(UIBarButtonItem *)sender {
    NSString *choreName = (NSString *)self.tempDictionary[kTempDictionaryKeyChoreTitleString];
    NSDate *choreStartDate = (NSDate *)self.tempDictionary[kTempDictionaryKeyChoreStartDate];
    NSString *choreIntervalString = (NSString *)self.tempDictionary[kTempDictionaryKeyChoreIntervalString];
    NSOrderedSet *people = [NSOrderedSet orderedSetWithArray:self.selectedPeople];
    Household *household = [Household fetchHousehold];
    [Chore choreWithName:choreName startDate:choreStartDate repeatIntervalValue:@(1) repeatIntervalUnit:choreIntervalString household:household people:people];
    [self.navigationController popToRootViewControllerAnimated:true];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedPeople.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    Person *person = self.selectedPeople[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
    return cell;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return false;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Person *selectedPerson = [self.selectedPeople objectAtIndex:sourceIndexPath.row];
    [self.selectedPeople removeObjectAtIndex:sourceIndexPath.row];
    [self.selectedPeople insertObject:selectedPerson atIndex:destinationIndexPath.row];
}

@end
