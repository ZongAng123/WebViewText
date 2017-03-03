//
//  otherWebVC.h
//  WebViewText
//
//  Created by ycmedia on 16/5/16.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface otherWebVC : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)back:(id)sender;
@property (nonatomic,copy)NSString *url;
@end
