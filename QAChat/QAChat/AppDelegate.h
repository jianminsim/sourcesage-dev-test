//
//  AppDelegate.h
//  QAChat
//
//  Created by Admin on 6/14/15.
//  Copyright (c) 2015 Amit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString* logonUsername;
@property (nonatomic, strong) NSString* remoteUserName;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

