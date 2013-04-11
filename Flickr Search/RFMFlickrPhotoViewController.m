//
//  RFMFlickrPhotoViewController.m
//  Flickr Search
//
//  Created by Frank McAuley on 4/10/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "RFMFlickrPhotoViewController.h"
#import "Flickr.h"
#import "FlickrPhoto.h"

@interface RFMFlickrPhotoViewController ()

@property(weak) IBOutlet UIImageView *imageView;
-(IBAction)done:(UIBarButtonItem*)sender;

@end

@implementation RFMFlickrPhotoViewController

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
}

- (void)loadFlickrImage {
    if (self.flickrPhoto.largeImage) {
        self.imageView.image = self.flickrPhoto.largeImage;
    }else{
        self.imageView.image = self.flickrPhoto.thumbnail;
        [Flickr loadImageForPhoto:self.flickrPhoto thumbnail:NO completionBlock:^(UIImage *photoImage, NSError *error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.imageView.image = self.flickrPhoto.largeImage;
                });
            }
        }];
    }
  }

-(void)viewDidAppear:(BOOL)animated{
    [self loadFlickrImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(UIBarButtonItem*)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
@end
