//
//  OMTimer.h
//  OMKit
//
//  Created by oymuzi on 2018/11/24.
//  Copyright © 2018年 oymuzi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**  计时器的时间模型*/
@interface OMTime : NSObject

/** 时-分-秒-毫秒*/
@property (nonatomic, copy) NSString *hour;
@property (nonatomic, copy) NSString *minute;
@property (nonatomic, copy) NSString *second;
@property (nonatomic, copy) NSString *millisecond;

@end

/** 进度闭包回调*/
typedef void(^OMProgressBlock)(OMTime *progress);
/** 完成闭包回调*/
typedef void(^OMTimerCompletion)(void);

/** 计时器*/
@interface OMTimer : NSObject

/** 计时器是否为增加模式*/
@property (nonatomic, assign) BOOL isAscend;
/** 计时器的计时时间*/
@property (nonatomic, assign) NSTimeInterval timerInterval;
/** 计时器触发的精度，默认为100ms触发一次回调，取值区间为100-1000 */
@property (nonatomic, assign) NSInteger precision;
/** 计时器的回调*/
@property (nonatomic, strong) OMProgressBlock progressBlock;
/** 计时器完成的回调*/
@property (nonatomic, strong) OMTimerCompletion completion;
/** 是否为暂停状态*/
@property (nonatomic, assign, readonly, getter=isSupsending) BOOL suspend;
/** 是否为运行状态*/
@property (nonatomic, assign, readonly, getter=isRuning) BOOL run;
/** 是否为完成状态*/
@property (nonatomic, assign, readonly, getter=isComplete) BOOL complete;


/**
 初始化计时器

 @param timeinterval 计时的时间
 @param isAscend 是否为增加计时
 @param progressBlock 进度回调
 @param completion 倒计时结束回调
 @return 计时器
 */
- (instancetype)initWithStartTimeinterval: (NSTimeInterval)timeinterval isAscend: (BOOL)isAscend progressBlock: (OMProgressBlock)progressBlock completionBlock: (OMTimerCompletion)completion;

/** 开始计时*/
- (void)resume;

/** 暂停计时*/
- (void)suspend;

/** 继续暂停的任务*/
- (void)activate;

/** 停止计时*/
- (void)stop;

/** 重置计时器并开始计时*/
- (void)restart;

@end



