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
    _webView.delegate = self;
    _urlTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// webViewのデリゲートメソッド
// webページを移動した時
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self URLintoTextField];
}

// TextFieldのデリゲートメソッド
// テキストフィールドでキーボードのReturnが押された時
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *urlString = textField.text;
    
    // textField.textが0文字でなければ、検索orURLリクエスト
    if ([urlString length]) {
        
        NSURL *url = [NSURL URLWithString:urlString];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
    }
    
    // キーボードを隠す
    [textField resignFirstResponder];
    return YES;
}

// 戻るボタンを押した時
- (IBAction)pushGoBackButton:(id)sender {
    
    [_webView goBack];
    [self URLintoTextField];
    
}

// 進むボタンを押した時
- (IBAction)pushGoForwardButton:(id)sender {
    
    [_webView goForward];
    [self URLintoTextField];
}


// アドレスバーのURLを置き換える
- (void) URLintoTextField {
    _urlTextField.text = [[_webView.request URL] absoluteString];
}
@end
