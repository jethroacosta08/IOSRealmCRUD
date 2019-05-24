//
//  ViewController.h
//  iosdatabase
//
//  Created by Jethro Acosta on 23/05/2019.
//  Copyright © 2019 Jethro Acosta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveButtonClick:(id)sender;
- (void)showAlert:(NSString *)header : (NSString *)message;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
- (IBAction)cancelButtonClick:(id)sender;

@end

