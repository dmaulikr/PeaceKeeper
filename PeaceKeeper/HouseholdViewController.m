//
//  HouseholdViewController.m
//  PeaceKeeper
//
//  Created by Work on 12/16/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "HouseholdViewController.h"
#import "Household.h"
#import "Person.h"

@import Contacts;
@import ContactsUI;

@interface HouseholdViewController () <UITableViewDataSource, UITableViewDelegate, CNContactPickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Household *household;

@end

@implementation HouseholdViewController

- (Household *)household {
    if (!_household) {
        _household = [Household fetchHousehold];
    }
    return _household;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Actions
- (IBAction)addAction:(id)sender {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:@"givenName != ''"];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    BOOL contactNotInHousehold = true;
    for (Person *person in self.household.people.allObjects) {
        if (person.firstName == contact.givenName && person.lastName == contact.familyName) {
            contactNotInHousehold = false;
        }
    }
    if (contactNotInHousehold) {
        [Person personFromContact:contact withHousehold:self.household];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.household.people.allObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Person" forIndexPath:indexPath];
    Person *person = self.household.people.allObjects[indexPath.row];

    NSString *contactString = @"";
    if (person.email && person.phoneNumber) {
        contactString = [NSString stringWithFormat:@"%@, %@", person.email, person.phoneNumber];
    } else if (person.email) {
        contactString = person.email;
    } else if (person.phoneNumber) {
        contactString = person.phoneNumber;
    }
    cell.textLabel.text = [person fullName];
    cell.detailTextLabel.text = contactString;
    return cell;
}

#pragma mark - UITableViewDelegate

@end
