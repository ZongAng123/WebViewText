//
//  otherWebVC.m
//  WebViewText
//
//  Created by ycmedia on 16/5/16.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import "otherWebVC.h"

@implementation otherWebVC
{
    MBProgressHUD *HUD;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.delegate = self;

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingHUD];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self hideHUD];

}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - HUD methods
- (void)showHUDWithText:(NSString *)text
{
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    if (self.navigationController!=nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:HUD];
        [self.navigationController.view bringSubviewToFront:HUD];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [self.view bringSubviewToFront:HUD];
    }
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = text;
    [HUD show:YES];
    [self performSelector:@selector(hideHUD) withObject:nil afterDelay:2.0f];
    
}

- (void)hideHUD
{
    [HUD hide:YES];
}

- (void)showLoadingHUD
{
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
    if (HUD==nil) {
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeIndeterminate;
        // HUD.labelText = @"载入中...";
    }
    [HUD show:YES];
}
@end
