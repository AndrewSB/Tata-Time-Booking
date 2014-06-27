//
//  ViewController.m
//  Tata-Technology-ObjC
//
//  Created by Andrew Breckenridge on 6/11/14.
//  Copyright (c) 2014 Tata Technology. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            
- (IBAction)loginButtonHit:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passWordField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

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

- (IBAction)loginButtonHit:(id)sender {
//    NSLog(@"Button was hit");
//    UIAlertView *loginAlertView = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Login to Tata Timebookin" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
//    
//    loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//    UITextField *pinTextField = [loginAlertView textFieldAtIndex:0];
//    UITextField *passwordTextField = [loginAlertView textFieldAtIndex:1];
//    //pinTextField.keyboardType = uikeyyboard;
//    pinTextField.placeholder = @"Employee ID";
//    passwordTextField.placeholder = @"Password";
//    pinTextField.keyboardAppearance = UIKeyboardAppearanceDark;
//    passwordTextField.keyboardAppearance = UIKeyboardAppearanceDark;
//    
//    [loginAlertView show];
    [self loginToTimbookingWithPin:self.userNameField.text pass:self.passWordField.text];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"Continue"]) {
        NSString *userPin = [alertView textFieldAtIndex:0].text;
        NSString *userPassword = [alertView textFieldAtIndex:1].text;
        NSLog(@"Login to %@ with userpass", self.userNameField);
        [self loginToTimbookingWithPin:self.userNameField pass:self.passWordField];
        
    }
}

- (void)loginToTimbookingWithPin:(NSString *)pin pass:(NSString *)password {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.URLCache = NULL;
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:config delegate: nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSLog(@"logging in");
    __block NSDictionary *myDictResult = nil; //set Returner as a block so it's assignable *in* the completion block
    
    NSMutableURLRequest *loginRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://timebooking.tatatechnologies.com/bypass_loginUB.do"]]];
    [loginRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [loginRequest setHTTPMethod:@"POST"];
    
    
    NSString *postString = [NSString stringWithFormat:@"loginid=%@&password=%@",
                            [self percentEscapeString:pin],
                            [self percentEscapeString:password]];
    NSData * postBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [loginRequest setHTTPBody:postBody];
    
    NSURLSessionDataTask *loginTask = [defaultSession dataTaskWithRequest:loginRequest completionHandler:^(NSData *loginData, NSURLResponse *loginResponse, NSError *loginError) {
        //NSLog(@"Heres the data %@\n response %@\n error%@", [[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding], loginResponse, loginError);
        
        if ([loginData length] > 0 && loginError == nil) {
            if ([[[NSString alloc] initWithData:loginData encoding:NSUTF8StringEncoding] rangeOfString:@"<P>This page uses frames. The current browser you are using does not"].location != NSNotFound) {
                NSLog(@"Login was successful, querying home page");
                
                NSMutableURLRequest *homepageRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://timebooking.tatatechnologies.com/TimeBooking/bookTimeStartUB.do"]];
                [homepageRequest setHTTPMethod:@"GET"];
                
                NSURLSessionDataTask *homepageTask = [defaultSession dataTaskWithRequest:homepageRequest completionHandler:^(NSData *homepageData, NSURLResponse *homepageResponse, NSError *homepageError) {
                    NSLog(@"homepage request data is %@\nresponse %@\n error %@", [[NSString alloc] initWithData:homepageData encoding:NSUTF8StringEncoding], homepageResponse, homepageError);
                }]; //[homepageTask resume];
            }
        }
        
        
    }]; //[loginTask resume];
    
    UIWebView *mainWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    [self.webView loadRequest:loginRequest];
}

- (NSString *)percentEscapeString:(NSString *)string {
    NSString *result = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)string,
                                                                                 (CFStringRef)@" ",
                                                                                 (CFStringRef)@":/?@!$&'()*+,;=",
                                                                                 kCFStringEncodingUTF8));
    return [result stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)bookTimeOnDate:(NSDate *)date hours:(NSNumber *)hours {
    
}

@end
