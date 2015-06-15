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
#import "AppDelegate.h"
#import <Parse/Parse.h>

#define KEYBOARD_HEIGHT 216
#define SERVER_CLASS_NAME @"QAChatRoom"
#define MAX_ENTRIES_LOADED 25

@interface Chat_ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITextField* chatTextField;
    IBOutlet UITableView* chatTableView;
    NSMutableArray* messagesArray;
    NSString* logonUser;
    NSString* remoteUserName;
    NSTimer* chatTimer;
}

@end

@implementation Chat_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    messagesArray = [NSMutableArray new];
    
    logonUser =  [(AppDelegate*)[[UIApplication sharedApplication]delegate] logonUsername];
    remoteUserName = [(AppDelegate*)[[UIApplication sharedApplication]delegate] remoteUserName];
    
    
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
    if([username isEqualToString:logonUser]) {
        isSender = YES;
    }
    
    if(isSender) {
        
        Sender_TableViewCell* cell = (Sender_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"senderCellIdentifier"];
       CGFloat textHeight = [self findHeightForText:messageText havingWidth:cell.messageLabel.frame.size.width andFont:cell.messageLabel.font];
        return 45 + textHeight;
        
    } else {
        Reciever_TableViewCell* cell = (Reciever_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recieverCellIdentifier"];
        CGFloat textHeight = [self findHeightForText:messageText havingWidth:cell.messageLabel.frame.size.width andFont:cell.messageLabel.font];
        return 45 + textHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* username = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
    BOOL isSender = NO;
    if([username isEqualToString:logonUser]) {
        isSender = YES;
    }
    
    if(isSender) {

        Sender_TableViewCell* cell = (Sender_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"senderCellIdentifier" forIndexPath:indexPath];
        cell.messageLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageText"];
         cell.userNameLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
        
        CGFloat cellHeight = [self heightWithLabel:cell.messageLabel];
        [cell.messageLabel setFrame:CGRectMake(cell.messageLabel.frame.origin.x, cell.messageLabel.frame.origin.y, cell.messageLabel.frame.size.width, cellHeight)];
        
        return cell;
        
    } else {
        
        Reciever_TableViewCell* cell = (Reciever_TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"recieverCellIdentifier" forIndexPath:indexPath];
        cell.messageLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"messageText"];
        cell.userNameLabel.text = [[messagesArray objectAtIndex:indexPath.row] objectForKey:@"userName"];
        CGFloat cellHeight = [self heightWithLabel:cell.messageLabel];

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

#pragma mark - Other Methods

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (CGFloat)heightWithLabel:(UILabel *)label
{
    return [self findHeightForText:label.text havingWidth:label.frame.size.width andFont:label.font];
}

- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    CGFloat width = widthValue;
    if (text) {
        CGSize textSize = { width, CGFLOAT_MAX };       //Width and height of text area
        CGSize size;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            //iOS 7
            CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:font}
                                              context:nil];
            size = CGSizeMake(frame.size.width, frame.size.height+1);
        }
        else
        {
            //iOS 6.0
            size = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
        }
        result = MAX(size.height, result); //At least one row
    }
    return result;
}

#pragma mark - Server Side Operations

- (void)sendMessage:(NSString*)message
{
    NSArray *keys = [NSArray arrayWithObjects:@"messageText", @"userName", @"time", nil];
    NSArray *objects = [NSArray arrayWithObjects:message, logonUser, [NSDate date], nil];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    [messagesArray addObject:dictionary];
    
    // going for the parsing
    PFObject *newMessage = [PFObject objectWithClassName:SERVER_CLASS_NAME];
    [newMessage setObject:message forKey:@"messageText"];
    [newMessage setObject:logonUser forKey:@"userName"];
    [newMessage setObject:[NSDate date] forKey:@"time"];
    [newMessage saveInBackground];
}

- (void)loadLocalChat
{
    PFQuery *query = [PFQuery queryWithClassName:SERVER_CLASS_NAME];
    
    __block int totalNumberOfEntries = 0;
    [query orderByAscending:@"createdAt"];
    [query whereKey:@"userName" containedIn:@[remoteUserName,logonUser]];

    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"There are currently %d entries", number);
            totalNumberOfEntries = number;
            if (totalNumberOfEntries > [messagesArray count]) {
                NSLog(@"Retrieving data");
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
                        NSLog(@"Successfully retrieved %d chats.", objects.count);
                        
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
