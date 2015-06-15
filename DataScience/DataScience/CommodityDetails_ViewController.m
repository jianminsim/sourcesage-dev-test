//
//  CommodityDetails_ViewController.m
//  DataScience
//
//  Created by Admin on 6/7/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import "CommodityDetails_ViewController.h"

@interface CommodityDetails_ViewController ()

@end

@implementation CommodityDetails_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:[self.commodityDict objectForKey:@"commodity"]];
    
     [self.nameLabel setText:[NSString stringWithFormat:@"INR %@",[self.commodityDict objectForKey:@"commodity"]]];
     [self.minPricelabel setText:[NSString stringWithFormat:@"INR %@",[self.commodityDict objectForKey:@"min_price"]]];
     [self.maxPriceLabel setText:[NSString stringWithFormat:@"INR %@",[self.commodityDict objectForKey:@"max_price"]]];
     [self.modalPriceLabel setText:[NSString stringWithFormat:@"INR %@",[self.commodityDict objectForKey:@"modal_price"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
