

//  WebViewVC.m
//  WebViewText
//
//  Created by ycmedia on 16/4/15.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import "WebViewVC.h"
#import "FMDB.h"
#import "CollectListVC.h"
#import "CustomURLCache.h"

#import <JavaScriptCore/JSContext.h>
#import <JavaScriptCore/JSValue.h>

#import <JavaScriptCore/JSManagedValue.h>

#import <JavaScriptCore/JSVirtualMachine.h>

#import <JavaScriptCore/JSExport.h>
@interface WebViewVC ()

@end

@implementation WebViewVC
{
    NSString *URL;
    NSString *title;
    FMDatabase *db;
    
    NSMutableArray *dataArr;

    MBProgressHUD *HUD;


}

- (void)viewDidLoad {
    [super viewDidLoad];

//    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
//                                                                 diskCapacity:200 * 1024 * 1024
//                                                                     diskPath:nil
//                                                                    cacheTime:0];
//    [CustomURLCache setSharedURLCache:urlCache];
    
    _webView.delegate = self;
    
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.141:8020/YCFED/zhengyongliang/projectList/index.html"]]];
    
     [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://m.baidu.com/?from=844b&vit=fps#"]]];
    
    dataArr = [NSMutableArray array];
    

    
    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [docsDir stringByAppendingPathComponent:@"Main.sqlite"];
    
    db=[FMDatabase databaseWithPath:databasePath];

    if ([db open]) {
        
        
        NSString *sqlStr =@"CREATE TABLE IF NOT EXISTS Statistics (ID INTEGER PRIMARY KEY AUTOINCREMENT,Title text,Url text)";
        
        BOOL  result =[db executeUpdate:sqlStr];
        
        if (result) {
            NSLog(@"打开了数据库 %@",databasePath);
        }
        
        else{
            NSLog(@"create/open failled");
        }
        
        
    }
    
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
    
    if (_webView.canGoBack) {
        
        [_backBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _backBtn.enabled = YES;
        
    }else
    {
        [_backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        _backBtn.enabled = NO;
        
    }
    if (_webView.canGoForward) {
        
        [_goBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        _goBtn.enabled = YES;
        
    }else
    {
        [_goBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        _goBtn.enabled = NO;
        
    }

    title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];//获取当前页面的title
    
    URL = webView.request.URL.absoluteString;
    
    NSLog(@"title-%@--url-%@",title,URL);
    
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    
    context[@"test1"] = ^(){
        
        NSArray *args =[JSContext currentArguments];
        for (id obj in args) {
                        NSLog(@"12=%@",obj);
        }
    
    };

    NSString *jsFunctStr=@"test1('参数1')";
    [context evaluateScript:jsFunctStr];
    
    //二个参数
    NSString *jsFunctStr1=@"test1('参数a','参数b')";
    [context evaluateScript:jsFunctStr1];
    
    
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//127.0.0.1
//返回
- (IBAction)backBtnClick:(id)sender {
    if (_webView.canGoBack) {
        
        [_webView goBack];
    }
    
}
//前进
- (IBAction)goNextBtnClick:(id)sender {
    if (_webView.canGoForward) {

        [_webView goForward];
    }
    
}
//收藏
- (IBAction)collectBtnClick:(id)sender {
    
    [db executeUpdate:@"INSERT INTO Statistics (Title,Url) VALUES (?,?);",title,URL];
    [self showHUDWithText:@"收藏成功"];
    
}
//收藏列表
- (IBAction)collectListBtnClick:(id)sender {
    
//    //
//    FMResultSet *result = [db executeQuery:@"SELECT * FROM Statistics"];
//    
//    while ([result next]) {
//        
//            NSDictionary *dic = [result resultDictionary];
//        
//        NSLog(@"%@",dic);
//        
//        [dataArr addObject:dic];
//        NSLog(@"%@",dataArr);
//    }
//    
//    [result close];
//    
    
//    
    CollectListVC *coll= [self.storyboard instantiateViewControllerWithIdentifier:@"collect"];
    
    coll.webDataArr =dataArr;

//    [self presentViewController:coll animated:YES completion:nil];

    [self.navigationController pushViewController:coll animated:YES];
//
    
    
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
