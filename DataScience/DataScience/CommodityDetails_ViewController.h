//
//  CommodityDetails_ViewController.h
//  DataScience
//
//  Created by Admin on 6/7/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommodityDetails_ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
@property (nonatomic, weak) IBOutlet UILabel* minPricelabel;
@property (nonatomic, weak) IBOutlet UILabel* maxPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* modalPriceLabel;

@property (nonatomic, strong) NSDictionary* commodityDict;

@end
