//
//  ViewController.m
//  banner3d
//
//  Created by idechao on 2021/9/27.
//

#import "ViewController.h"
#import "Banner3DView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Banner3DView *banner = [[Banner3DView alloc] initWithFrame:self.view.bounds];
//    banner.max
    [self.view addSubview:banner];
    
    [banner start];
}


@end
