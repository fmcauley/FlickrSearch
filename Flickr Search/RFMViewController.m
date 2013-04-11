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
#import "RFMFlickrPhotoCell.h"
#import "RFMFlickrPhotoHeaderView.h"
#import "RFMFlickrPhotoViewController.h"
#import <MessageUI/MessageUI.h>

#define kCellName @"FlickrCell"
#define kCellHeader @"FlickrPhotoHeaderView"

@interface RFMViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSMutableDictionary* searchResults;
@property(nonatomic, strong) NSMutableArray* searches;
@property(nonatomic, strong) Flickr* flickr;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic) BOOL sharing;

@property(nonatomic, strong) NSMutableArray* selectedPhotos;

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
    self.selectedPhotos = [@[]mutableCopy];
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
    if (!self.sharing) {
        self.sharing = YES;
        [sender setStyle:UIBarButtonItemStyleDone];
        [sender setTitle:@"Done"];
        [self.collectionView setAllowsMultipleSelection:YES];
    } else {
        self.sharing = NO;
        [sender setStyle:UIBarButtonItemStyleBordered];
        [sender setTitle:@"Share"];
        [self.collectionView setAllowsMultipleSelection:NO];
        
        if ([self.selectedPhotos count] > 0) {
            [self showMailComposerAndSend];
        }
        
        for(NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems){
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }
    [self.selectedPhotos removeAllObjects];
    }
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
                [self.collectionView reloadData];
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

#pragma mark - UICollectionView Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *searchTerm = self.searches[section];
    return [self.searchResults[searchTerm]count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.searches count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFMFlickrPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellName forIndexPath:indexPath];
    NSString* searchTerm = self.searches[indexPath.section];
    cell.photo = self.searchResults[searchTerm][indexPath.row];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView
         viewForSupplementaryElementOfKind:(NSString *)kind
                               atIndexPath:(NSIndexPath *)indexPath
{
    RFMFlickrPhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellHeader forIndexPath:indexPath];
    NSString* searchTerm = self.searches[indexPath.section];
    [headerView setSearchText:searchTerm];
    return headerView;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.sharing) {
        NSString* searchTerm = self.searches[indexPath.section]; //section vs row
        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
        [self performSegueWithIdentifier:@"ShowFlickrPhoto" sender:photo];
        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    } else {
        NSString* searchTerm = self.searches[indexPath.section];
        FlickrPhoto* photo = self.searchResults[searchTerm][indexPath.row];
        [self.selectedPhotos addObject:photo];
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.sharing) {
        NSString* searchTerm = self.searches[indexPath.section];
        FlickrPhoto* photo = self.searchResults[searchTerm][indexPath.row];
        [self.selectedPhotos removeObject:photo];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView
                 layout:(UICollectionViewLayout *)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *searchTerm = self.searches[indexPath.section];
    FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    
    CGSize retval = photo.thumbnail.size.width > 0 ?
    photo.thumbnail.size : CGSizeMake(100, 100);
    
    retval.height += 35;
    retval.width += 35;
    return retval;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

#pragma mark - MFMailComposeViewControllerDelegate
-(void)showMailComposerAndSend{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc]init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Check out these Flickr Photos"];
        
        NSMutableString* emailBody = [NSMutableString string];
        for(FlickrPhoto* flickrPhoto in self.selectedPhotos){
            NSString* url = [Flickr flickrPhotoURLForFlickrPhoto:flickrPhoto size:@"m"];
            [emailBody appendFormat:@"<div><img src='%@'></div><br>", url];
        }
        
        [mailer setMessageBody:emailBody isHTML:YES];
        
        [self presentViewController:mailer animated:YES completion:^{}];
    } else {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Mail Failure" message:@"Your device doesn't support in-app email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - perpareForSegue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowFlickrPhoto"]) {
        RFMFlickrPhotoViewController *flickrPhotoViewController =
        segue.destinationViewController;
        flickrPhotoViewController.flickrPhoto = sender;
    }
}

@end
