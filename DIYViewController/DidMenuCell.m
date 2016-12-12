//
//  DidMenuCell.m
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/10.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import "DidMenuCell.h"

@implementation DidMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.iocIamegView.layer setCornerRadius:8];
    [self.iocIamegView.layer setMasksToBounds:true];
}

- (void)setData:(id)data{
      NSString * mainPicUrl = @"http://pic.to8to.com/";
    [self.iocIamegView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainPicUrl,data[@"button_img"]]] placeholderImage:[UIImage imageNamed:@""]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
