//
//  RFMFlickrPhotoHeaderView.m
//  Flickr Search
//
//  Created by Frank McAuley on 4/10/13.
//  Copyright (c) 2013 Frank McAuley. All rights reserved.
//

#import "RFMFlickrPhotoHeaderView.h"

@interface RFMFlickrPhotoHeaderView ()
@property(weak) IBOutlet UIImageView* backgroundImageView;
@property(weak) IBOutlet UILabel *searchLabel;

@end

@implementation RFMFlickrPhotoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setSearchText:(NSString *)text {
    self.searchLabel.text = text;
    
    UIImage *sharedButtonImage = [[UIImage imageNamed:@"header_bg.png"]
                                  resizableImageWithCapInsets:UIEdgeInsetsMake(68, 68, 68, 68)];
    
    self.backgroundImageView.image = sharedButtonImage;
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
