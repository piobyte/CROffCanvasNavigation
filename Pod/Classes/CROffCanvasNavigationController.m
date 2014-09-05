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

@end

@implementation CROffCanvasNavigationController

@synthesize viewControllers = _viewControllers;

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
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    CGRect frameRect = (CGRect){{-270,0},{270,self.view.frame.size.height}};
    
    int style = 0;
    if (style == 0) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:frameRect style:UITableViewStylePlain];
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
        tableView.delegate = self;
        
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
    
    if([_offCanvasDelegate respondsToSelector:@selector(tableViewDataSourceForOffCanvasNavigationController:)]) {
        [(UITableView*)_offCanvasView setDataSource:[_offCanvasDelegate tableViewDataSourceForOffCanvasNavigationController:self]];
    }
    if([_offCanvasDelegate respondsToSelector:@selector(tableViewDelegateForOffCanvasNavigationController:)]) {
        [(UITableView*)_offCanvasView setDelegate:[_offCanvasDelegate tableViewDelegateForOffCanvasNavigationController:self]];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ %@ %@",keyPath,object,change);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (void)toggleOffCanvasView
{
    
    if (_sideViewOpen) {
        [UIView animateWithDuration:0.25 animations:^{
            for (UIView *view in self.view.subviews) {
                [view setTransform:CGAffineTransformIdentity];
            }
//            [[self navigationBar] setTransform:CGAffineTransformIdentity];
//            [[self toolbar] setTransform:CGAffineTransformIdentity];
//            [_offCanvasView setTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            [[self.view.subviews lastObject] removeFromSuperview];
        }];
        
        _sideViewOpen = NO;
    } else {
        CGAffineTransform righttransform = CGAffineTransformMakeTranslation(270, 0);
        NSLog(@"helpme %@",[self viewControllers]);
        [self.view addSubview:_offCanvasView];
        [UIView animateWithDuration:0.25 animations:^{
//            [[self navigationBar] setTransform:righttransform];
//            [[self toolbar] setTransform:righttransform];
//            [_offCanvasView setTransform:righttransform];
            for (UIView *view in self.view.subviews) {
                [view setTransform:righttransform];;
            }
        }];
        [self viewControllers];
        //        [self navigation]
        
        //[[self view] setTransform:righttransform];
        NSLog(@"Subviews: %@",self.view.subviews);
        
        _sideViewOpen = YES;
    }
}

#pragma mark - Delegate NavigationViewController
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    for (UIViewController *controller in _viewControllers) {
        if ([viewController isEqual:self.topViewController] ) {
            //[[viewController navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleOffCanvasView)]];
            
            [[viewController navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CROffCanvasNavigation.bundle/MenuIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleOffCanvasView)]];
        }
//    }
}

#pragma mark - Delegate TableView

#pragma mark - DataSource TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = nil;
    switch (section) {
        case 0:
            string = @"blabla";
            break;
            
        case 1:
            string = @" ";
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
        
        case 1:
            numberOfRows = 0;
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
