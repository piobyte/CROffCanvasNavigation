//
//  ViewControllerThree.m
//  CROffCanvasNavigation
//
//  Created by Steve Maahs on 04.09.14.
//  Copyright (c) 2014 Steve Maahs. All rights reserved.
//

#import "ViewControllerThree.h"

@interface ViewControllerThree ()

@end

@implementation ViewControllerThree

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"VC Three"];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self performSelector:@selector(showAlert) withObject:nil afterDelay:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disruption" message:@"Oh You shouldn't be disrupted, but i did." delegate:nil cancelButtonTitle:@"Ok :(" otherButtonTitles:nil];
    [alert show];
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
