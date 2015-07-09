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
    _username = [NSString new];
    _selectedImage = [UIImage new];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //sets per array of the self.imageDataArray
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionViewCellIdentifier" forIndexPath:indexPath];
    ImageHelper *imageHelper = [self.imageDataArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    self.selectedImage = [UIImage imageWithData:data];
    self.username = imageHelper.username;
    cell.imageView.image = self.selectedImage;

    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDataArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *vc = [[DetailViewController alloc]init];

    ImageHelper *imageHelper = [self.imageDataArray objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:imageHelper.standardPhotoURL];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url];
    vc.selectedImage = [UIImage imageWithData:data];
    vc.username = imageHelper.username;


}

@end
