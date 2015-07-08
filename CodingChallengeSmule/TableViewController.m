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

@interface TableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

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



@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //initialize NSmutablearrays
    self.allImageArray = [NSMutableArray new];
    self.snowImageArray = [NSMutableArray new];
    self.dogImageArray = [NSMutableArray new];
    self.catImageArray = [NSMutableArray new];
    self.rabbitImageArray = [NSMutableArray new];
    //initialize NsArrays
    self.catDataArray = [NSArray new];
    self.rabbitDataArray = [NSArray new];
    self.snowDataArray = [NSArray new];
    self.dogDataArray = [NSArray new];


    //calls custom methods
    [self grabbingSnowImages];
    [self grabbingDogImages];
    [self grabbingCatImages];
  //  [self grabbingRabbitImages];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;





}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allImageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   MJCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    
    cell.imageDataArray = [self.allImageArray objectAtIndex:indexPath.section];
    [cell.collectionView reloadData];
    return cell;
}


-(void)grabbingSnowImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/snow/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.snowDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search
         for (int i = 0; i < 10; i++)
         {

             NSDictionary *images = [[self.snowDataArray objectAtIndex:i] objectForKey:@"images"];
             NSString *filter = [[self.snowDataArray objectAtIndex:i] objectForKey:@"filter"];
             //customized class methods
             ImageHelper *imageHelper = [[ImageHelper alloc]initWithStandardImage:images filter:filter];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.snowDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeSnow;

             [self.snowImageArray addObject:imageHelper];


         }
         [self.tableView reloadData]; //always reload the tableview when doing an async call.

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
    if (self.snowImageArray) {
        [self.allImageArray addObject:self.snowImageArray];//adds the objects to the array

    }

}
-(void)grabbingDogImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/dog/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.dogDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search
         for (int i = 0; i < 10; i++)
         {
             NSDictionary *images = [[self.dogDataArray objectAtIndex:i] objectForKey:@"images"];
             NSString *filter = [[self.dogDataArray objectAtIndex:i] objectForKey:@"filter"];
             //customized class methods
             ImageHelper *imageHelper = [[ImageHelper alloc]initWithStandardImage:images filter:filter];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.dogDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeDog; //setting search term


             [self.dogImageArray addObject:imageHelper];//adds the objects to the array
             [self.tableView reloadData]; //always reload the tableview when doing an async call.


        }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
    if (self.dogImageArray) {
        [self.allImageArray addObject:self.dogImageArray];//adds the objects to the array

    }
}

-(void)grabbingCatImages
{
    //uses AF Networking to grab  images
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/cats/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         self.catDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search
         for (int i = 0; i < 10; i++)
         {

             NSDictionary *images = [[self.catDataArray objectAtIndex:i] objectForKey:@"images"];
             NSString *filter = [[self.catDataArray objectAtIndex:i] objectForKey:@"filter"];
             //customized class methods
             ImageHelper *imageHelper = [[ImageHelper alloc]initWithStandardImage:images filter:filter];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.catDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeCat;



             [self.catImageArray addObject:imageHelper]; //adds the objects to the array
             [self.tableView reloadData]; //always reload the tableview when doing an async call.



         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
    if (self.catImageArray) {
        [self.allImageArray addObject:self.catImageArray];//adds the objects to the array

    }
}

//-(void)grabbingRabbitImages
//{
//    //uses AF Networking to grab images
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    //uses GET method
//    [manager GET:@"https://api.instagram.com/v1/tags/bunny/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"%@",responseObject);
//         self.rabbitDataArray = responseObject[@"data"];
//         //grabbing the first 10 images of the search
//         for (int i = 0; i < 10; i++)
//         {
//
//             NSDictionary *images = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"images"];
//             NSString *filter = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"filter"];
//             //customized class methods
//             ImageHelper *imageHelper = [[ImageHelper alloc]initWithStandardImage:images filter:filter];
//
//             //grabs the username per photo
//             NSDictionary *captionDict = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"caption"];
//             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
//             imageHelper.username = [fromDict objectForKey:@"username"]; //username
//             imageHelper.searchTerm = searchTypeRabbit;
//
//
//
//             [self.rabbitImageArray addObject:imageHelper]; //adds the objects to the array
//             [self.tableView reloadData]; //always reload the tableview when doing an async call.
//         }
//
//     }
//
//         failure:^(AFHTTPRequestOperation *operation, NSError *error)
//     {
//         NSLog(@"%@", error); //logs the error
//     }];
//    if (self.rabbitImageArray) {
//        [self.allImageArray addObject:self.rabbitImageArray];//adds the objects to the array
//
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = [self.allImageArray objectAtIndex:section];
    return array.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];


        NSMutableArray *allImageArray = [self.allImageArray objectAtIndex:indexPath.row];
        NSLog(@"%@",allImageArray);
        for (NSMutableArray *searchDataImage in allImageArray) {
        for (ImageHelper *imageHelper in searchDataImage) {
            NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image = image;
        }
    }


        return cell;


}


@end
