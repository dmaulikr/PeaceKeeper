//
//  ChoreDetailViewController.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ChoreDetailViewController.h"
#import "Person.h"
#import "Chore.h"
#import "Household.h"
@import MessageUI;

#import "NSManagedObjectContext+Category.h"



@interface ChoreDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Chore *chore;

@property (strong, nonatomic) MFMessageComposeViewController *messageController;
@property (strong, nonatomic) MFMailComposeViewController *mailController;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation ChoreDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    self.mailController = [[MFMailComposeViewController alloc] init];
    self.mailController.mailComposeDelegate = self;
    
    self.messageController = [[MFMessageComposeViewController alloc]init];
    NSString *message = [NSString stringWithFormat:@"PeaceKeeper Reminder: It's your turn to %@, thanks (:", self.chore.name];
    self.messageController.messageComposeDelegate = self;
    [self.messageController setRecipients:@[self.chore.currentPerson.phoneNumber]];
    [self.messageController setBody:message];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.alert = [UIAlertController alertControllerWithTitle:@"HEY!" message:@"Pick one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self setupAlertController];
    [self fetchChore];
}


- (void)fetchChore {
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Chore name]];
    NSError *error;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching %@ objects: %@", [Chore name], error.localizedDescription);
    } else {
        NSLog(@"Successfully fetched %@ objects", [Chore name]);
    }
    if (results.count > 0) {
        self.chore = results.firstObject;
    }

}


-(void) setupAlertController {
    
    UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Text Reminder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showSMS];
    }];
    
    
    UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Mark as Completed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.chore completeChore];
        [self.tableView reloadData];
        
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [self.alert addAction:sendMessage];
    [self.alert addAction:complete];
    [self.alert addAction:cancel];
    
    if (self.chore.currentPerson.email) {
        
        UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email Reminder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *subjectString = [NSString stringWithFormat:@"Peace Keeper %@ Reminder", self.chore.name];
            NSString *messageBodyString = [NSString stringWithFormat:@"Hey %@, PeaceKeeper reminder about your %@ task (:", self.chore.currentPerson.firstName, self.chore.name];
            if ([MFMailComposeViewController canSendMail])
            {
                self.mailController.mailComposeDelegate = self;
                [self.mailController setSubject:subjectString];
                [self.mailController setMessageBody:messageBodyString isHTML:NO];
                [self.mailController setToRecipients:@[self.chore.currentPerson.email]];
                
                [self presentViewController:self.mailController animated:YES completion:NULL];
            } else {
                NSLog(@"This device cannot send email");
            }
        }];
        
        [self.alert addAction:sendEmail];

    }
    
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}




#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choree" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",self.chore.name, self.chore.currentPerson.firstName];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self presentViewController:self.alert animated:true completion:nil];
    
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


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            [self viewDidAppear:true];
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




#pragma mark - MFMailComposeViewController Delegate
        
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





@end
