//
//  CreateHouseholdViewController.m
//  PeaceKeeper
//
//  Created by HoodsDream on 12/14/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "CreateHouseholdViewController.h"
#import "AppDelegate.h"
@import Contacts;
@import ContactsUI;
#import "Household.h"
#import "Person.h"

@interface CreateHouseholdViewController () <CNContactPickerDelegate, UITableViewDataSource, UITableViewDelegate>

typedef void (^myCompletion)(BOOL);

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *roomatesLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *members;

@property (strong, nonatomic) NSString *contactName;

@end

@implementation CreateHouseholdViewController

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
    [button setBackgroundColor:[UIColor blueColor]];
    
    [self.view addSubview:button];
    
}

- (void)aMethod:(UIButton *)sender {
    Household *household = [Household householdWithName:@"household"];
    NSMutableSet *memberSet = [NSMutableSet set];
    for (NSString *memberName in self.members) {
        Person *person = [Person personWithName:memberName chore:nil household:household];
        [memberSet addObject:person];
    }
    household.people = memberSet;
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    _contactName = contact.givenName;
    [self.members addObject:_contactName];
    [self.tableView reloadData];
    
    NSLog(@"%lu",(unsigned long)self.members.count);
    NSLog(@"%@", _contactName);
}




-(void) requestForAccess:(myCompletion)completionBlock {
    
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];

    switch (authorizationStatus) {
            
        case CNAuthorizationStatusAuthorized: {
            completionBlock(true);
            break;
        }
            
        case CNAuthorizationStatusDenied: {
            
            [[[AppDelegate getAppDelegate] contactStore] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (granted) {
                    completionBlock(true);
                } else {
                    if (authorizationStatus == CNAuthorizationStatusDenied) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"Error, please allow the app to access your contacts inside your settings menu");
                        });
                    }
                }
                
            }];
            
            break;
        }
            
        default:
            completionBlock(false);
            break;
            
    }
    
}

- (IBAction)addMembers:(UIBarButtonItem *)sender {
    
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableView Methods

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"memberCell" forIndexPath: indexPath]; {
        cell.textLabel.text = self.members[indexPath.row];
        
        return cell;
    }
}





@end
