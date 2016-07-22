//
//  ViewController.m
//  TimestampAgo Demo
//
//  Created by safe consults on 22/07/16.
//  Copyright © 2016 Badal Shah. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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

- (IBAction)convertUnixtimetotimeAgo:(UIButton *)sender {
    NSString *unixdate;
    if ([_txtUnixtime isEqual:@""]) {
        unixdate=@"1469164289";
    }
    else
    {
        unixdate=_txtUnixtime.text;
    }
    
    double unixTimeStamp = [unixdate doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    
    //NSString *timeago=[self gettimes:date];
    
    NSString *timeago=[self getTimestampForDate:date];
    
    _lblConvertedtime.text=timeago;
}

#pragma mark --> Convert to time ago method
- (NSString*)getTimestampForDate:(NSDate*)date {
    
    NSDate* sourceDate = date;
    
    // Timezone Offset compensation (optional, if your target users are limited to a single time zone.)
    
    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    // Timestamp calculation (based on compensation)
    
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth |   NSCalendarUnitDay |  NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *differenceComponents = [currentCalendar components:unitFlags fromDate:destinationDate toDate:[NSDate date] options:0];//Use `date` instead of `destinationDate` if you are not using Timezone offset correction
    
    NSInteger yearDifference = [differenceComponents year];
    NSInteger monthDifference = [differenceComponents month];
    NSInteger dayDifference = [differenceComponents day];
    NSInteger hourDifference = [differenceComponents hour];
    NSInteger minuteDifference = [differenceComponents minute];
    
    NSString* timestamp;
    
    if (yearDifference == 0
        && monthDifference == 0
        && dayDifference == 0
        && hourDifference == 0
        && minuteDifference <= 2) {
        
        //"Just Now"
        
        timestamp = @"Just Now";
        
    } else if (yearDifference == 0
               && monthDifference == 0
               && dayDifference == 0
               && hourDifference == 0
               && minuteDifference < 60) {
        
        //"13 minutes ago"
        
        timestamp = [NSString stringWithFormat:@"%ld minutes ago", (long)minuteDifference];
        
    } else if (yearDifference == 0
               && monthDifference == 0
               && dayDifference == 0
               && hourDifference == 1) {
        
        //"1 hour ago" EXACT
        
        timestamp = @"1 hour ago";
        
    } else if (yearDifference == 0
               && monthDifference == 0
               && dayDifference == 0
               && hourDifference < 24) {
        
        timestamp = [NSString stringWithFormat:@"%ld hours ago", (long)hourDifference];
        
    } else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        
        NSString* strDate, *strDate2 = @"";
        
        if (yearDifference == 0
            && monthDifference == 0
            && dayDifference == 1) {
            
            //"Yesterday at 10:23 AM", "Yesterday at 5:08 PM"
            
            [formatter setDateFormat:@"hh:mm a"];
            strDate = [formatter stringFromDate:date];
            
            timestamp = [NSString stringWithFormat:@"Yesterday at %@", strDate];
            
        } else if (yearDifference == 0
                   && monthDifference == 0
                   && dayDifference < 7) {
            
            //"Tuesday at 7:13 PM"
            
            [formatter setDateFormat:@"EEEE"];
            strDate = [formatter stringFromDate:date];
            [formatter setDateFormat:@"hh:mm a"];
            strDate2 = [formatter stringFromDate:date];
            
            timestamp = [NSString stringWithFormat:@"%@ at %@", strDate, strDate2];
            
        } else if (yearDifference == 0) {
            
            //"July 4 at 7:36 AM"
            
            [formatter setDateFormat:@"MMMM d"];
            strDate = [formatter stringFromDate:date];
            [formatter setDateFormat:@"hh:mm a"];
            strDate2 = [formatter stringFromDate:date];
            
            timestamp = [NSString stringWithFormat:@"%@ at %@", strDate, strDate2];
            
        } else {
            
            //"March 24 2010 at 4:50 AM"
            
            [formatter setDateFormat:@"d MMMM yyyy"];
            strDate = [formatter stringFromDate:date];
            [formatter setDateFormat:@"hh:mm a"];
            strDate2 = [formatter stringFromDate:date];
            
            timestamp = [NSString stringWithFormat:@"%@ at %@", strDate, strDate2];
        }
    }
    
    return timestamp;
}@end
