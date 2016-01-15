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
#import "CoreDataStackManager.h"
#import "Chore.h"
#import "EditChoreViewController.h"
#import "EditChoreViewControllerDelegate.h"
#import "TimeService.h"
#import "NSDate+Category.h"
#import "Choree.h"
#import "EllipsisView.h"
#import "ChevronView.h"

@import MessageUI;

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
    self.mailController = [[MFMailComposeViewController alloc] init];
    self.mailController.mailComposeDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureMessageAndMailControllersForPerson:(Person *)person {
    NSString *messageBody;
    NSString *mailSubject;
    NSString *mailBody;
    
    if (person == self.chore.currentPerson) {
        messageBody = [NSString stringWithFormat:@"PeaceKeeper Reminder: It's your turn to do %@, thanks 😀", self.chore.name];
        mailSubject = [NSString stringWithFormat:@"PeaceKeeper %@ Reminder", self.chore.name];
        mailBody = [NSString stringWithFormat:@"Hey %@, it's your turn to do %@, thanks 😀", person.firstName, self.chore.name];
    } else {
        messageBody = [NSString stringWithFormat:@"PeaceKeeper Reminder: Your turn to do %@, is coming up 😀", self.chore.name];
        mailSubject = [NSString stringWithFormat:@"PeaceKeeper %@ Reminder", self.chore.name];
        mailBody = [NSString stringWithFormat:@"Hey %@, your turn to do %@ is coming up 😀", person.firstName, self.chore.name];
    }

    if (person.phoneNumber) {
        [self.messageController setBody:messageBody];
        [self.messageController setRecipients:@[person.phoneNumber]];
    }
    if (person.email) {
        [self.mailController setSubject:mailSubject];
        [self.mailController setMessageBody:mailBody isHTML:NO];
        [self.mailController setToRecipients:@[person.email]];
    }
}

- (UIAlertController *)alertControllerForPerson:(Person *)person {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if (person.phoneNumber) {
        UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Text Reminder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showSMS];
        }];
        [alert addAction:sendMessage];
    }
    
    if (person.email) {
        UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showEmail];
        }];
        [alert addAction:sendEmail];
    }
    
    if (person == self.chore.currentPerson) {
        UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Mark as Completed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.chore completeChore];
            [self.tableView reloadData];
        }];
        [alert addAction:complete];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:cancel];
    return alert;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EditChore"]) {
        EditChoreViewController *editChoreViewController = segue.destinationViewController;
        editChoreViewController.mutablePeople = [self.chore mutablePeople];
        editChoreViewController.currentPerson = [self.chore currentPerson];
        editChoreViewController.startDate = self.chore.startDate;
        editChoreViewController.repeatIntervalValue = self.chore.repeatIntervalValue;
        editChoreViewController.repeatIntervalUnit = self.chore.repeatIntervalUnit;
        editChoreViewController.delegate = self;
    }
}

#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chore.chorees count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choree" forIndexPath:indexPath];
    Choree *choree = self.chore.chorees[indexPath.row];
    cell.textLabel.text = choree.person.firstName;
    if (!cell.accessoryView) {
        cell.accessoryView = [EllipsisView ellipsisViewWithSize:CGSizeMake(20.0, 20.0) leftMargin:8 color:self.view.tintColor];
    }
    if (indexPath.row == [self.chore currentPersonIndex].integerValue) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Next up in %@", [choree.alertDate descriptionOfTimeToNowInDaysHoursOrMinutes]];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Due in %@", [choree.alertDate descriptionOfTimeToNowInDaysHoursOrMinutes]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Person *person = [self.chore.chorees objectAtIndex:indexPath.row].person;
    [self configureMessageAndMailControllersForPerson:person];
    [self presentViewController:[self alertControllerForPerson:person] animated:YES completion:nil];
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
        [self presentViewController:self.mailController animated:YES completion:nil];
    }
}

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
    self.chore.startDate = updatedStartDate;
    self.chore.repeatIntervalValue = updatedRepeatIntervalValue;
    self.chore.repeatIntervalUnit = updatedRepeatIntervalUnit;
    [self.chore updateChoreesWithPeople:updatedPeople startingPerson:updatedCurrentPerson];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editChoreViewControllerDidCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

@end

