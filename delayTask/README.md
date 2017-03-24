## delayTask

一个简单的延时操作小工具，可以在任何地方使用，其基于NSObject创建

### implementation

###### *NSObject+delayTask.h*

```objective-c
#import <Foundation/Foundation.h>

@interface NSObject (delayTask)
- (void)performTaskWithTimeInterval:(NSTimeInterval)timeInterval action:(void (^)(void))action;
@end
```
###### *NSObject+delayTask.m*

```
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
```


### Usage

```
[self performTaskWithTimeInterval:0.5 actionBlock:^(NSDictionary *info) {
   //other code on time finished
        
}];

```

*`self` 可以为任意对象*