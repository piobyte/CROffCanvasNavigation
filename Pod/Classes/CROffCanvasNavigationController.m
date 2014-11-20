//
//  CROffCanvasNavigationController.m
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

#import "CROffCanvasNavigationController.h"

@interface CROffCanvasNavigationController () <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property BOOL sideViewOpen;
@property UIView *fadeoutView;
@property CGFloat offCanvasWidth;

@property UIPanGestureRecognizer *swipeMenuGestureRecognizer;

- (void)setContra;
- (void)removeContra;

@end

@implementation CROffCanvasNavigationController

//@synthesize viewControllers = _viewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self){
    // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    _offCanvasWidth = 270;
    
    CGRect frameRect = (CGRect){{-_offCanvasWidth,0},{_offCanvasWidth,self.view.frame.size.height}};
    
    int style = 0;
    if (style == 0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:frameRect style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        _offCanvasView = tableView;
    } else {
        _offCanvasView = [[UIView alloc] initWithFrame:frameRect];
        _offCanvasView.backgroundColor = [UIColor grayColor];
    }
    
    if([_offCanvasDelegate respondsToSelector:@selector(arrayOfViewControllerForOffCanvasNavigationController:)]) {
        _offCanvasViewControllers = [_offCanvasDelegate arrayOfViewControllerForOffCanvasNavigationController:self];
    } else {
        _offCanvasViewControllers = @[];
    }
    
    if ([_offCanvasDelegate respondsToSelector:@selector(offCanvasNavigationController:didInitTableView:)]) {
        [_offCanvasDelegate offCanvasNavigationController:self didInitTableView:(UITableView *)_offCanvasView];
    }
    
    [self addPanGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GestureRecognizer
#pragma mark
- (void)addPanGestureRecognizer
{
    if (_swipeMenuGestureRecognizer == nil) {
        _swipeMenuGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(doPanGestureWithRecognizer:)];
    }
    [self.view addGestureRecognizer:_swipeMenuGestureRecognizer];
}

- (void)removePanGestureRecognizer
{
    [self.view removeGestureRecognizer:_swipeMenuGestureRecognizer];
}

- (void)doPanGestureWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint tranlation = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:self.view];
    NSLog(@"%@ - %@",[NSValue valueWithCGPoint:tranlation],[NSValue valueWithCGPoint:velocity]);
    
//    NSLog(@"%@",recognizer);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self beganPanRecognitionWithTranslation:tranlation Velocity:velocity];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        [self changedPanRecognitionWithTranslation:tranlation Velocity:velocity];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self endedPanRecognitionWithTranslation:tranlation Velocity:velocity];
    } else if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self canceledPanRecognitionWithTranslation:tranlation Velocity:velocity];
    }
}

- (void)beganPanRecognitionWithTranslation:(CGPoint)translation Velocity:(CGPoint)velocity
{
    if (!_sideViewOpen) {
        [self.view addSubview:_offCanvasView];
        if (_shouldFadeOut) {
            [self setContra];
        }
    }
    if ([_offCanvasDelegate respondsToSelector:@selector(beganGestureRecognitionOnOffCanvasNavigationController:)]) {
        [_offCanvasDelegate beganGestureRecognitionOnOffCanvasNavigationController:self];
    }
}

