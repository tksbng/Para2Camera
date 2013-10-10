//
//  AnimVC.m
//  Para2Camera
//
//  Created by Takeshi Bingo on 2013/08/24.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import "AnimVC.h"
#import "ListTVC.h"

@interface AnimVC ()

@end

@implementation AnimVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
//スライダーの値を取得するメソッド
-(IBAction)doSliderValueChanged:(id)sender {
    //ImageViewにおけるアニメーションの再生状態を取得する
    BOOL isAnimating = [_aImageView isAnimating];
    //スライダーの変更値を引数にして、ImageViewのアニメーションの速度を設定する
    [_aImageView setAnimationDuration:_aSlider.maximumValue - [_aSlider value]];
    //もしアニメーションが再生(isAnimating == YES)以外のとき
    if ( isAnimating == NO ) {
        //アニメーションをスタートする
        [_aImageView startAnimating];
    }
}
//イメージをリセットする処理
- (void)resetImages {
    //編集可能な配列を生成
    NSMutableArray *ary = [NSMutableArray array];
    //0からkParaParaCount(10)まで連続して以下の処理を行う
    for (int i = 0; i < kParaParaCount; i++) {
        //ListTVCで生成した画像のファイルパスを取得する
        NSString *photoFilePath = [ListTVC makePhotoPathWithIndex:i];
        //もしファイルパスが存在するなら
        if ( [[NSFileManager defaultManager] fileExistsAtPath:photoFilePath] == YES ) {
            //指定したファイルパスのイメージをロードしてイメージオブジェクトを作成する
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            //配列に格納する
            [ary addObject:image];
            //もしImageViewに画像がなければ
            if ([_aImageView image] == nil) {
                //ImageViewに画像をセットする
                [_aImageView setImage:image];
            }
        }
    }
    //配列に格納されている画像にアニメーションを設定する
    [_aImageView setAnimationImages:ary];
    //スライダーの設定値を引数にしてアニメーションの速度を設定する
    [_aImageView setAnimationDuration:[_aSlider value]];
}
//画面が現れたときに呼ばれるメソッド
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //イメージをリセットするメソッドを呼ぶ
    [self resetImages];
}
//画面にタッチされたときに呼ばれるメソッド
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // タッチ判別用
    UITouch *touch = [touches anyObject];
    //自分のviewの中でタッチされた座標を取得する
    CGPoint pos = [touch locationInView:[self view]];
    //もしタッチされた位置(第２引数:pos)が、
    //ImageViewの枠内(第１引数:frame)の範囲内ならば
    if (CGRectContainsPoint([_aImageView frame],pos)) {
        //もしアニメーションが発生していたら
        if ( [_aImageView isAnimating] ) {
            //アニメーションを停止する
            [_aImageView stopAnimating];
        }
        //それ以外(アニメーションが発生していない)の場合
        else {
            //アニメーションをスタートする
            [_aImageView startAnimating];
        }
    }
}
//画面が非表示になったときに呼ばれるメソッド
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //ImageViewのアニメーションをストップする
    [_aImageView stopAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
