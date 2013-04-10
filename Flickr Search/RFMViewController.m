//
//  RFMViewController.m
//  Flickr Search
//
//  Created by Frank McAuley on 4/9/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "RFMViewController.h"

@interface RFMViewController ()
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIToolbar *shareButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender;

@end

@implementation RFMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender {
}
@end
