//
//  AppDelegate.h
//  OMKit
//
//  Created by oymuzi on 2018/11/24.
//  Copyright © 2018年 幸福的小木子. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

