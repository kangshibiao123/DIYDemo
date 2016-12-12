//
//  DIYViewControler.m
//  DIYViewController
//
//  Created by kangshibiao on 2016/12/9.
//  Copyright © 2016年 ZheJiangTianErRuanJian. All rights reserved.
//

#import "DIYViewControler.h"
#import "KSRequestManager.h"
#import <Foundation/Foundation.h>
#import "CoreDataManager.h"
#import "ItemsView.h"
#import <UIImageView+WebCache.h>
@implementation DiyImageView

static char myDiction;
- (void)setDictionary:(NSDictionary *)dictionary{
    objc_setAssociatedObject(self, &myDiction, dictionary, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)dictionary{
    return objc_getAssociatedObject(self, &myDiction);
}

static char box_idChar;
- (void)setBox_id:(NSInteger)box_id{
    objc_setAssociatedObject(self, &box_idChar, @(box_id), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)box_id{
    return [objc_getAssociatedObject(self, &box_idChar) integerValue];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    //    NSLog(@"\n%@  \n%f %f",self.boxDict[@"name"],point.x,point.y);
    BOOL bl =  [self pointInside:point withEvent:event];
    if (bl) {
        CGFloat value = [self colorOfPoint:point];
        if (value > 0.2) {
            NSLog(@"%f",value);
            
            return self;
        }
    }

    return nil;
}

- (CGFloat)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return pixel[3]/255.0;
}

@end

@interface DIYViewControler ()

@property (strong, nonatomic) NSArray * iamgeArray;

@property (strong, nonatomic) NSArray * subBoxArray;

@property (strong, nonatomic) ItemsView * itmes;

@property (strong, nonatomic) NSMutableArray *diyImageViewsArray;
@end

@implementation DIYViewControler

- (NSMutableArray *)diyImageViewsArray{
    if (!_diyImageViewsArray) {
        _diyImageViewsArray = [NSMutableArray array];
    }
    return _diyImageViewsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self getRequsetData];
    
    UIButton * goBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBack addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    goBack.frame  =CGRectMake(20, 20, 40, 20);
    [goBack setTitle:@"返回" forState:UIControlStateNormal];
    [self.view insertSubview:goBack atIndex:111];
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark -- 获取图片数据
- (void)getRequsetData{
    
    NSString * url = @"http://www.to8to.com/mobileapp/xnjz/index.php?v=1.4&controller=box&action=list&vrid=1506";
    [KSRequestManager postRequestWithUrlString:url parameter:@{} success:^(id responseObject) {
        self.iamgeArray = responseObject[@"content"][@"box"];
        self.subBoxArray = responseObject[@"content"][@"subbox"];
        [self startLayoutPage];
    } failure:^(NSError *error) {
        
    }];
}

- (void)startLayoutPage{
    
    [self.iamgeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //http://pic.to8to.com/vm/50/d0/55/50d0556181432340dc0f421c89802acf.png
        NSString * mainPicUrl = @"http://pic.to8to.com/";
        
        NSString *modeUrl = [NSString stringWithFormat:@"%@%@",mainPicUrl,obj[@"model_img"]];

        CGFloat diScale = [obj[@"scale"] floatValue];
        CGFloat scale = [UIScreen mainScreen].scale ;
        
        NSDictionary * dic = [[CoreDataManager sharedCoreDataManager] queryManagerGetData:modeUrl];
        UIImage *image = nil;
        if (dic) {
           image = [UIImage imageWithData:KSDIC(dic, @"imageData") scale:scale/diScale];

        }else{
            NSData  *data= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:modeUrl]];
            image = [UIImage imageWithData:data scale:scale/diScale];
            [[CoreDataManager sharedCoreDataManager] instertModel:modeUrl imageData:data];;

        }
        CGFloat kWRate = 0;
        CGFloat kHrate = 0;
        if ([UIScreen mainScreen].bounds.size.width != 736) {
            kWRate = [[UIScreen mainScreen] bounds].size.width/568.0;
            kHrate = [[UIScreen mainScreen] bounds].size.height/375.0;
        }else{
            kWRate = [[UIScreen mainScreen] bounds].size.width/375.0f;
            kHrate = [[UIScreen mainScreen] bounds].size.height/252.0f;
            
        }
        // kWRate ，kHrate 主要是用来布局的参数
        CGFloat x = [obj[@"point_x"] floatValue]*kWRate;
        CGFloat y = [obj[@"point_y"] floatValue]*kHrate;
        NSUInteger level = [obj[@"level"] integerValue];
        
        DiyImageView * diyImage = [[DiyImageView alloc]initWithFrame:CGRectMake(x,y, [obj[@"wscale"] floatValue]*image.size.width*kWRate, [obj[@"hscale"] floatValue]*image.size.height*kHrate)];
        diyImage.dictionary = KSDIC(obj, @"subbox")[0];
        diyImage.box_id = [KSDIC(obj, @"box_id") integerValue];
        diyImage.image= image;
        if (x != 0||y != 0) {
            diyImage.center = CGPointMake(x/scale, y/scale);
        }
        [self.view insertSubview:diyImage atIndex:level];
        //添加点击事件
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapClick:)];
        diyImage.userInteractionEnabled = YES;
        [diyImage addGestureRecognizer:imageTap];
        [self.diyImageViewsArray addObject:diyImage];
        
    }];
    
    UIButton *resetButton =[UIButton buttonWithType:UIButtonTypeCustom];
    resetButton.frame = CGRectMake(40, [UIScreen mainScreen].bounds.size.height - 60, 40, 40);
    [resetButton setTitle:@"重置" forState:UIControlStateNormal];
    [resetButton setTintColor:[UIColor whiteColor]];
    [resetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [resetButton addTarget:self action:@selector(resetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:resetButton atIndex:100];
    
    UIButton *menuButton =[UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 140, [UIScreen mainScreen].bounds.size.height - 60, 40, 40);
    [menuButton setTitle:@"菜单" forState:UIControlStateNormal];
    [menuButton setTintColor:[UIColor whiteColor]];
    [menuButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [menuButton addTarget:self action:@selector(menuButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:menuButton atIndex:100];
    
}

/*! 图片的点击事件  */
- (void)imageTapClick:(UITapGestureRecognizer *)tap{
    
    DiyImageView * diy = (DiyImageView *)tap.view;
    if (_itmes) {
        [_itmes removeFromSuperview];
    }
    NSString * Id = diy.dictionary[@"id"];
    if ([Id integerValue] != 0) {
        [self showMenusView:Id];
    }
    
}

#pragma mark -- resetButton 重置
- (void)resetButton{
    
    [self.iamgeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * mainPicUrl = @"http://pic.to8to.com/";

        NSString *modeUrl = [NSString stringWithFormat:@"%@%@",mainPicUrl,obj[@"model_img"]];
        
        CGFloat diScale = [obj[@"scale"] floatValue];
        CGFloat scale = [UIScreen mainScreen].scale ;
        
        NSDictionary * dic = [[CoreDataManager sharedCoreDataManager] queryManagerGetData:modeUrl];
        UIImage *image = nil;
        if (dic) {
            image = [UIImage imageWithData:KSDIC(dic, @"imageData") scale:scale/diScale];
            
        }else{
            NSData  *data= [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:modeUrl]];
            image = [UIImage imageWithData:data scale:scale/diScale];
            [[CoreDataManager sharedCoreDataManager] instertModel:modeUrl imageData:data];;
            
        }
        DiyImageView * diy = self.diyImageViewsArray[idx];
        diy.image = image;
        
    }];
}

#pragma mark -- menuButton 菜单
- (void)menuButton{
    if (_itmes) {
        [_itmes removeFromSuperview];
    }
    [self showMenusView:nil];
 }

- (void)showMenusView:(NSString *)Id{
    
    __weak typeof(self) weakSelf = self;
    _itmes = [[ItemsView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, 60, [UIScreen mainScreen].bounds.size.height)];
    if (Id) {
        _itmes.mainIdx = 1;
        _itmes.bigArray = [self getIdDictionary:Id];
    }
    _itmes.subDataArray = self.subBoxArray;
    _itmes.mainData = ^(id data){
        NSLog(@"----%@",data);
        [weakSelf updateIamgeView:data];
        
    };
    [self.view addSubview:_itmes];
    [_itmes showMoveItemsView];

}

- (NSMutableArray *)getIdDictionary:(NSString *)Id{
    __block NSMutableArray *bigArray = [NSMutableArray array];
    __block NSMutableDictionary * dic = nil;
    [self.subBoxArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([KSDIC(obj, @"id") intValue] == [Id intValue]) {
            NSArray * arr = obj[@"factorys"];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dic = [[NSMutableDictionary alloc]initWithDictionary:obj];
                [dic setObject:@(0) forKey:@"isFlog"];
                [bigArray addObject:dic];
            }];
        }
    }];
    return bigArray;
}

- (void)updateIamgeView:(id)data{
    [self.diyImageViewsArray enumerateObjectsUsingBlock:^(DiyImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.box_id == [KSDIC(data, @"box_id") integerValue]) {
            NSString * mainPicUrl = @"http://pic.to8to.com/";
            obj.alpha = .4;
            [UIView animateWithDuration:.5 animations:^{
                obj.alpha = 1;
            }];
            [obj sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",mainPicUrl,KSDIC(data, @"img")]]];
        }
    }];
}
@end
