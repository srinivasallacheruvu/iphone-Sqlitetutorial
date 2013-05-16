//
//  HelloWorldViewController.h
//  SqliteTutorial
//
//  Created by Karthik on 16/05/13.
//  Copyright (c) 2013 Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "Person.h"
@interface HelloWorldViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)addPersonButton:(id)sender;
- (IBAction)displayPersonButton:(id)sender;
- (IBAction)deletePersonButton:(id)sender;
-(IBAction)goAwayKerboard:(id)sender;
-(IBAction)backgroundtap:(id)sender;
@end
