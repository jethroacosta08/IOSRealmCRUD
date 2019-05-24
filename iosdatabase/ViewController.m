//
//  ViewController.m
//  iosdatabase
//
//  Created by Jethro Acosta on 23/05/2019.
//  Copyright © 2019 Jethro Acosta. All rights reserved.
//

#import "ViewController.h"
#import "objectModels/User.h"
#import "Commons/CommonUtil.h"

@interface ViewController ()

@end

@implementation ViewController
RLMRealm *realm;
BOOL updateUserMode;
NSMutableArray *tableData;
User *selectedUserData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    realm = [RLMRealm defaultRealm];

    NSURL *realmPath = [RLMRealmConfiguration defaultConfiguration].fileURL;
    NSLog(@"%@",realmPath);
    
    [self populateUserTableData];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.userTableView addGestureRecognizer:tap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (void) populateUserTableData
{
    tableData = [User allObjects];
    [_userTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"UserListScreen";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    User *userInfo = [tableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = userInfo.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %d",userInfo.age];
    cell.imageView.image = [UIImage imageNamed: userInfo.image];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        @try {
            [self deleteUser:indexPath.row];
            [self.userTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } @catch (NSException *exception) {
            NSLog(exception);
        }
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}

- (void)tableTapped:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.userTableView];
    NSIndexPath *path = [self.userTableView indexPathForRowAtPoint:location];
    
    if(path)
    {
        // tap was on existing row, so pass it to the delegate method
        [self tableView:self.userTableView didSelectRowAtIndexPath:path];
        
    }
    else
    {
        // handle tap on empty space below existing rows however you want
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger *index = indexPath.row;
    selectedUserData = [tableData objectAtIndex:index];
    updateUserMode = YES;
    [_userNameText setText: selectedUserData.name];
    [_ageText setText:[NSString stringWithFormat:@"%d", selectedUserData.age]];
}

- (void)addUser:(User*)userObj {
    [realm transactionWithBlock:^{
        [realm addObject:userObj];
        [realm commitWriteTransaction];
    }];
}

- (void)updateUser:(User*)userObj{
    [realm beginWriteTransaction];
    selectedUserData.name = userObj.name;
    selectedUserData.age = userObj.age;
    [realm commitWriteTransaction];
    [_userTableView reloadData];
    updateUserMode = NO;
}

- (void)deleteUser:(NSInteger*)index{
    [realm beginWriteTransaction];
    [realm deleteObject:[tableData objectAtIndex:index]];
    [realm commitWriteTransaction];
    
    [_userNameText setText:@""];
    [_ageText setText:@""];
    updateUserMode = NO;
}

- (IBAction)saveButtonClick:(id)sender {
    if(sender == _saveButton)
    {
        NSString *userID = [CommonUtil getUUID];
        NSString *nameInput = _userNameText.text;
        NSString *profileImage = @"profile";
        NSString *ageInput = _ageText.text;
        
        if((nameInput == nil) || ([nameInput isEqualToString:@""]))
        {
            [self showAlert:@"Oops..." :@"Please enter name"];
        }
        else if((ageInput == nil) || ([ageInput isEqualToString:@""]))
        {
            [self showAlert:@"Ooops..." :@"Please enter age"];
        }
        else
        {
            [_userNameText setText:@""];
            [_ageText setText:@""];
            
            User *userObj = [[User alloc] init];
            userObj.userID = userID;
            userObj.name = nameInput;
            userObj.image = profileImage;
            userObj.age = [ageInput intValue];
            
            if(!updateUserMode)
            {
                [self addUser:userObj];
                [self showAlert:@"Success" :@"User successfully added"];
            }
            else
            {
                [self updateUser:userObj];
                [self showAlert:@"Success" :@"User successfully updated"];
            }
            [_userTableView reloadData];
        }
    }
}

- (void)showAlert:(NSString *)header : (NSString *)message
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:header
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)cancelButtonClick:(id)sender {
    [_userNameText setText:@""];
    [_ageText setText:@""];
    updateUserMode = NO;
}
@end
