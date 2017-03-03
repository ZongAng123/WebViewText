//
//  FTTiXianDetailTableViewCell.h
//  TuoTu
//
//  Created by GTL on 15/11/17.
//  Copyright © 2015年 Sec_Yu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTTiXianDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end
