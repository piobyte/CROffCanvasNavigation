//
//  CROffCanvasNavigationController.h
//  CROffCanvasNavigation
//
//  Copyright (c) 2014 Steve Maahs <romair90@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@class CROffCanvasNavigationController;
@protocol CROffCanvasNavigationDelegate;

/**
 CROffCanvasNavigationController
 @name This Controller is for an off - canvas View which uses a navigationcontroller and his navigationbar.
 */
@interface CROffCanvasNavigationController : UINavigationController

@property (nonatomic, readonly) UIView *offCanvasView;
@property (nonatomic, readonly) NSArray *offCanvasViewControllers;
@property IBOutlet id <CROffCanvasNavigationDelegate> offCanvasDelegate;
@property BOOL highlightWithTintColor;
@property BOOL shouldFadeOut;
@property (nonatomic) UIColor *fadeoutColor;

- (void)toggleOffCanvasView;

/**
 
 @param offCanvasNavigationController
 is the actual Instance you are working on. This Block is for the one that use IB to instantiate the controller, here you can set an array of viewcontrollers.
 */
//@property (copy) void (^loadViewControllers)(CROffCanvasNavigationController* offCanvasNavigationController);

@end

@protocol CROffCanvasNavigationDelegate <NSObject>

@required

@optional
- (NSArray *)arrayOfViewControllerForOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController;

- (UIImage *)offCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController menuButtonImageForNextViewController:(UIViewController *)viewController;

- (void)willSlideMenuInOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController;
- (void)willSlideMenuOutOffCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasNavigationController;

- (void)offCanvasNavigationController:(CROffCanvasNavigationController *)offCanvasViewController didInitTableView:(UITableView *)tableView;

@end