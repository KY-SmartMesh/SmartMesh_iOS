//
//  FFSendMessageViewController.h
//  SmartMesh
//
//  Created by Megan on 2017/9/22.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "DDYBaseViewController.h"

@interface FFSendMessageViewController : DDYBaseViewController

@property(nonatomic,assign)NSInteger status;//0.手机验证 1.邮箱验证
@property(nonatomic,strong)NSString * emailStr;
@property(nonatomic,strong)NSString * phoneStr;

@end
