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
    NSURL *url = [NSURL URLWithString:@"http://www.google.co.jp/"];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    // ここでtextFieldにURLを表示
    
    /*
    // ジェスチャ
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];

    // シングルタップが失敗したらロングプレスの解析を開始する
    [singleTapGesture requireGestureRecognizerToFail:longPressGesture];
    [self.view addGestureRecognizer:singleTapGesture];
    [self.view addGestureRecognizer:longPressGesture];
    [self.view addGestureRecognizer:panGesture];
    
    singleTapGesture.delegate = self;
    longPressGesture.delegate = self;
    panGesture.delegate = self;
     */
    
    // delegateを設定
    _webView.delegate = self;
    _urlTextField.delegate = self;
    
    // タイマー(?)
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateSelection:) userInfo:nil repeats:YES];
    
}

// シングルタップされたときに呼び出される
- (void)handleSingleTap:(UIPanGestureRecognizer*)sender {

    [self updateSelection:nil];
    // A simple hack to detect when selection is cleared.
    [self performSelector:@selector(updateSelection) withObject:self afterDelay:0.5];

    // タップした場所の要素を取得する
    /*
     CGPoint touchPoint = [sender locationInView:_webView];
    // NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).toString()", touchPoint.x, touchPoint.y];
    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).innerHTML", touchPoint.x, touchPoint.y];
    NSString * tagName = [_webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"Selected Name: %@",tagName);
    */
    
}
/*
// ロングプレスされたときに呼び出される
- (void)handleLongPress:(UIPanGestureRecognizer*)sender {
    
    if([sender state] == UIGestureRecognizerStateBegan){
        

        
    }else if([sender state] == UIGestureRecognizerStateEnded){
        
        [self updateSelection:nil];
    }
    
}

// 上下ドラッグされた時に呼び出される
- (void)handlePan:(UIPanGestureRecognizer*)sender {
    
    LOG(@"");
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    // すべてのジェスチャを認識する
    return YES;
    
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// webViewのデリゲートメソッド
// webページを移動した時
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    LOG(@"didstartload");
    // インジケータを表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self URLintoTextField];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    // インジケータを非表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// エラーが起こった時
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    LOG(@"%@", error);
    
    // ユーザによるキャンセル時はエラーを出さない
    if (error.code == NSURLErrorCancelled) return;
    
    // "Fame Load Interrupted"エラーを無視する。AppStoreへのリンクは後で開かれる
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    // 101or102の場合、検索処理？
    
    // 音声ファイルを開いた
    if (error.code == 204 && [error.domain isEqual:@"WebKitErrorDomain"]) return;

    NSString *message = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

// UIWebViewはリクエスト送信前にこのメソッドを呼び出し、その返り値が真(YES)ならリクエストを送信、偽(NO)なら中止する
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    LOG(@"shoudlstartloadwithrequest");
    // Determine if we want the system to handle it.
    NSURL *url = request.URL;
    if (![url.scheme isEqual:@"http"] && ![url.scheme isEqual:@"https"]) {

        // ここが実機でも動かなかったら消して、検索処理
        /*
         if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
            return NO;
        }
         */
    }
    return YES;
}

// TextFieldのデリゲートメソッド
// テキストフィールドでキーボードのReturnが押された時
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString *urlString = textField.text;
    
    // textField.textが0文字でなければ、検索orURLリクエスト
    if ([urlString length]) {
        
        // 日本語が入っているかもしれないのでUTF-8にエンコードする
        NSURL *url = [NSURL URLWithString:
                      [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        if(url == nil){
            // 有効なURLではない
            LOG(@"NSURL is nil");
            
        } else {
            LOG(@"loadRequest");
            [_webView loadRequest:[NSURLRequest requestWithURL:url]];
        
        }
        
        
        
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

// 更新ボタンを押した時
- (void)pushReloadButton222
{
    if (_webView) {
        // 戻れる=再読み込み可能
        if ([_webView canGoBack]) {
            [_webView reload];
        } else {
            // 最初に呼び出すのと同じページを読み込む処理
            // google.co.jp
        }
    }
}

// アドレスバーのURLを置き換える
- (void) URLintoTextField {
    _urlTextField.text = [[_webView.request URL] absoluteString];
}

- (void)updateSelection:(NSTimer *)timer {
    
    NSString *selection = [_webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    self.textView.text = selection;
    
}
@end
