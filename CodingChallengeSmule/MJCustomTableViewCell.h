//
//  MJCustomTableViewCell.h
//  
//
//  Created by Mary Jenel Myers on 7/6/27 H.
//
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"

@interface MJCustomTableViewCell : UITableViewCell <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, readwrite) NSMutableArray *imageDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
