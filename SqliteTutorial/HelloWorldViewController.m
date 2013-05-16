//
//  HelloWorldViewController.m
//  SqliteTutorial
//
//  Created by Karthik on 16/05/13.
//  Copyright (c) 2013 Karthik. All rights reserved.
//

#import "HelloWorldViewController.h"

@interface HelloWorldViewController(){
    NSMutableArray *arrayOfPerson;
    sqlite3 *personDB;
    NSString *dbPathString;
}

@end

@implementation HelloWorldViewController
@synthesize nameField;
@synthesize ageField;

-(IBAction)goAwayKerboard:(id)sender{
    [sender resignFirstResponder];
}

-(IBAction)backgroundtap:(id)sender{
    [nameField resignFirstResponder];
    [ageField resignFirstResponder];
    
}
- (void)viewDidLoad
{
    arrayOfPerson=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
    [self createOrOpenDB];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)createOrOpenDB{
    NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *docPath=[path objectAtIndex:0];
    dbPathString=[docPath stringByAppendingPathComponent:@"person.db"];
   
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath=[dbPathString UTF8String];
     // create db here
        if (sqlite3_open(dbPath, &personDB)==SQLITE_OK) {
            const char *sql_stmt="CREATE TABLE IF NOT EXISTS PERSONS (10 INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, AGE INTEGER)";
            sqlite3_close(personDB);
            
        }
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrayOfPerson count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    Person *aPerson=[arrayOfPerson objectAtIndex:indexPath.row];
    cell.textLabel.text=aPerson.name;
    cell.detailTextLabel.text=[[NSString alloc]initWithFormat:@"%d",aPerson.age ];
    return cell;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPersonButton:(id)sender {
    
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &personDB)==SQLITE_OK) {
        
        NSString *insertStmt=[NSString stringWithFormat:@"INSERT INTO PERSONS(NAME,AGE) values('%s','%d')",[self.nameField.text UTF8String],[self.ageField.text intValue]];
        const char *insert_stmt=[insertStmt UTF8String];
        if (sqlite3_exec(personDB, insert_stmt, NULL,NULL,&error)==SQLITE_OK) {
            NSLog(@"Person added");
            Person *person=[[Person alloc]init];
            [person setName:self.nameField.text ];
            [person setAge:self.ageField.text ];
             [arrayOfPerson addObject:person];
             
            }
             sqlite3_close(personDB);
    }
}

- (IBAction)displayPersonButton:(id)sender {
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String],&personDB)==SQLITE_OK) {
        [arrayOfPerson removeAllObjects];
        NSString *querysql=[NSString stringWithFormat:@"SELECT *FROM PERSONS"];
        const char *query_sql=[querysql UTF8String];
        if (sqlite3_prepare(personDB, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *name=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_coloum_text(statement,1)];
                NSString *ageString=[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                Person *person=[[Person alloc]init];
                [person setName:name];
                [person setAge:[ageString intValue]];
                [arrayOfPerson addObject:person];
                
            }
        }
        
    }
    [[self myTableView]reloadData];
}

- (IBAction)deletePersonButton:(id)sender {
    
    [[self myTableView]setEditing:!self.myTableView.editing animated:YES];
    
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        
        Person *p=[arrayOfPerson objectAtIndex:indexPath.row];
    [self deleteData:[NSString stringWithFormat:@"delete from persons where name= is '%s'",[p.name UTF8String]]];
        [arrayOfPerson removeObjectAtIndex:indexPath.row];
        // [tableView deleteRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
    }
}

-(void) deleteData:(NSString *)deleteQuery{
    
    char *error;
    if (sqlite3_exec(personDB, [deleteQuery UTF8String], NULL,NULL,&error)==SQLITE_OK) {
        NSLog(@"person deleted");
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
   // [super touchesBegan:<#touches#> withEvent:<#event#>];
    [nameField resignFirstResponder];
    [ageField resignFirstResponder];
}
@end
