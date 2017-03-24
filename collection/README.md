### 常用集合对象相关总结



### 概述

集合对象是开发过程中最常用到的东西，这里就相关内容简单的做一下总结。

### 1. 可属性列表化的对象有以下几种

|type||
|---|---|
|NSDictionary|字典|
|NSArray|数组|
|NSString|字符串|
|NSNumber|数字类型|
|Boolean|布尔|
|NSData|数据|
|NSdate|时间|


### 1. jsonObject转换到NSString

```objective-c
- (NSString *) stringFromJsonObject:(id)object{
    NSError *error;
    NSString *JSONString;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"json error");
    } else {
        
        JSONString  = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",JSONString);
    }
    
    
    return JSONString;
}
```
一般在发送网络请求(JSON)的时候可能会用到；

`object `可以为`NSArray `、`NSDictionary `可以被属性列表化(其字子项不能为自定义对象，只能是常用属性列表对象)的对象