- (void)endedPanRecognitionWithTranslation:(CGPoint)translation Velocity:(CGPoint)velocity
{
    if (!_sideViewOpen) {
        if (translation.x > 50) {
            double duration = ABS((_offCanvasWidth - translation.x) / velocity.x);
            duration = duration < .5 ? duration : .5;
            
            UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseOut;
            
            [self toggleOffCanvasViewWithDuration:duration animationCurve:animationCurve];
        } else {
            double duration = (ABS(translation.x) / _offCanvasWidth) * sqrt(M_E);
            
            [UIView animateWithDuration:duration animations:^{
                for (UIView *view in self.view.subviews) {
                    if (![view isEqual:_fadeoutView]) {
                        [view setTransform:CGAffineTransformIdentity];
                    }
                }
                
                if (_shouldFadeOut) {
                    _fadeoutView.backgroundColor = [UIColor clearColor];
                }
            } completion:^(BOOL finished) {
                [_offCanvasView removeFromSuperview];
                [_fadeoutView removeFromSuperview];
            }];
        }
    } else {
        if (translation.x < -50) {
            double duration = ABS((_offCanvasWidth + translation.x) / velocity.x);
            duration = duration < .5 ? duration : .5;
            
            UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseOut;
            
            [self toggleOffCanvasViewWithDuration:duration animationCurve:animationCurve];
        } else {
            double duration = (ABS(translation.x) / _offCanvasWidth) * sqrt(M_E);
            
            [UIView animateWithDuration:duration animations:^{
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                
                for (UIView *view in self.view.subviews) {
                    if (![view isEqual:_fadeoutView]) {
                        [view setTransform:CGAffineTransformMakeTranslation(_offCanvasWidth, 0)];
                    }
                }
                if (_shouldFadeOut) {
                    _fadeoutView.backgroundColor = _fadeoutColor;
                }
            }];
        }
    }
    
    if ([_offCanvasDelegate respondsToSelector:@selector(endedGestureRecognitionOnOffCanvasNavigationController:)]) {
        [_offCanvasDelegate endedGestureRecognitionOnOffCanvasNavigationController:self];
    }
}

- (void)canceledPanRecognitionWithTranslation:(CGPoint)translation Velocity:(CGPoint)velocity
{
    if (!_sideViewOpen) {
        [UIView animateWithDuration:0.125 animations:^{
            for (UIView *view in self.view.subviews) {
                if (![view isEqual:_fadeoutView]) {
                    [view setTransform:CGAffineTransformIdentity];
                }
            }
        }];
    } else {
        [UIView animateWithDuration:0.125 animations:^{
            for (UIView *view in self.view.subviews) {
                if (![view isEqual:_fadeoutView]) {
                    [view setTransform:CGAffineTransformMakeTranslation(_offCanvasWidth, 0)];
                }
            }
        }];
    }
    if ([_offCanvasDelegate respondsToSelector:@selector(canceledGestureRecognitionOnOffCanvasNavigationController:)]) {
        [_offCanvasDelegate canceledGestureRecognitionOnOffCanvasNavigationController:self];
    }
}

- (void)changedPanRecognitionWithTranslation:(CGPoint)translation Velocity:(CGPoint)velocity
{
    if (!_sideViewOpen) {
        if (translation.x > 0){
            if (translation.x < _offCanvasWidth) {
                for (UIView *view in self.view.subviews) {
                    if (![view isEqual:_fadeoutView]) {
                        [view setTransform:CGAffineTransformMakeTranslation(translation.x, 0)];
                    }
                }
                if (_shouldFadeOut) {
                    _fadeoutView.backgroundColor = [_fadeoutColor colorWithAlphaComponent:(ABS(translation.x)/_offCanvasWidth)*CGColorGetAlpha(_fadeoutColor.CGColor)];
                }
            }
        }
    } else {
        if(translation.x < 0){
            if (_offCanvasWidth + translation.x > 0) {
                for (UIView *view in self.view.subviews) {
                    if (![view isEqual:_fadeoutView]) {
                        [view setTransform:CGAffineTransformMakeTranslation(_offCanvasWidth + translation.x, 0)];
                    }
                }
                if (_shouldFadeOut) {
                    _fadeoutView.backgroundColor = [_fadeoutColor colorWithAlphaComponent:(ABS(_offCanvasWidth + translation.x)/_offCanvasWidth)*CGColorGetAlpha(_fadeoutColor.CGColor)];
                }
            }
        }
    }
}

#pragma mark - Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ %@ %@",keyPath,object,change);
}

