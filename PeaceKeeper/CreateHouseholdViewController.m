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

@interface CreateHouseholdViewController () <CNContactPickerDelegate>

typedef void (^myCompletion)(BOOL);

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UILabel *roomatesLabel;

@property (strong, nonatomic) NSMutableArray *roomates;

@end

@implementation CreateHouseholdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    
    self.roomatesLabel.text = contact.givenName;
    
}


- (IBAction)addRoomatesButtonPressed:(id)sender {
    
    [self requestForAccess:^(BOOL accessGranted) {
        
        CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        
        if (accessGranted) {
            
            NSLog(@"access granted");
            
        } else {
            
            NSLog(@"GTFO!");
            
        }
        
    }];
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
