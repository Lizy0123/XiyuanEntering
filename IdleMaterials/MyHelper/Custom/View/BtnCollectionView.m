//
//  BtnCollectionView.m
//  Taoyi
//
//  Created by Lzy on 2018/2/1.
//  Copyright © 2018年 Lzy. All rights reserved.
//
#define kPadding 5
#import "BtnCollectionView.h"
#import "BtnCollectionViewCell.h"

@interface BtnCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(strong, nonatomic)UICollectionView *myCollectionView;
@property(strong, nonatomic)NSArray *titleArray;
@property(strong, nonatomic)NSArray *imageArray;
@property(assign, nonatomic)NSInteger rowNumber;
@end

@implementation BtnCollectionView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray rowNumber:(CGFloat)rowNumber{
    if (self = [super initWithFrame:frame]) {
        if (!self.myCollectionView) {
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
            collectionView.scrollEnabled = NO;
            [collectionView setBackgroundView:nil];
            [collectionView setBackgroundColor:[UIColor clearColor]];
            [collectionView registerClass:[BtnCollectionViewCell class] forCellWithReuseIdentifier:kCCellIdentifier_BtnCollectionViewCell];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            [self addSubview:collectionView];
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            self.myCollectionView = collectionView;
        }
        _titleArray = titleArray;
        _rowNumber = rowNumber;
        _imageArray = imageArray;
    }
    return self;
}
+(CGFloat)viewHeight{
    CGFloat viewHeight = 0;
//    ccellSize = CGSizeMake((self.frame.size.width - kPadding*(_rowNumber*2))/_rowNumber, (self.frame.size.height -(lineNum*2)*kPadding)/lineNum)
    return viewHeight;
}
#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return fminl(_titleArray.count,_imageArray.count);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BtnCollectionViewCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_BtnCollectionViewCell forIndexPath:indexPath];
    
    ccell.imgView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    ccell.titleLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    return ccell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize ccellSize = CGSizeZero;
    CGFloat lineNum = (fminl(_titleArray.count,_imageArray.count)/_rowNumber);
    CGFloat ccellWidth = (self.frame.size.width - kPadding/2*(_rowNumber-1))/_rowNumber;
    CGFloat ccellHeight = (self.frame.size.height -kPadding/2*(lineNum-1))/lineNum;
    
    if (self.rowNumber>0) {
        ccellSize = CGSizeMake(ccellWidth, ccellHeight);
    }else{
        ccellSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    }
    return ccellSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedBlock && self.imageArray.count > indexPath.row) {
        self.selectedBlock(indexPath);
    }
}

@end
