//
//  RFMFlickrPhotoCell.h
//  Flickr Search
//
//  Created by Frank McAuley on 4/10/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrPhoto;

@interface RFMFlickrPhotoCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView*  imageView;
@property(nonatomic, strong) FlickrPhoto* photo;

@end
