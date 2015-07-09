  //
//  ViewController.m
//  CodingChallengeSmule
//
//  Created by Mary Jenel Myers on 6/29/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//
#import "TableViewController.h"
#import "AFNetworking.h"
#import "ImageHelper.h"
#import "AppDelegate.h"
#import "CustomCollectionViewCell.h"
#import "MJCustomTableViewCell.h"
typedef enum
{
    searchTypeDog = 1,
    searchTypeCat,
    searchTypeRabbit,
    searchTypeSnow

}SearchStatus;

@interface TableViewController ()

//iboutlets

//arrays
@property NSMutableArray *snowImageArray;
@property NSArray *snowDataArray;
@property NSArray *dogDataArray;
@property NSMutableArray *dogImageArray;
@property NSArray *catDataArray;
@property NSMutableArray *catImageArray;
@property NSArray *rabbitDataArray;
@property NSMutableArray *rabbitImageArray;
@property (nonatomic, readwrite)NSMutableArray *allImageArray;
@property AFHTTPRequestOperationManager *manager;


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialize NSmutablearrays
    self.allImageArray = [NSMutableArray new];
    self.manager = [AFHTTPRequestOperationManager manager];
    //calls custom methods
    [self grabbingSnowImages];
    [self grabbingDogImages];
    [self grabbingCatImages];
    [self grabbingRabbitImages];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //create a gesture recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allImageArray.count;
}


- (IBAction)longPressGestureRecognized:(id)sender {

    //grabs location of longpress gesture
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;

    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil; // Initial index path, where touched begins.

    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;

                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

                // Take a snapshot of row
                snapshot = [self customSnapshotFromView:cell];

                // Add the snapshot as subview, centered at cell's center
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{

                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fades out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    //hides cell
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }

            //when touched off set y coordinate
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;

            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {

                // update data source.
                [self.allImageArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];

                // move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];

                // update source syncs w UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }

            //when done touched.
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{

                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;

                // Undo fade out.
                cell.alpha = 1.0;

            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
    }

}

-(void)grabbingSnowImages
{
    self.snowImageArray = [NSMutableArray new];
    self.snowDataArray = [NSArray new];
    //uses AF Networking to grab  images
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/snow/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.snowDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search

         for (int i = 0; i < 10; i++)
         {
             ImageHelper *imageHelper = [[ImageHelper alloc]init];

             NSDictionary *images = [[self.snowDataArray objectAtIndex:i] objectForKey:@"images"];

             //customized class methods
             imageHelper.standardPhotoURL = images[@"standard_resolution"][@"url"];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.snowDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeSnow;



             [self.snowImageArray addObject:imageHelper]; //adds the objects to the array
         }
          [self.tableView reloadData]; //always reload the tableview when doing an async call.
         ImageHelper *test = self.snowImageArray[0];
         NSLog(@"%@", test.username);
         if (self.snowImageArray) {
             [self.allImageArray addObject:self.snowImageArray];//adds the objects to the array

         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
    
}
-(void)grabbingDogImages
{
    self.dogImageArray = [NSMutableArray new];
    self.dogDataArray = [NSArray new];
    //uses AF Networking to grab  images

   self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [self.manager GET:@"https://api.instagram.com/v1/tags/dog/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.dogDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search

         for (int i = 0; i < 10; i++)
         {
             ImageHelper *imageHelper = [[ImageHelper alloc]init];

             NSDictionary *images = [[self.dogDataArray objectAtIndex:i] objectForKey:@"images"];

             //customized class methods
             imageHelper.standardPhotoURL = images[@"standard_resolution"][@"url"];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.dogDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeDog;



             [self.dogImageArray addObject:imageHelper]; //adds the objects to the array
         }
         [self.tableView reloadData]; //always reload the tableview when doing an async call.
         ImageHelper *test = self.dogImageArray[0];
         NSLog(@"%@", test.username);
         if (self.dogImageArray)
         {
             [self.allImageArray addObject:self.dogImageArray];//adds the objects to the array

         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];

    
}

-(void)grabbingCatImages
{
    self.catImageArray = [NSMutableArray new];
    self.catDataArray = [NSArray new];
    //uses AF Networking to grab  images

    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [self.manager GET:@"https://api.instagram.com/v1/tags/cats/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.catDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search

         for (int i = 0; i < 10; i++)
         {
             ImageHelper *imageHelper = [[ImageHelper alloc]init];

             NSDictionary *images = [[self.catDataArray objectAtIndex:i] objectForKey:@"images"];

             //customized class methods
             imageHelper.standardPhotoURL = images[@"standard_resolution"][@"url"];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.catDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeCat;



             [self.catImageArray addObject:imageHelper]; //adds the objects to the array
         }
         [self.tableView reloadData]; //always reload the tableview when doing an async call.
         ImageHelper *test = self.catImageArray[0];
         NSLog(@"%@", test.username);
         if (self.catImageArray)
         {
             [self.allImageArray addObject:self.catImageArray];//adds the objects to the array

         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];


}

-(void)grabbingRabbitImages
{
    self.rabbitImageArray = [NSMutableArray new];
    self.rabbitDataArray = [NSArray new];
    //uses AF Networking to grab  images
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/rabbit/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.rabbitDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search

         for (int i = 0; i < 10; i++)
         {
             ImageHelper *imageHelper = [[ImageHelper alloc]init];
             NSDictionary *images = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"images"];
             //customized class methods
             imageHelper.standardPhotoURL = images[@"standard_resolution"][@"url"];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeRabbit;
            [self.rabbitImageArray addObject:imageHelper]; //adds the objects to the array
         }
         [self.tableView reloadData]; //always reload the tableview when doing an async call.
         ImageHelper *test = self.rabbitImageArray[0];
         NSLog(@"%@", test.username);
         if (self.rabbitImageArray)
         {
             [self.allImageArray addObject:self.rabbitImageArray];//adds the objects to the array
         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}


-(MJCustomTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{       MJCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    if (self.allImageArray.count == 4)
    {
        //pass one of the arrays inside the array of arrays to the custom tableviewcell
        cell.imageDataArray = [self.allImageArray objectAtIndex:indexPath.section];
        [cell.collectionView reloadData];
    }

    NSLog(@"%@", self.allImageArray);

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UIView *)customSnapshotFromView:(UIView *)inputView {
    //returns a snap shot of given view to appear floating
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
@end
