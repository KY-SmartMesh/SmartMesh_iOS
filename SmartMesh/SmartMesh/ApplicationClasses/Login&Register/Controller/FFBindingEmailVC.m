//
//  FFBindingEmailVC.m
//  SmartMesh
//
//  Created by Megan on 2017/10/13.
//  Copyright © 2017年 SmartMesh Foundation All rights reserved.
//

#import "FFBindingEmailVC.h"
#import "FFSendMessageViewController.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"

@interface FFBindingEmailVC ()<UITextFieldDelegate>
{
    UILabel     * _tipsLabel;
    UILabel     * _contryTips;
    UITextField * _emailText;
}
@end

@implementation FFBindingEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = DDYLocalStr(@"MeBindingEmail");
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextButtonOnClicked)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self observeNotification:UIKeyboardWillShowNotification];
    [self observeNotification:UIKeyboardWillHideNotification];
    [self observeNotification:UITextFieldTextDidChangeNotification];
}

- (void)buildUI
{
    [self.view addTapTarget:self action:@selector(tapAction)];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, DDYSCREENW - 40, 45)];
    _tipsLabel.text = DDYLocalStr(@"BindingEmailTip");
    _tipsLabel.font = NA_FONT(16);
    _tipsLabel.numberOfLines = 2;
    _tipsLabel.textColor = LC_RGB(111, 111, 111);
    [self.view addSubview:_tipsLabel];
    
    _contryTips = [[UILabel alloc] initWithFrame:CGRectMake(20, _tipsLabel.viewBottomY + 10, DDYSCREENW - 40, 20)];
    _contryTips.text = DDYLocalStr(@"BindingYourEmail");
    _contryTips.font = NA_FONT(12);
    [self.view addSubview:_contryTips];
    
    _emailText = [[UITextField alloc] initWithFrame:LC_RECT(15, _contryTips.viewBottomY + 10, DDYSCREENW - 30, 35)];
    _emailText.placeholder = DDYLocalStr(@"BindingEmailAddress");
    _emailText.font = NA_FONT(24);
    _emailText.textColor = LC_RGB(42, 42, 42);
    _emailText.delegate = self;
    [_emailText becomeFirstResponder];
    [self.view addSubview:_emailText];
    
}

- (void)nextButtonOnClicked
{
    [self getCodeAction];
}

-(void) getCodeAction
{
    [FFLocalUserInfo LCInstance].isRSAKey = YES;
    
    NSDictionary * params = @{@"email" : _emailText.text,
                              @"type"  : @"0"
                              };
    
    [NANetWorkRequest na_postDataWithService:@"mail" action:@"send" parameters:params results:^(BOOL status, NSDictionary *result) {
        
        if (status) {
            
            //跳转下一页输入验证码
            FFSendMessageViewController * controller = [[FFSendMessageViewController alloc] init];
            controller.status = 1;
            controller.emailStr = _emailText.text;
            [self.navigationController pushViewController:controller animated:YES];
            
            [FFLocalUserInfo LCInstance].isRSAKey = NO;
        }
        else
        {
            NSString * errcode = [result objectForKey:@"errcode"];
            NSLog(@"==错误码:%@==",errcode);
        }
        
    }];
}

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification is:UIKeyboardWillShowNotification]) {
        
        [self keyboardWillShow:notification];
        
    }else if ([notification is:UIKeyboardWillHideNotification]){
        
        [self keyboardWillHide:notification];
    }
    else if ([notification is:UITextFieldTextDidChangeNotification]){
        
        [self textFieldChange];
        
    }
    
}


- (void)tapAction
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Responding to keyboard events

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldChange
{
    if (_emailText.text.length != 0) {
        
//        [_signBtn setUserInteractionEnabled:YES];
//        [_signBtn setBackgroundColor:LC_RGB(248, 220, 74)];
//        [_signBtn setTitleColor:LC_RGB(51, 51, 51) forState:UIControlStateNormal];
        
    }
    else
    {
//        [_signBtn setUserInteractionEnabled:NO];
//        [_signBtn setBackgroundColor:LC_RGB(230, 230, 230)];
//        [_signBtn setTitleColor:LC_RGB(153, 153, 153) forState:UIControlStateNormal];
    }
    
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self moveInputBarWithKeyboardHeight:65 withDuration:animationDuration + 0.5];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration+0.2];
}

- (void) moveInputBarWithKeyboardHeight:(float)height withDuration:(NSTimeInterval)interval
{
    [UIView animateWithDuration:interval animations:^{
        
        //        [_contentScrollView setContentOffset:CGPointMake(0, height)];
    }];
}

@end
