//
//  ListTVC.h
//  Para2Camera
//
//  Created by Takeshi Bingo on 2013/08/24.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>
//パラパラ漫画の枚数を指定する
#define kParaParaCount 10

@interface ListTVC : UITableViewController
<
// カメラ用
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
{
        // カメラ起動の元になったセルの番号
        NSInteger idxRow;
}
//ファイル名を組み立てるメソッド
+(NSString *)makePhotoPathWithIndex:(NSInteger)idx;

@end
