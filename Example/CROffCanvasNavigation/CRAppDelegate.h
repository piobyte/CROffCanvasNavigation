//
//  CRAppDelegate.h
//  CROffCanvasNavigation
//
//  Created by CocoaPods on 09/04/2014.
//  Copyright (c) 2014 Steve Maahs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CROffCanvasNavigationController.h>

@interface CRAppDelegate : UIResponder <UIApplicationDelegate, CROffCanvasNavigationDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIWindow *window;

@end
