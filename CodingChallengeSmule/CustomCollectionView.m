//
//  CustomCollectionView.m
//  CodingChallengeSmule
//
//  Created by Mary Jenel Myers on 7/2/27 H.
//  Copyright (c) 27 Heisei Mary Jenel Myers. All rights reserved.
//

#import "CustomCollectionView.h"

@implementation CustomCollectionView
@end
@implementation CustomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.itemSize = CGSizeMake(44, 44);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[CustomCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:DogCollectionViewCellIdentifier];
     [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CatCollectionViewCellIdentifier];
     [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:SnowCollectionViewCellIdentifier];
     [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:RabbitCollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];

    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;

    [self.collectionView reloadData];
}


@end
