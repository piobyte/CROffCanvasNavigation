//
//  ViewControllerTwo.m
//  CROffCanvasNavigation
//
//  Created by Steve Maahs on 04.09.14.
//  Copyright (c) 2014 Steve Maahs. All rights reserved.
//

#import "ViewControllerTwo.h"

#import "ViewControllerOne.h"

@interface ViewControllerTwo ()

@end

@implementation ViewControllerTwo

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
    [self.navigationItem setTitle:@"VC Two"];
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton * buton = [[UIButton alloc] initWithFrame:(CGRect){{40,40},{45,45}}];
    buton.backgroundColor = [UIColor greenColor];
    [buton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonAction:(id)sender
{
    ViewControllerOne  *vc = [[ViewControllerOne alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
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