#pragma mark - Methods
- (void)toggleOffCanvasViewWithDuration:(NSTimeInterval)duration animationCurve:(UIViewAnimationCurve)animationCurve
{
    if (!_sideViewOpen) {
        CGAffineTransform righttransform = CGAffineTransformMakeTranslation(_offCanvasWidth, 0);
        
        if ([_offCanvasView superview] == nil) {
            [self.view addSubview:_offCanvasView];
            
            if (_shouldFadeOut) {
                [self setContra];
            }
        }
        
        if ([_offCanvasDelegate respondsToSelector:@selector(willSlideMenuInOffCanvasNavigationController:)]) {
            [_offCanvasDelegate willSlideMenuInOffCanvasNavigationController:self];
        }
        
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationCurve:animationCurve];
            [_fadeoutView setBackgroundColor:_fadeoutColor];
            for (UIView *view in self.view.subviews) {
                if (![view isEqual:_fadeoutView]) {
                    [view setTransform:righttransform];
                }
            }
        }];
        UIImage *icon = self.topViewController.navigationItem.leftBarButtonItem.image;
        [self.topViewController.navigationItem.leftBarButtonItem setImage:[icon imageWithRenderingMode:UIImageRenderingModeAutomatic]];
        [self viewControllers];
        _sideViewOpen = YES;
    } else {
        [UIView animateWithDuration:duration animations:^{
            [UIView setAnimationCurve:animationCurve];
            for (UIView *view in self.view.subviews) {
                if (![view isEqual:_fadeoutView]) {
                    [view setTransform:CGAffineTransformIdentity];
                }
                _fadeoutView.backgroundColor = [UIColor clearColor];
            }
        } completion:^(BOOL finished) {
            [_offCanvasView removeFromSuperview];
            [_fadeoutView removeFromSuperview];
        }];
        UIImage *icon = self.topViewController.navigationItem.leftBarButtonItem.image;
        [self.topViewController.navigationItem.leftBarButtonItem setImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _sideViewOpen = NO;
    }
}
- (void)toggleOffCanvasView
{
    
    [self toggleOffCanvasViewWithDuration:0.25 animationCurve:UIViewAnimationCurveEaseInOut];
}

- (void)setContra
{
    if (_fadeoutView == nil) {
        _fadeoutView = [[UIView alloc] init];
        _fadeoutView.translatesAutoresizingMaskIntoConstraints = NO;
        _fadeoutView.userInteractionEnabled = YES;
        _fadeoutView.backgroundColor = [UIColor clearColor];
    }
    if (_fadeoutColor == nil) {
        _fadeoutColor = [[UIColor blackColor] colorWithAlphaComponent:.33];
    }
    
    [self.view insertSubview:_fadeoutView atIndex:1];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_fadeoutView]-0-|" options:0 metrics:nil views:@{@"_fadeoutView":_fadeoutView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_fadeoutView]-0-|" options:0 metrics:nil views:@{@"_fadeoutView":_fadeoutView}]];
}

-(void)removeContra
{
    [_fadeoutView removeFromSuperview];
    _fadeoutView = nil;
}

#pragma mark - Delegate NavigationViewController
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isEqual:self.topViewController] ) {
        
        UIImage *image = nil;
        
        if ([_offCanvasDelegate respondsToSelector:@selector(offCanvasNavigationController:menuButtonImageForNextViewController:)]) {
            image = [_offCanvasDelegate offCanvasNavigationController:self menuButtonImageForNextViewController:viewController];
        } else {
            image = [UIImage imageNamed:@"CROffCanvasNavigation.bundle/MenuIcon.png"];
        }
        
        if (image != nil) {
            [[viewController navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(toggleOffCanvasView)]];
        }
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([_offCanvasDelegate respondsToSelector:@selector(offCanvasNavigationController:didShowController:animated:)]) {
        [_offCanvasDelegate offCanvasNavigationController:self didShowController:viewController animated:animated];
    }
}

#pragma mark - Delegate TableView
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self setViewControllers:@[[_offCanvasViewControllers objectAtIndex:indexPath.row]]];
    [self setViewControllers:@[[_offCanvasViewControllers objectAtIndex:indexPath.row]] animated:NO];
}

#pragma mark - DataSource TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = nil;
    switch (section) {
        case 0:
            string = @"ViewController"; //text abfragen
            break;
        default:
            break;
    }
    return string;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    switch (section) {
        case 0:
            numberOfRows = [_offCanvasViewControllers count];
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [[(UIViewController*)_offCanvasViewControllers[indexPath.row] class] description];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
