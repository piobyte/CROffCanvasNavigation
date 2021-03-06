//
//  CRAppDelegate.m
//  CROffCanvasNavigation
//
//  Created by CocoaPods on 09/04/2014.
//  Copyright (c) 2014 Steve Maahs. All rights reserved.
//

#import "CRAppDelegate.h"

#import <CROffCanvasNavigationController.h>

#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"
#import "ViewControllerThree.h"

@implementation CRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    //[_window setRootViewController:[story instantiateViewControllerWithIdentifier:@"OCNC"]];
    CROffCanvasNavigationController *controller = (CROffCanvasNavigationController *)_window.rootViewController;
    [controller setOffCanvasDelegate:self];
    controller.shouldFadeOut = YES;
    controller.fadeoutColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSArray *)arrayOfViewControllerForOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController
{
    ViewControllerOne *vc1 = [[ViewControllerOne alloc] init];
    ViewControllerTwo *vc2 = [[ViewControllerTwo alloc] init];
    ViewControllerThree *vc3 = [[ViewControllerThree alloc] init];
    
    return @[vc1,vc2,vc3];
}

- (void)willSlideMenuInOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController
{

}

- (id<UITableViewDataSource>)tableViewDataSourceForOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController
{
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

@end
