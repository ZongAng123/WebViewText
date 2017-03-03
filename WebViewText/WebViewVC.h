//
//  WebViewVC.h
//  WebViewText
//
//  Created by ycmedia on 16/4/15.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ZBarSDK.h"

@interface WebViewVC : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate,ZBarReaderViewDelegate,ZBarReaderDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)goNextBtnClick:(id)sender;
- (IBAction)collectBtnClick:(id)sender;
- (IBAction)collectListBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;




@end
