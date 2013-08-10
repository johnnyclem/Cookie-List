//
//  CLCookie.m
//  CookieList
//
//  Created by John Clem on 8/10/13.
//  Copyright (c) 2013 Code Fellows. All rights reserved.
//

#import "CLCookie.h"

@implementation CLCookie

-(void) downloadThumbnail
{
    if( self.thumbnailImage == nil ) {
        NSURL *thumbURL = [NSURL URLWithString:self.photoThumb];
        NSData *thumbData = [NSData dataWithContentsOfURL:thumbURL];
        self.thumbnailImage = [UIImage imageWithData:thumbData];
    }
}

@end
