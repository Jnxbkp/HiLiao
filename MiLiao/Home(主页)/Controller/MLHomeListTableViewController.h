//
//  MLHomeListTableViewController.h
//  MiLiao
//
//  Created by Jarvan-zhang on 2017/12/29.
//  Copyright © 2017年 Jarvan-zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuInfo;
@interface MLHomeListTableViewController : UITableViewController

/**
 *  菜单信息
 */
@property (nonatomic, strong) MenuInfo *menuInfo;

@end
