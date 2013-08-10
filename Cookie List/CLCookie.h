//
//  CLCookie.h
//  CookieList
//
//  Created by John Clem on 8/10/13.
//  Copyright (c) 2013 Code Fellows. All rights reserved.
//

#import "NSRRemoteObject.h"

@interface CLCookie : NSRRemoteObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *baker;
@property (nonatomic, copy) NSString *photoThumb;
@property (nonatomic, copy) NSString *photoLarge;

@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) UIImage *largeImage;

-(void) downloadThumbnail;

@end
