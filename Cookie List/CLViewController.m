//
//  CLViewController.m
//  CookieList
//
//  Created by John Clem on 8/10/13.
//  Copyright (c) 2013 Code Fellows. All rights reserved.
//

#import "CLViewController.h"
#import "CLCookie.h"

@interface CLViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSOperationQueue *downloadQueue;
}

@property (nonatomic, copy) NSMutableArray *cookies;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    downloadQueue = [NSOperationQueue new];
    
	__weak CLViewController *weakSelf = self;
    
    [CLCookie remoteAllAsync:^(NSArray *allCookies, NSError *error){
        
        if (error) {
            NSLog(@"%@", error);
        } else {
            weakSelf.cookies = [NSMutableArray arrayWithArray:allCookies];
            [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [weakSelf loadImagesForOnscreenRows];
            NSLog(@"%@", [(CLCookie*)allCookies[0] photoThumb]);
        }
        
    }];

    NSLog( @"got %d cookies", [_cookies count] );
}


#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cookies count];
}


-(UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"CookieCell" forIndexPath:indexPath];
    
    CLCookie *cookie = _cookies
    [indexPath.row];
    
    cell.textLabel.text = cookie.name;
    cell.detailTextLabel.text = cookie.baker;
    
    if( cookie.thumbnailImage ) {
        cell.imageView.image = cookie.thumbnailImage;
    }
    
    return cell;
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([_cookies count] > 0)
    {
        for (int i=0; i<_cookies.count; i++) {
            
            CLCookie *cookie = _cookies[i];
            if (!cookie.thumbnailImage) {
                
                [downloadQueue addOperationWithBlock:^{
                    NSURL *imageUrl = [NSURL URLWithString:cookie.photoThumb];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                    cookie.thumbnailImage = [UIImage imageWithData:imageData];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]
                                         withRowAnimation:UITableViewRowAnimationFade];
                    }];
                }];
                
            }
        }
        
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
