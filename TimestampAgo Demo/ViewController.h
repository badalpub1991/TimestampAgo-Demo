//
//  ViewController.h
//  TimestampAgo Demo
//
//  Created by safe consults on 22/07/16.
//  Copyright © 2016 Badal Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *txtUnixtime;
@property (strong, nonatomic) IBOutlet UILabel *lblConvertedtime;

- (IBAction)convertUnixtimetotimeAgo:(UIButton *)sender;

@end

