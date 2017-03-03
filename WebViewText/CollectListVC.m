//
//  CollectListVC.m
//  WebViewText
//
//  Created by ycmedia on 16/4/22.
//  Copyright © 2016年 ycmedia. All rights reserved.
//

#import "CollectListVC.h"
#import "FMDB.h"
#import "otherWebVC.h"
#import "FTTiXianDetailTableViewCell.h"

//屏幕高度
#define kFTScreenHeight [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define kFTScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface CollectListVC ()


@end

@implementation CollectListVC
{
    NSString *title;
    
    NSString *url;
    
    FMDatabase *db1;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   _webDataArr = [[NSMutableArray alloc]init];

    NSArray * dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [docsDir stringByAppendingPathComponent:@"Main.sqlite"];
    
    FMDatabaseQueue *queue =[FMDatabaseQueue databaseQueueWithPath:databasePath];

//    db=[FMDatabase databaseWithPath:databasePath];

    [queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr =@"CREATE TABLE IF NOT EXISTS Statistics (ID INTEGER PRIMARY KEY AUTOINCREMENT,Title text,Url text)";
        
        BOOL  result =[db executeUpdate:sqlStr];
        
        if (result) {
//            NSLog(@"打开了数据库 %@",databasePath);
            
                FMResultSet *result = [db executeQuery:@"SELECT * FROM Statistics"];
            
                while ([result next]) {
            
                        NSDictionary *dic = [result resultDictionary];
            
//                    NSLog(@"%@",dic);
            
                    [_webDataArr addObject:dic];
                }
            
            
//            db1 = db;
            
                [result close];
        }
        
        else{
            NSLog(@"create/open failled");
        }
        
        
    }];
    


}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _webDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FTTiXianDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tiXianCell" forIndexPath:indexPath];

   NSDictionary * dic =[_webDataArr objectAtIndex:[indexPath row]];
    
    cell.titleLab.text =dic[@"Title"];
    
    cell.urlLabel.text =dic[@"Url"];
    
    [cell.deleteBtn addTarget:self action:@selector(deleteCollect:) forControlEvents:UIControlEventTouchUpInside];
    
   cell.deleteBtn.tag = indexPath.row;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    NSDictionary *dic =[_webDataArr objectAtIndex:[indexPath row]];
    
    otherWebVC *other= [self.storyboard instantiateViewControllerWithIdentifier:@"other"];
    
    other.url = dic[@"Url"];
    
    [self.navigationController pushViewController:other animated:YES];
    

}
- (void)deleteCollect:(UIButton *)sender
{

//    NSDictionary *dic =[[self getDataArr] objectAtIndex:sender.tag-1];
//    
//    NSLog(@"btn的 == %ld",(long)sender.tag);
//    [db1 executeUpdate:@"DELETE FROM Statistics WHERE ID =? ",dic[@"ID"]];
    
//    [_myTableView reloadData];

    UIView* v=[sender superview];
    UITableViewCell* cell=(UITableViewCell*)[[v superview]superview];
    NSIndexPath* indexPath= [_myTableView indexPathForCell:cell];
  
    
    NSDictionary *dic =[_webDataArr objectAtIndex:sender.tag];
    NSLog(@"dic==%@",dic);
    
    [self openSqlite];
    
    [db1 executeUpdate:@"DELETE FROM Statistics WHERE ID =? ",dic[@"ID"]];
    
    

    
    
    [_webDataArr removeObjectAtIndex:indexPath.row];
    
    
    NSLog(@"index.row===%ld",(long)indexPath.row);
    
    if (indexPath.row ==0) {
        
     [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];

    [_myTableView reloadData];

        return;
    }
    
  [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];

    
    [_myTableView reloadData];

 

    
}

-(void)openSqlite
{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc]initWithString:[docsDir stringByAppendingPathComponent:@"Main.sqlite"]];
    db1=[FMDatabase databaseWithPath:databasePath];
    
    if ([db1 open]) {
        
        NSString *sqlStr =@"CREATE TABLE IF NOT EXISTS Statistics (ID INTEGER PRIMARY KEY AUTOINCREMENT,Typed INT,Content BLOB)";
        
        BOOL  result =[db1 executeUpdate:sqlStr];
        
        if (result) {
            NSLog(@"打开了数据库 %@",databasePath);
            
        }

            else{
                NSLog(@"create/open failled");
            }
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-  (NSMutableArray *)getDataArr
{
   FMResultSet *result = [db1 executeQuery:@"SELECT * FROM Statistics"];
    
    while ([result next]) {
                
            NSDictionary *dic = [result resultDictionary];
                
            [_webDataArr addObject:dic];
        }
            
        [result close];

     return _webDataArr;
    
}



- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

}
@end
