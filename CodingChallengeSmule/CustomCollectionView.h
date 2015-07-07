//
//  CustomCollectionView.h
//  CodingChallengeSmule
//
//  Created by Mary Jenel Myers on 7/2/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;


@end

static NSString *DogCollectionViewCellIdentifier = @"DogCollectionViewCellIdentifier";
static NSString *RabbitCollectionViewCellIdentifier = @"RabbitCollectionViewCellIdentifier";
static NSString *CatCollectionViewCellIdentifier = @"CatCollectionViewCellIdentifier";
static NSString *SnowCollectionViewCellIdentifier = @"SnowCollectionViewCellIdentifier";

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, strong) CustomCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end