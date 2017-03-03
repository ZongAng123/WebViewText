//
//  CollectListVC.h
//  WebViewText
//
//  Created by ycmedia on 16/4/22.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *webDataArr;

- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
