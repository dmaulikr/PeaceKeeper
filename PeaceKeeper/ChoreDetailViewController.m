//
//  ChoreDetailViewController.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ChoreDetailViewController.h"
#import "Person.h"
#import "Household.h"
@import MessageUI;
#import "NSManagedObjectContext+Category.h"
#import "Chore.h"
#import "EditChoreViewController.h"
#import "EditChoreViewControllerDelegate.h"
#import "TimeService.h"

@interface ChoreDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, EditChoreViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MFMessageComposeViewController *messageController;
@property (strong, nonatomic) MFMailComposeViewController *mailController;

@end


@implementation ChoreDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = self.chore.name;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.messageController = [[MFMessageComposeViewController alloc] init];
    self.messageController.messageComposeDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIAlertController *)alertControllerForSelectedPerson {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"HEY!" message:@"Pick one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Text Reminder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showSMS];
    }];
    
    UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Mark as Completed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.chore completeChore];
        [self.tableView reloadData];
        
    }];
    
    UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showEmail];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if (self.chore.currentPerson.phoneNumber) {
        [alert addAction:sendMessage];
    }
    
    if (self.chore.currentPerson.email) {
        [alert addAction:sendEmail];
    }
    
    
    [alert addAction:complete];
    [alert addAction:cancel];
    return alert;
}

#pragma mark - Segue

/*
 @property (strong, nonatomic) NSMutableOrderedSet<Person *> *mutablePeople;
 @property (strong, nonatomic) Person *currentPerson;
 
 @property (strong, nonatomic) NSDate *startDate;
 @property (strong, nonatomic) NSString *repeatIntervalString;
 
 @property (weak, nonatomic) id<EditChoreViewControllerDelegate> delegate;
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditChore"]) {
        EditChoreViewController *editChoreViewController = segue.destinationViewController;
        editChoreViewController.mutablePeople = [NSMutableOrderedSet orderedSetWithOrderedSet:self.chore.people];
        editChoreViewController.currentPerson = [self.chore currentPerson];
        editChoreViewController.startDate = self.chore.startDate;
        editChoreViewController.repeatIntervalUnit = self.chore.repeatIntervalUnit;
        editChoreViewController.delegate = self;
    }
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chore.people count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choree" forIndexPath:indexPath];
    Person *person = self.chore.people[indexPath.row];
    cell.textLabel.text = [person fullName];
    if (indexPath.row == self.chore.currentPersonIndex.integerValue) {
        cell.detailTextLabel.text = @"Next up";
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == self.chore.currentPersonIndex.integerValue) {
        NSString *message = [NSString stringWithFormat:@"PeaceKeeper Reminder: It's your turn to %@, thanks 😀", self.chore.name];
        if (self.chore.currentPerson.phoneNumber) {
            [self.messageController setRecipients:@[self.chore.currentPerson.phoneNumber]];
        }
        [self.messageController setBody:message];
        [self presentViewController:[self alertControllerForSelectedPerson] animated:YES completion:nil];
    }
}

#pragma mark - MFMessageComposerView methods

- (void)showSMS {
    
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"your device doesn't support text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [warningAlert show];
        return;
    }
    
    [self presentViewController:self.messageController animated:YES completion:nil];
    
}


//delegate method
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            [self viewDidAppear:YES];
            break;
        case MessageComposeResultFailed:{
            UIAlertView *warningAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Failed to send message!"delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - MFMailComposeViewController methods

- (void)showEmail {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *subjectString = [NSString stringWithFormat:@"Peace Keeper %@ Reminder", self.chore.name];
        NSString *messageBodyString = [NSString stringWithFormat:@"Hey %@, PeaceKeeper reminder about your %@ task 😀", self.chore.currentPerson.firstName, self.chore.name];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:subjectString];
        [mailViewController setMessageBody:messageBodyString isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }

}
//delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - EditChoreViewControllerDelegate
- (void)editChoreViewControllerDidSaveWithPeople:(NSOrderedSet * _Nonnull)updatedPeople
                                  currentPerson:(Person * _Nonnull)updatedCurrentPerson
                                       startDate:(NSDate * _Nonnull)updatedStartDate
                             repeatIntervalValue:(NSNumber * _Nonnull)updatedRepeatIntervalValue
                              repeatIntervalUnit:(NSString * _Nonnull)updatedRepeatIntervalUnit {
    
    if (![updatedStartDate isEqualToDate:self.chore.startDate] || ![updatedRepeatIntervalUnit isEqualToString:self.chore.repeatIntervalUnit]) {
        [self.chore replaceStartDate:updatedStartDate repeatIntervalUnit:updatedRepeatIntervalUnit];
        [TimeService removeChoreNotificationsWithName:self.chore.name];
        [TimeService scheduleNotificationForChore:self.chore];
    }
    
    // Remove people who aren't in self.mutablePeople
    for (Person *person in self.chore.people) {
        if (![updatedPeople containsObject:person]) {
            [self.chore removePerson:person];
        }
    }
    
    // Add people who aren't self.chore.people
    for (Person *person in updatedPeople) {
        if (![self.chore.people containsObject:person]) {
            [self.chore addPerson:person];
        }
    }
    
    [self.chore replacePeople:updatedPeople];
    
    // Reset the current person index
    NSUInteger currentPersonIndex = [self.chore.people indexOfObject:updatedCurrentPerson];
    if (currentPersonIndex == NSNotFound) {
        self.chore.currentPersonIndex = @(0);
    } else {
        self.chore.currentPersonIndex = @(currentPersonIndex);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editChoreViewControllerDidCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

