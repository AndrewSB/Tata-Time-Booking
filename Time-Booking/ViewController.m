//
//  ViewController.m
//  Time-Booking
//
//  Created by Andrew Breckenridge on 6/27/14.
//  Copyright (c) 2014 Tata_Technologies. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)buttonWasHit:(id)sender;
            

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonWasHit:(id)sender {
    [self loginToTimeBookingWithPin:self.idField.text pass:self.passwordField.text];
}

- (void)loginToTimeBookingWithPin:(NSString *)pin pass:(NSString *)pass {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    webView.delegate = self;
    
    NSMutableURLRequest *loginRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://timebooking.tatatechnologies.com/bypass_loginUB.do"]];
    [loginRequest setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"loginid=%@&password=%@",
                            [self percentEscapeString:pin],
                            [self percentEscapeString:pass]];
    NSData *postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [loginRequest setHTTPBody:postBody];
    
    [webView loadRequest:[loginRequest mutableCopy]];
    
    [self.view addSubview:webView];
}

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;
    CGSize viewSize = self.view.bounds.size;
    
    float rw = viewSize.width / contentSize.width;
    
    theWebView.scrollView.minimumZoomScale = rw;
    theWebView.scrollView.maximumZoomScale = rw;
    theWebView.scrollView.zoomScale = rw;
}

@end
