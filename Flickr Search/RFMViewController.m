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

#define kCellName @"FlickrCell"

@interface RFMViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic, strong) NSMutableDictionary* searchResults;
@property(nonatomic, strong) NSMutableArray* searches;
@property(nonatomic, strong) Flickr* flickr;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

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

//-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView
//         viewForSupplementaryElementOfKind:(NSString *)kind
//                               atIndexPath:(NSIndexPath *)indexPath
//{
//    return [[UICollectionReusableView alloc]init];
//}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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

@end
