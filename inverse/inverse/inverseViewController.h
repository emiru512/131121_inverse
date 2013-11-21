//
//  inverseViewController.h
//  inverse
//
//  Created by dagger512 on 13/11/20.
//  Copyright (c) 2013年 Oneko no Gundan. All rights reserved.
//

#import <UIKit/UIKit.h>


//

#define LOG(A, ...) NSLog(@"DEBUG: %s:%dline:%@", __PRETTY_FUNCTION__,__LINE__,[NSString stringWithFormat:A, ## __VA_ARGS__]);

#define SCREEN ([[UIScreen mainScreen] bounds].size)
#define STATUSBARHEIGHT (SCREEN.height - [[UIScreen mainScreen] applicationFrame].size.height)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [UIScreen mainScreen].scale > 1)

//

@interface inverseViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;


@end
