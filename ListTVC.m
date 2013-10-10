//
//  ListTVC.m
//  Para2Camera
//
//  Created by Takeshi Bingo on 2013/08/24.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "ListTVC.h"

@interface ListTVC ()

@end

@implementation ListTVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //テーブルビューの高さを指定
    [[self tableView] setRowHeight:57.0f];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //テーブルビューのセル数を設定
    return kParaParaCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //セル番号を引数にしてセルに文字列を表示させる
    [[cell textLabel] setText:[NSString stringWithFormat:@"%d 番目",[indexPath row]]];
    // アイコンに"no_image.png"をセットする
    UIImage *iconImage = [UIImage imageNamed:@"no_image.png"];
    //セル番号を引数にして、アイコンのファイルパスを生成する
    NSString *iconFilePath = [self makeIconPathWithIndex:[indexPath row]];
    //「もし、アイコンのファイルパスが存在していたならば」以下のことをする条件文
    if ( [[NSFileManager defaultManager] fileExistsAtPath:iconFilePath] == YES ) {
        //指定したファイルパスのイメージをロードしてイメージオブジェクトを作成する
        iconImage = [UIImage imageWithContentsOfFile:iconFilePath];
    }
    //セルにアイコンイメージを表示させる
    [[cell imageView] setImage:iconImage];

    
    return cell;
}

//行の挿入や削除を行うメソッド
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return NO if you do not want the specified item to be editable.
    //return YES;
    // もし、撮影された写真があれば削除可能とする
    NSString *photoFilePath = [ListTVC makePhotoPathWithIndex:[indexPath row]];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:photoFilePath] == YES ){
        return YES;
    } else {
        return NO;
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //deleteされたときに通過する条件文
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //該当するセルの番号に応じてパスを生成する  ←ここから
        NSString *photoFilePath = [ListTVC makePhotoPathWithIndex:[indexPath row]];
        //エラー状態を初期化する
        NSError *error = nil;
        //もし、パスが存在するならば
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoFilePath]){
            //該当するパスを削除する
            [[NSFileManager defaultManager] removeItemAtPath:photoFilePath error:&error];
            //もしエラーならば、ログを出力し実行を中止する
            if (error != nil) {
                NSLog(@"ファイルの削除でエラー(%@)",[error localizedDescription]);
                return;
            }
        }
        //該当するセルの番号に応じて、アイコンパスを生成する
        NSString *iconFilePath = [self makeIconPathWithIndex:[indexPath row]];
        //もし、アイコンのファイルパスが存在するならば
        if ([[NSFileManager defaultManager] fileExistsAtPath:iconFilePath]) {
            //該当するパスを削除する
            [[NSFileManager defaultManager] removeItemAtPath:iconFilePath error:&error];
            //もしエラーならば、ログを出力して実行を中止する
            if (error != nil) {
                NSLog(@"ファイルの削除でエラー(%@)",[error localizedDescription]);
                return;
            }
        }
        //テーブルビューをリロードする
        [tableView reloadData];
        
    }
    //編集状態のときにセルの挿入がされたら呼ばれる
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }

}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
//セルがタップされたときに呼ばれるメソッド
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //セル番号を格納するメソッド
    idxRow = [indexPath row];
    //写真関係を取り扱うコントローラの初期化
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    //もしカメラが有効ならば（シュミレーターなどでは有効にならない）
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        //カメラから画像を取得する
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        //カメラが有効でなかった場合は、フォトライブラリから画像を取得する
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    //デリゲートをセットする
    [ipc setDelegate:self];
    //編集を可能にする
    [ipc setAllowsEditing:YES];
    //imagePickerControllerをモーダルとして呼び出す（アニメーションを付き）
    [self presentViewController:ipc animated:YES completion:nil];
    //テーブルビューのセルを選択状態（ハイライト）を解除する（アニメーション付き）
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}
//撮影が終了したときに呼ばれるメソッド
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // 編集後写真の取り出し
    UIImage *aImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 撮影した画像をJPEG形式で保存する
    NSString *photoFilePath = [ListTVC makePhotoPathWithIndex:idxRow];
    [UIImageJPEGRepresentation(aImage, 0.7f) writeToFile:photoFilePath atomically:YES];
    //アイコンの作成
    //アイコンのファイルパスを取得
    NSString *iconFilePath = [self makeIconPathWithIndex:idxRow];
    //アイコンを表示させるサイズを指定
    CGSize size = CGSizeMake(57.0f, 57.0f);
    //画像を指定したサイズにリサイズする処理
    UIGraphicsBeginImageContext(size);
    [aImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *imgIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //リサイズされた画像をPNG形式で保存する
    [UIImagePNGRepresentation(imgIcon) writeToFile:iconFilePath atomically:YES];

    //呼び出された画面を、アニメーションを付けながら閉じる
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//撮影後に、キャンセルしたときに呼ばれるメソッド
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//ファイル名を組み立てるメソッド
+(NSString *)makePhotoPathWithIndex:(NSInteger)idx {
    //ホームディレクトリに"Dictionary"という名前のディレクトリを設定
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //保存先を"Dictionary"にし、セル番号を引数にして画像を保存
    NSString *photoFilePath = [NSString stringWithFormat:@"%@/photo-%04d.jpg", docFolder, idx];
    
    return photoFilePath;
}
//アイコンのファイル名を組み立てるメソッド
-(NSString *)makeIconPathWithIndex:(NSInteger)idx
{
    //ホームディレクトリに"Dictionary"という名前のディレクトリを設定
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //保存先を"Dictionary"にし、セル番号を引数にして画像を保存
    NSString *iconFilePath = [NSString stringWithFormat:@"%@/icon-%04d.png", docFolder, idx];
    
    return iconFilePath;
}
//画面が表示されたときに呼ばれるメソッド
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //テーブルビューをリロードする
    [[self tableView] reloadData];
}

@end
