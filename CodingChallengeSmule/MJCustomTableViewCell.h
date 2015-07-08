//
//  MJCustomTableViewCell.h
//  
//
//  Created by Mary Jenel Myers on 7/6/27 H.
//
//

#import <UIKit/UIKit.h>

@interface MJCustomTableViewCell : UITableViewCell
@property (nonatomic, readwrite) NSMutableArray *imageDataArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
