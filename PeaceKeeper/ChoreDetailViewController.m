//
//  ChoreDetailViewController.m
//  PeaceKeeper
//
//  Created by Francisco Ragland Jr on 12/15/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "ChoreDetailViewController.h"
@import MessageUI;


@interface ChoreDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
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
    
    UIAlertAction *sendMessage = [UIAlertAction actionWithTitle:@"Send Message" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *sendEmail = [UIAlertAction actionWithTitle:@"Send Email" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Create Email Compose View Controller
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            mail.mailComposeDelegate = self;
            [mail setSubject:@"Yo clean dat shit!"];
            [mail setMessageBody:@"Hurry up dawg!" isHTML:NO];
            [mail setToRecipients:@[@"testingEmail@example.com"]];
            
            [self presentViewController:mail animated:YES completion:NULL];
        }
        else
        {
            NSLog(@"This device cannot send email");
        }


    }];
    
    UIAlertAction *complete = [UIAlertAction actionWithTitle:@"Complete" style:UIAlertActionStyleDefault handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addAction:sendMessage];
    [alert addAction:sendEmail];
    [alert addAction:complete];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:true completion:nil];
}



@end
