//
//  ViewController.h
//  Tata-Technology-ObjC
//
//  Created by Andrew Breckenridge on 6/11/14.
//  Copyright (c) 2014 Tata Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void)loginToTimbookingWithPin:(NSString *)pin pass:(NSString *)pass;
- (NSString *)percentEscapeString:(NSString *)string;

@end

