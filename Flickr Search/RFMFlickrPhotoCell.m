//
//  RFMFlickrPhotoCell.m
//  Flickr Search
//
//  Created by Frank McAuley on 4/10/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "RFMFlickrPhotoCell.h"
#import "FlickrPhoto.h"
#import <QuartzCore/QuartzCore.h>

@implementation RFMFlickrPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setPhoto:(FlickrPhoto *)photo{
    if (_photo != photo) {
        _photo = photo;
    }
    self.imageView.image = _photo.thumbnail;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
