//
//  MyQianBaoTableViewCell.m
//  CarGodNet
//
//  Created by apple on 2017/5/19.
//  Copyright © 2017年 YZNHD. All rights reserved.
//

#import "MyQianBaoTableViewCell.h"
static NSString *const reuseIdentifier = @"Cell";

@implementation MyQianBaoTableViewCell
{
    NSMutableArray *selectedArray;
    NSArray *dicAry;

}
- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray * array = @[@"1",@"",@"",@"",@"",@"",@"",@"",@""];
    selectedArray = [[NSMutableArray alloc] initWithArray:array];
    [self loadData];

   
}
- (void)loadData
{
   
            UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing =0;
            flowLayout.minimumLineSpacing = 10;
            flowLayout.itemSize = CGSizeMake((WIDTH - 40.0)/3, 76.0);
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            self.mainCollectionView.collectionViewLayout = flowLayout;
            self.mainCollectionView.scrollEnabled = NO;
            self.mainCollectionView.delegate = self;
            self.mainCollectionView.dataSource = self;
            self.mainCollectionView.backgroundColor = ML_Color(248, 248, 248, 1);
            UINib *nib = [UINib nibWithNibName:@"CardCollectionViewCell"
                                        bundle: [NSBundle mainBundle]];
            [self.mainCollectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
   
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return dicAry.count;
    return 9;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = dicAry[indexPath.row];
    NSLog(@"%@",dict);
    CardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    self.money = dict[@"money"];
    self.extra_desc = dict[@"extra_desc"];
    //"500m币
//    cell.zhekou.text = [NSString stringWithFormat:@"%@元",self.money];
//    cell.time.text = self.extra_desc;
    cell.zhekou.text = @"500m币";
    cell.time.text = @"￥500.00";
    NSString * status = selectedArray[indexPath.row];
    //waixing
    if ([status isEqualToString:@"1"]) {
        cell.imageView.image  = [UIImage imageNamed:@"yanse"];
        cell.zhekou.textColor = [UIColor whiteColor];
        cell.time.textColor   = [UIColor whiteColor];
    }else{
        cell.zhekou.textColor = ML_Color(250, 114, 152, 1);
        cell.time.textColor   = ML_Color(250, 114, 152, 1);
        cell.imageView.image  = [UIImage imageNamed:@"waixing"];
        
    }

    return cell;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * status = selectedArray[indexPath.row];
    if ([status isEqualToString:@"1"]) {
        
    }else{
        [selectedArray removeAllObjects];
        for (int i = 0; i < 10; i++) {
            if (i == indexPath.row)
            {
                [selectedArray addObject:@"1"];
            }
            else{
                [selectedArray addObject:@""];
            }
        }
        [self.mainCollectionView reloadData];
    }

    if (self.selectedBlock) {
        self.selectedBlock(indexPath.row);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
