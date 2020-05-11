# LJTimer

## 介绍

使用dispatch_source 开发的定时器

## 创建

```objective-c
- (void)startAt: (dispatch_time_t)delay seconds: (dispatch_time_t)seconds success: (void(^)(void))success progress: (void(^)(NSUInteger value))progress complete: (void(^)(void))complete;
```

## 暂停

```objective-c
- (void)suspend: (void(^)(void))complete;
```



## 继续

```objective-c
- (void)resume:(void(^)(void))complete;
```



## 销毁

```objective-c
- (void)cancel;
```

