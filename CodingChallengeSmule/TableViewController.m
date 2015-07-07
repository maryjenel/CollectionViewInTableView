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
#import "CustomCollectionView.h"
#import "CustomCollectionViewCell.h"
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

//coreData
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //calls custom methods
    [self grabbingSnowImages];
    [self grabbingDogImages];
    [self grabbingCatImages];
    [self grabbingRabbitImages];

    //unarchives NSUserDefaults data that was archived due to custom objects
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"dogImageArray"];
    if (dataRepresentingSavedArray != nil)
    {
       NSMutableArray* oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
        {
            self.dogImageArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
    }

    NSData *rabbitDataRepresentingSavedArray = [currentDefaults objectForKey:@"rabbitImageArray"];
    if (rabbitDataRepresentingSavedArray != nil)
    {
        NSMutableArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
        {
            self.rabbitImageArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
        }
    }




}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    CustomCollectionView *cellImageCollection = (CustomCollectionView *)[cell viewWithTag:0];
    cellImageCollection.restorationIdentifier=[NSString stringWithFormat:@"%li", (long)indexPath.row, nil];

//    ImageHelper *imageHelper = [self.dogImageArray objectAtIndex:indexPath.row];
//    NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
//    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
   // cell.customImageView.image = image;
    return cell;
}



-(void)grabbingSnowImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/snow/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.snowImageArray = [[NSMutableArray alloc]init];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/snow/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
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

             [self.snowImageArray addObject:imageHelper]; //adds the objects to the array
             [self.tableView reloadData]; //always reload the tableview when doing an async call.
             NSLog(@"%@",self.snowImageArray);

             //convert the array of custom objects into NsData
             NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.snowImageArray.count];
             for (ImageHelper *imageHelper in self.snowImageArray) {
                 NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:imageHelper];
                 [archiveArray addObject:personEncodedObject];
             }

             //saves the Nsdata locally
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:archiveArray forKey:@"snowImageArray"];
             [defaults synchronize];

         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
}
-(void)grabbingDogImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/dog/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.dogImageArray = [[NSMutableArray alloc]init];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/dog/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
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


             [self.dogImageArray addObject:imageHelper]; //adds the objects to the array
             [self.tableView reloadData]; //always reload the tableview when doing an async call.
             NSLog(@"%@",self.dogImageArray);

             //convert the array of custom objects into NsData
             NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.dogImageArray.count];
             for (ImageHelper *imageHelper in self.dogImageArray) {
                 NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:imageHelper];
                 [archiveArray addObject:personEncodedObject];
             }

             //saves the array locally
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:archiveArray forKey:@"dogImageArray"];


         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
}

-(void)grabbingCatImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/cat/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.catImageArray = [[NSMutableArray alloc]init];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/cat/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
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
             NSLog(@"%@",self.catImageArray);

             //convert the array of custom objects into NsData
             NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.catImageArray.count];
             for (ImageHelper *imageHelper in self.catImageArray) {
                 NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:imageHelper];
                 [archiveArray addObject:personEncodedObject];
             }
             //saves the array locally

             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:archiveArray forKey:@"dogImageArray"];

         }

     }

         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error); //logs the error
     }];
}

-(void)grabbingRabbitImages
{
    //uses AF Networking to grab snow images
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.instagram.com/v1/tags/rabbit/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d"]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.rabbitImageArray = [[NSMutableArray alloc]init];
    //uses GET method
    [manager GET:@"https://api.instagram.com/v1/tags/rabbit/media/recent?client_id=60a5cb339aa14bbdbb74632bbd8b926d" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",responseObject);
         self.rabbitDataArray = responseObject[@"data"];
         //grabbing the first 10 images of the search
         for (int i = 0; i < 10; i++)
         {

             NSDictionary *images = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"images"];
             NSString *filter = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"filter"];
             //customized class methods
             ImageHelper *imageHelper = [[ImageHelper alloc]initWithStandardImage:images filter:filter];

             //grabs the username per photo
             NSDictionary *captionDict = [[self.rabbitDataArray objectAtIndex:i] objectForKey:@"caption"];
             NSDictionary *fromDict = [captionDict objectForKey:@"from"];
             imageHelper.username = [fromDict objectForKey:@"username"]; //username
             imageHelper.searchTerm = searchTypeRabbit;



             [self.rabbitImageArray addObject:imageHelper]; //adds the objects to the array
             [self.tableView reloadData]; //always reload the tableview when doing an async call.
             NSLog(@"%@",self.rabbitImageArray);

             //convert the array of custom objects into NsData
             NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:self.rabbitImageArray.count];
             for (ImageHelper *imageHelper in self.rabbitImageArray) {
                 NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:imageHelper];
                 [archiveArray addObject:personEncodedObject];
             }

             //saves the array locally
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:archiveArray forKey:@"rabbitImageArray"];

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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *dogCell = [collectionView dequeueReusableCellWithReuseIdentifier:DogCollectionViewCellIdentifier forIndexPath:indexPath];
    CustomCollectionViewCell *catCell = [collectionView dequeueReusableCellWithReuseIdentifier:CatCollectionViewCellIdentifier forIndexPath:indexPath];
    CustomCollectionViewCell *rabbitCell = [collectionView dequeueReusableCellWithReuseIdentifier:RabbitCollectionViewCellIdentifier forIndexPath:indexPath];
    CustomCollectionViewCell *snowCell = [collectionView dequeueReusableCellWithReuseIdentifier:SnowCollectionViewCellIdentifier forIndexPath:indexPath];


    if (dogCell) {
        ImageHelper *imageHelper = [self.dogImageArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dogCell.dogImageView.image = image;
        return dogCell;
    }
    else if (catCell)
    {
        return catCell;
    }
    else if (snowCell)
    {
        return snowCell;
    }
        ImageHelper *imageHelper = [self.rabbitImageArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        rabbitCell.rabbitImageView.image = image;

        return rabbitCell;


}


@end
