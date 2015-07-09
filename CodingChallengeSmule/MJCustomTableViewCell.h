//
//  MJCustomTableViewCell.h
//  
//
//  Created by Mary Jenel Myers on 7/6/27 H.
//
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"
#import <Foundation/Foundation.h>


@interface MJCustomTableViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, readwrite) NSMutableArray *imageDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property UIImage *selectedImage;
@property NSString *username;
@end
