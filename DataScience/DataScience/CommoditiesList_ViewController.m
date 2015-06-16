//
//  ViewController.m
//  DataScience
//
//  Created by Admin on 6/7/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "CommoditiesList_ViewController.h"
#import "NetworkConnection.h"
#import "CommodityDetails_ViewController.h"
#import "CreateCSV.h"
#import <MessageUI/MessageUI.h> 

@interface CommoditiesList_ViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate, NetworkConnection_Delegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UITableView* listTableView;
    NSMutableArray* listOfCommodities;
    NetworkConnection* networkConnection;
}

@end

@implementation CommoditiesList_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    listOfCommodities = [[NSMutableArray alloc] init];

    networkConnection = [[NetworkConnection alloc]initWithDelegate:self];
    [networkConnection networkRequestForData];
}

#pragma mark - UITableView delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfCommodities count] ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[listOfCommodities objectAtIndex:indexPath.row] objectForKey:@"commodity"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"CommodityListToDetailScreen" sender:indexPath];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"CommodityListToDetailScreen"]) {
        CommodityDetails_ViewController* detailVC = [segue destinationViewController];
        NSIndexPath* indexPath = (NSIndexPath*)sender;
        [detailVC setCommodityDict:[listOfCommodities objectAtIndex:indexPath.row]];
    } else {
        
    }
}

#pragma mark - Action Methods
- (IBAction)refresh:(id)sender
{
    [listOfCommodities removeAllObjects];
    [listTableView reloadData];
    
    [networkConnection networkRequestForData];
}

- (IBAction)email:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Email"delegate:self  cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email to your Friend", nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheet Delegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if(buttonIndex == 0) {
        
        NSString* csvFilePath = [CreateCSV createCSVForData:listOfCommodities];
        if(csvFilePath!=nil) {
            [self  composeMailWithFilePath:csvFilePath];
        }
    } else {
        //do  nothing
    }
}

#pragma mark - Compose Mail Delegate Methods
-(void)composeMailWithFilePath:(NSString*)filePath
{
    NSString* errorMessage;
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil)  {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]) {
            [self displayComposerSheet:filePath];
        } else  {
            errorMessage = @"You need to add an E-mail account in phone settings.";
        }
    } else  {
        errorMessage = @"You need to add an E-mail account in phone settings";
    }
    
    if(errorMessage) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)displayComposerSheet:(NSString*)filePath
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Re:Latest Commodity Price Details"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"jian.sim@sourcesage.co"];
   // NSArray *ccRecipients = [NSArray arrayWithObjects:@"xyz@abc.com", nil];
    //    NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
   // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Attach an image to the email
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSString* fileName = [filePath lastPathComponent];
    [picker addAttachmentData:myData mimeType:@"csv" fileName:fileName];
    
    // Fill out the email body text
    NSString *emailBody = @"Please refer the attachment";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString* message = nil;
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            message = @"Email cancelled.";
            break;
        case MFMailComposeResultSaved:
            message = @"Enail saved.";
            break;
        case MFMailComposeResultSent:
            message = @"Details exported successfully.";
            break;
        case MFMailComposeResultFailed:
            message = @"Email sending has been failed. Please try again.";
            break;
        default:
            message = @"Email sending has been failed. Please try again.";
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^ {
        if(message) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    [CreateCSV removeTempStoredFiles];
}


#pragma mark - Network Connection Delegates
- (void)networkRequestDidSuccessWithResponse:(id)response
{
    [listOfCommodities removeAllObjects];
    [listOfCommodities addObjectsFromArray:response];
    
    [listTableView reloadData];
}

- (void)networkRequestDidFailedWithResponse:(id)response andError:(NSError *)error {
    [listOfCommodities removeAllObjects];
    [listTableView reloadData];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
