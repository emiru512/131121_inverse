//
//  inverseViewController.m
//  inverse
//
//  Created by dagger512 on 13/11/20.
//  Copyright (c) 2013年 Oneko no Gundan. All rights reserved.
//

#import "inverseViewController.h"

@interface inverseViewController ()

@end

@implementation inverseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 初期URL
    NSURL *url = [NSURL URLWithString:@"http://www.google.co.jp"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    // テキストフィールドのdelegateを設定
    _urlTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // キーボードを隠す
    [textField resignFirstResponder];
    return YES;
}

@end
