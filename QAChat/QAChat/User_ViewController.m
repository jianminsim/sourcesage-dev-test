//
//  ViewController.m
//  QAChat
//
//  Created by Admin on 6/14/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "User_ViewController.h"
#import "Chat_ViewController.h"

@interface User_ViewController ()<UITextFieldDelegate>
{
    IBOutlet UITextField* myUserNameTextField;
    IBOutlet UITextField* remoteUserNameTextField;
    IBOutlet UIButton* enterButton;
    
}
@end

@implementation User_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    myUserNameTextField.text = @"";
    remoteUserNameTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterButtonClicked:(UIButton*)sender {
    
    NSString* myUserName = myUserNameTextField.text;
    NSString* remoteUserName = remoteUserNameTextField.text;
    NSString* error = nil;
  
    if(myUserName.length < 1 && remoteUserName.length < 1) {
        
       error = @"Enter Valid usernames";
        
    } else if([myUserName isEqualToString:remoteUserName]) {
        error = @"Both Username cannot be same";
    } else {
        [self performSegueWithIdentifier:@"HomeToChatScreen" sender:nil];
        error = nil;
        [self.view endEditing:YES];
        
        return;
    }
    
    if(error) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - UITextFiled Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Touch Delegate Method
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     if([[segue identifier] isEqualToString:@"HomeToChatScreen"]) {
         Chat_ViewController* chatViewController = [segue destinationViewController];
         [chatViewController setLogonUsername:myUserNameTextField.text];
         [chatViewController setRemoteUserName:remoteUserNameTextField.text];
     }else {
         
     }
     
 }
 @end
