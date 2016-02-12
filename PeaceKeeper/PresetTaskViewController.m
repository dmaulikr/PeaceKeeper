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
#import "Functions.h"

@interface PresetTaskViewController () <UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<NSString *> *taskNames;
@property (strong, nonatomic) NSArray<NSString *> *taskImageNames;

@end

@implementation PresetTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.taskNames =      @[@"Vacuum", @"Wash dishes", @"Laundry", @"Take out trash"];
    self.taskImageNames = @[@"Vacuum", @"Dishes",      @"Laundry", @"Trash"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"MakeChore"]) {

        MakeChoreViewController *makeChoreViewController = (MakeChoreViewController *)segue.destinationViewController;
        NSMutableDictionary *choreInfo = [NSMutableDictionary dictionary];
        if ([sender isKindOfClass:[NSIndexPath class]]) {
            NSUInteger row = ((NSIndexPath *)sender).row;
            choreInfo[kChoreInfoKeyTitleString] = self.taskNames[row];
            choreInfo[kChoreInfoKeyImageName] = self.taskImageNames[row];
        }
        if ([sender isKindOfClass:[NSString class]]) {
            choreInfo[kChoreInfoKeyTitleString] = (NSString *)sender;
        }
        makeChoreViewController.choreInfo = choreInfo;
    }
}

#pragma mark - UITableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskNames.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Preset" forIndexPath:indexPath];
    if (indexPath.row < self.taskNames.count) {
        cell.textLabel.text = self.taskNames[indexPath.row];
        cell.imageView.image = iconImageFromImageName(self.taskImageNames[indexPath.row]);
        cell.imageView.tintColor = self.tableView.tintColor;
    }

    if (indexPath.row == self.taskNames.count) {
        cell.textLabel.text = @"Create Custom Task";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.taskNames.count) {
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
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self performSegueWithIdentifier:@"MakeChore" sender:indexPath];
    }
}

@end
