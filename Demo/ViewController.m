//
//  ViewController.m
//  Demo
//
//  Created by jianghat on 16/10/11.
//  Copyright © 2016年 jianghat. All rights reserved.
//

#import "ViewController.h"
// Views
#import "KKPlaceholderTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  KKPlaceholderTextView *textView = [[KKPlaceholderTextView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - 300)/2.0, 50, 300, 300)];
  textView.borderColor = [UIColor redColor];
  textView.borderWidth = 1.0 / [UIScreen mainScreen].scale;
  textView.placeholder = @"这是一个套路深的时代，不再是互联网时代！";
  [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
