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

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIView* bgView = [[UIView alloc]initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.borderColor = [[UIColor whiteColor]CGColor];
        bgView.layer.borderWidth = 4;
        self.selectedBackgroundView = bgView;
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
