//
//  MJCustomTableViewCell.m
//  
//
//  Created by Mary Jenel Myers on 7/6/27 H.
//
//

#import "MJCustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "TableViewController.h"
@implementation MJCustomTableViewCell

- (void)awakeFromNib {
    _imageDataArray = [NSMutableArray new];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];
    ImageHelper *imageHelper = [self.imageDataArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;

    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   // NSArray *array = [self.imageDataArray objectAtIndex:section];
    return self.imageDataArray.count;
}
@end
