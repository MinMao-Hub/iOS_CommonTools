//
//  NSObject+delayTask.h
//  nuggets
//
//  Created by 郭永红 on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (delayTask)
- (void)performTaskWithTimeInterval:(NSTimeInterval)timeInterval action:(void (^)(void))action;
@end
