//
//  RFMViewController.m
//  Flickr Search
//
//  Created by Frank McAuley on 4/9/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "RFMViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface RFMViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSMutableDictionary* searchResults;
@property(nonatomic, strong) NSMutableArray* searches;
@property(nonatomic, strong) Flickr* flickr;

- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender;

@end

@implementation RFMViewController

- (void)setBackgroundImages
{
    //syle the view
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    UIImage *navBarImage = [[UIImage imageNamed:@"navbar.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(27, 27, 27, 27)];
    [self.toolBar setBackgroundImage:navBarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIImage *shareButtonImage = [[UIImage imageNamed:@"button.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [self.shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *textFieldImage = [[UIImage imageNamed:@"search_field"]
                               resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.textField setBackground:textFieldImage];
}

- (void)dataStructureSetup
{
    self.searches = [@[] mutableCopy];
    self.searchResults = [@{} mutableCopy];
    self.flickr = [[Flickr alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setBackgroundImages];
    
    [self dataStructureSetup];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareButtonTapped:(UIBarButtonItem *)sender {
}

- (void)searchFlicketWithText:(UITextField *)textField {
    [self.flickr searchFlickrForTerm:textField.text completionBlock:^(NSString *searchTerm, NSArray *results, NSError *error) {
        if (results && [results count] > 0) {
            if (![self.searches containsObject:searchTerm]) {
                NSLog(@"Found %d photos matching %@", [results count], searchTerm);
                [self.searches insertObject:searchTerm atIndex:0];
                self.searchResults[searchTerm] = results;
            }
            
            //get the images
            dispatch_async(dispatch_get_main_queue(), ^{
                //place holder for the logic that will fetch the images
            });
        } else {
            NSLog(@"Error searching Flickr: %@", error.localizedDescription);
        }
    }];
}


#pragma mark - UITextFieldDelegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self searchFlicketWithText:textField];
    
    [textField resignFirstResponder];
    return YES;
}
@end
