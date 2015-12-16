//
//  ChoreDetailViewController.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ChoreDetailViewController.h"
@import MessageUI;


@interface ChoreDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"HEY!" message:@"Pick one" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Message" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showSMS];
    } ];
    
    UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Complete" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addAction:sendMessage];
    [alert addAction:sendEmail];
    [alert addAction:complete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:true completion:nil];
    
//    NSString *selectedFile = [_files objectAtIndex:indexPath.row];
//    [self showSMS:selectedFile];
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

- (void)showSMS{
    
    if (![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"your device doesn't support text messages" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipients = @[@"",@""];
    NSString *message = [NSString stringWithFormat:@"Just sent the file to your email"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc]init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipients];
    [messageController setBody:message];
    
    [self presentViewController:messageController animated:YES completion:nil];
    
}



@end
