//
//  PresetTaskViewController.m
//  PeaceKeeper
//
//  Created by HoodsDream on 12/17/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "PresetTaskViewController.h"
#import "MakeChoreViewController.h"
#import "Constants.h"

@interface PresetTaskViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *taskArray;

@end

@implementation PresetTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.taskArray = @[@"Sweep", @"Mop", @"Clean Kitchen", @"Take Out Trash"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"MakeChore"]) {

        MakeChoreViewController *makeChoreViewController = (MakeChoreViewController *)segue.destinationViewController;
        NSMutableDictionary *choreInfo = [NSMutableDictionary dictionary];
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            choreInfo[kChoreInfoKeyTitleString] = self.taskArray[((NSIndexPath *)sender).row];
//            choreInfo[kChoreInfoKeyImage] =
        }
        if ([sender isKindOfClass:[NSString class]]) {
            choreInfo[kChoreInfoKeyTitleString] = (NSString *)sender;
//            choreInfo[kChoreInfoKeyImage] =
        }
        // fill choreInfo
        makeChoreViewController.choreInfo = choreInfo;
    }
}


#pragma mark - UITableViewDelegate Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"presetTaskCell" forIndexPath:indexPath];
    if (indexPath.row < self.taskArray.count) {
        cell.textLabel.text = self.taskArray[indexPath.row];

    }

    if (indexPath.row == self.taskArray.count) {
        cell.textLabel.text = @"Create Custom Task";
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row == self.taskArray.count) {
        
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set task name" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *text = alert.textFields.firstObject.text;
            [self performSegueWithIdentifier:@"MakeChore" sender:text];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"Task Name";
            
        }];
        
        [self presentViewController:alert animated:true completion:nil];
        
        
        
    } else {
        [self performSegueWithIdentifier:@"MakeChore" sender:indexPath];
    }
    
    
    
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
