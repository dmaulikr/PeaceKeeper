//
//  CreateHouseholdViewController.m
//  PeaceKeeper
//
//  Created by HoodsDream on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "CreateHouseholdViewController.h"
#import "AppDelegate.h"
#import "Household.h"
#import "Person.h"
#import "Constants.h"

@import Contacts;
@import ContactsUI;

@interface CreateHouseholdViewController () <CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate>

typedef void (^myCompletion)(BOOL);

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *roomatesLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray<CNContact *> *members;

@property (strong, nonatomic) UIButton *doneButton;

@end

@implementation CreateHouseholdViewController

- (NSMutableArray<CNContact *> *)members {
    if (_members) {
        if (_members.count == 0) {
            self.doneButton.enabled = NO;
            [self.doneButton setBackgroundColor:[UIColor grayColor]];
        } else {
            self.doneButton.enabled = YES;
            [self.doneButton setBackgroundColor:self.view.tintColor];
        }
    }
    return _members;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.members = [[NSMutableArray alloc]init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(aMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height - 40, 160.0, 40.0);
    button.center = CGPointMake(button.frame.origin.x, button.frame.origin.y);
    [button setBackgroundColor:self.view.tintColor];
    self.doneButton = button;
    
    [self.view addSubview:button];
}

- (void)aMethod:(UIButton *)sender {
    if (self.members.count > 0) {
        Household *household = [Household householdWithName:@"Household"];
        for (CNContact *contact in self.members) {
            [Person personFromContact:contact withHousehold:household];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    if (![self.members containsObject:contact]) {
        [self.members addObject:contact];
    }
    [self.tableView reloadData];
}

- (IBAction)addMembers:(UIBarButtonItem *)sender {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    picker.predicateForEnablingContact = [NSPredicate predicateWithFormat:kEnablingContactPredicateString];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell" forIndexPath: indexPath]; {
        CNContact *contact = self.members[indexPath.row];
        NSMutableString *labelText = [NSMutableString stringWithString:contact.givenName];
        if (labelText.length > 0) {
            [labelText appendFormat:@" %@", contact.familyName];
        } else {
            [labelText appendString:contact.familyName];
        }
        cell.textLabel.text = labelText;
        
        return cell;
    }
}

@end
