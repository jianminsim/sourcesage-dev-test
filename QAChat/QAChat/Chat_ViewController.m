//
//  Chat_ViewController.m
//  QAChat
//
//  Created by Admin on 6/14/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "Chat_ViewController.h"
#import "Sender_TableViewCell.h"
#import "Reciever_TableViewCell.h"
#import <Parse/Parse.h>
#import "LabelUtility.h"

#define KEYBOARD_HEIGHT 216
#define SERVER_CLASS_NAME @"QAChatRoom"
#define MAX_ENTRIES_LOADED 25

@interface Chat_ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITextField* chatTextField;
    IBOutlet UITableView* chatTableView;
    NSMutableArray* messagesArray;
    NSTimer* chatTimer;
}

@end

@implementation Chat_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    messagesArray = [NSMutableArray new];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    chatTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadLocalChat) userInfo:nil repeats:YES];
    [chatTimer fire];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [chatTimer invalidate];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messagesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* messageText = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageText"];
    NSString* username = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    BOOL isSender = NO;
    if([username isEqualToString:self.logonUsername]) {
        isSender = YES;
    }
    
    if(isSender) {
        
        Sender_TableViewCell* cell = (Sender_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"senderCellIdentifier"];
        CGFloat textHeight = [LabelUtility findHeightForText:messageText havingWidth:cell.messageLabel.frame.size.width andFont:cell.messageLabel.font];
        return 45 + textHeight;
        
    } else {
        Reciever_TableViewCell* cell = (Reciever_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recieverCellIdentifier"];
        CGFloat textHeight = [LabelUtility findHeightForText:messageText havingWidth:cell.messageLabel.frame.size.width andFont:cell.messageLabel.font];
        return 45 + textHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* username = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    BOOL isSender = NO;
    if([username isEqualToString:self.logonUsername]) {
        isSender = YES;
    }
    
    if(isSender) {
        
        Sender_TableViewCell* cell = (Sender_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"senderCellIdentifier" forIndexPath:indexPath];
        cell.messageLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageText"];
        cell.userNameLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
        
        CGFloat cellHeight = [LabelUtility heightWithLabel:cell.messageLabel];
        [cell.messageLabel setFrame:CGRectMake(cell.messageLabel.frame.origin.x, cell.messageLabel.frame.origin.y, cell.messageLabel.frame.size.width, cellHeight)];
        
        return cell;
        
    } else {
        
        Reciever_TableViewCell* cell = (Reciever_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recieverCellIdentifier" forIndexPath:indexPath];
        cell.messageLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageText"];
        cell.userNameLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
        CGFloat cellHeight = [LabelUtility heightWithLabel:cell.messageLabel];
        
        [cell.messageLabel setFrame:CGRectMake(cell.messageLabel.frame.origin.x, cell.messageLabel.frame.origin.y, cell.messageLabel.frame.size.width, cellHeight)];
        return cell;
    }
}

#pragma mark - UITextField Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4  delay:0  options: UIViewAnimationOptionLayoutSubviews  animations:^ {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - KEYBOARD_HEIGHT)];
        
    } completion:^(BOOL finished){
        if([messagesArray count] > 0) {
            [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[messagesArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2  delay:0  options: UIViewAnimationOptionLayoutSubviews  animations:^ {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height + KEYBOARD_HEIGHT)];
        
    } completion:^(BOOL finished){  }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.text.length < 1) {
        [self.view endEditing:YES];
        return YES;
    }
    
    [self sendMessage:textField.text];
    
    if([messagesArray count] > 0) {
        [chatTableView reloadData];
        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[messagesArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    textField.text = @"";
    
    return YES;
}

#pragma mark - Touch Delegate Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Server Side Operations

- (void)sendMessage:(NSString*)message
{
    NSArray *keys = [NSArray arrayWithObjects:@"messageText", @"userName", @"time", nil];
    NSArray *objects = [NSArray arrayWithObjects:message, self.logonUsername, [NSDate date], nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [messagesArray addObject:dictionary];
    
    // going for the parsing
    PFObject *newMessage = [PFObject objectWithClassName:SERVER_CLASS_NAME];
    [newMessage setObject:message forKey:@"messageText"];
    [newMessage setObject:self.logonUsername forKey:@"userName"];
    [newMessage setObject:[NSDate date] forKey:@"time"];
    [newMessage saveInBackground];
}

- (void)loadLocalChat
{
    PFQuery *query = [PFQuery queryWithClassName:SERVER_CLASS_NAME];
    
    __block int totalNumberOfEntries = 0;
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"userName" containedIn:@[self.remoteUserName,self.logonUsername]];
    
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            totalNumberOfEntries = number;
            if (totalNumberOfEntries > [messagesArray count]) {
                int theLimit;
                if (totalNumberOfEntries - [messagesArray count] > MAX_ENTRIES_LOADED) {
                    theLimit = MAX_ENTRIES_LOADED;
                }
                else {
                    theLimit = totalNumberOfEntries - [messagesArray count];
                }
                
                if(messagesArray.count > 0) {
                    query.limit = [NSNumber numberWithInt:theLimit];
                }
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        // The find succeeded.
                        [messagesArray addObjectsFromArray:objects];
                        [chatTableView reloadData];
                        
                        [chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:[messagesArray count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            // The request failed, we'll keep the chatData count?
            number = [messagesArray count];
        }
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
