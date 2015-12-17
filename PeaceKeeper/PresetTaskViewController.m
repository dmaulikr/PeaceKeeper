//
//  PresetTaskViewController.m
//  PeaceKeeper
//
//  Created by HoodsDream on 12/17/15.
//  Copyright © 2015 Francisco Ragland. All rights reserved.
//

#import "PresetTaskViewController.h"

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



#pragma mark UITableViewDelegate Methods


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
