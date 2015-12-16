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
@import MessageUI;


@interface ChoreDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *peopleArray;
@property (strong, nonatomic) NSMutableArray *choreArray;

@property (strong, nonatomic) MFMessageComposeViewController *messageController;
@property (strong, nonatomic) MFMailComposeViewController *mailController;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation ChoreDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.mailController = [[MFMailComposeViewController alloc] init];
    self.mailController.mailComposeDelegate = self;



}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.messageController = [[MFMessageComposeViewController alloc]init];
    self.alert = [UIAlertController alertControllerWithTitle:@"HEY!" message:@"Pick one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self setupAlertController];
    
}

-(void) setupAlertController {
    
    UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showSMS];
    }];
    
    UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *subjectString = @"Yooooooo clean that shit up!";
        
        NSString *messageBodyString = @"Hey, friendly reminder about your task";
        
        if ([MFMailComposeViewController canSendMail])
        {
            self.mailController.mailComposeDelegate = self;
            [self.mailController setSubject:subjectString];
            [self.mailController setMessageBody:messageBodyString isHTML:NO];
            [self.mailController setToRecipients:@[@"test@gmail.com"]];
            
            [self presentViewController:self.mailController animated:YES completion:NULL];
        } else {
            NSLog(@"This device cannot send email");
        }
    }];
    
    UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Complete" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [self.alert addAction:sendMessage];
    [self.alert addAction:sendEmail];
    [self.alert addAction:complete];
    [self.alert addAction:cancel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Choree" forIndexPath:indexPath];
    cell.textLabel.text = @"Hi";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self presentViewController:self.alert animated:true completion:nil];
    
}

#pragma mark - MFMessageComposerView methods


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
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

- (void)showSMS {
    
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"your device doesn't support text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [warningAlert show];
        return;
    }
    
        NSString *message = [NSString stringWithFormat:@"Just sent the file to your email"];
        self.messageController.messageComposeDelegate = self;
//      [self.messageController setRecipients:@[]];
        [self.messageController setBody:message];
        
        [self presentViewController:self.messageController animated:YES completion:nil];
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
