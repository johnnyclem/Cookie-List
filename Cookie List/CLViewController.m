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
    IBOutlet UITableView *tableView;
    
    NSArray *cookies;
    
    NSOperationQueue *downloadQueue;
}

@end


@implementation CLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    downloadQueue = [NSOperationQueue new];
    
    cookies = [CLCookie remoteAll:nil];
    NSLog( @"got %d cookies", [cookies count] );
}


#pragma mark - Table view data source

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cookies count];
}


-(UITableViewCell*) tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"CookieCell" forIndexPath:indexPath];
    
    CLCookie *cookie = cookies[indexPath.row];
    
    cell.textLabel.text = cookie.name;
    cell.detailTextLabel.text = cookie.baker;
    
    if( cookie.thumbnailImage == nil ) {
        [downloadQueue addOperationWithBlock:^{
            [cookie downloadThumbnail];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [tv reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            }];
        }];
    }
    
    cell.imageView.image = cookie.thumbnailImage;
    
    return cell;
}

@end
