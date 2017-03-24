//
//  NSObject+delayTask.m
//  nuggets
//
//  Created by 郭永红 on 16/7/28.
//
//

#import "NSObject+delayTask.h"

@implementation NSObject (delayTask)

- (void)performTaskWithTimeInterval:(NSTimeInterval)timeInterval action:(void (^)(void))action
{
    double delayInSeconds = timeInterval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        action();
    });
}

@end
