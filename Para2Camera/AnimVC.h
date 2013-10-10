//
//  AnimVC.h
//  Para2Camera
//
//  Created by Takeshi Bingo on 2013/08/24.
//  Copyright (c) 2013年 Takeshi Bingo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnimVC : UIViewController
@property (nonatomic, retain) IBOutlet UIImageView *aImageView;
@property (nonatomic, retain) IBOutlet UISlider *aSlider;

//スライダー値の変更用
-(IBAction)doSliderValueChanged:(id)sender;

@end
