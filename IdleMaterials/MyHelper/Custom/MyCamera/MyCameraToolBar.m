//
//  MyCameraToolBar.m
//  LGPhotoBrowser
//
//  Created by Lzy on 2018/1/13.
//  Copyright © 2018年 L&G. All rights reserved.
//

#import "MyCameraToolBar.h"
static CGFloat BOTTOM_HEIGHT = 60;

@interface MyCameraToolBar()
@property (nonatomic, strong) UIImageView *photoDisplayView;

@end
@implementation MyCameraToolBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        [self setupBottomView];
    }
    return self;
}

- (void)setupBottomView {
    CGFloat width = 80;
    CGFloat margin = 20;
    
    // 显示照片的view   在imageToDisplay的set方法中设置frame和image
    UIImageView *photoDisplayView = [[UIImageView alloc] init];
    [self addSubview:photoDisplayView];
    _photoDisplayView = photoDisplayView;
    
    // 底部View
    UIView *controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-BOTTOM_HEIGHT, self.frame.size.width, BOTTOM_HEIGHT)];
    controlView.backgroundColor = [UIColor clearColor];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self addSubview:controlView];
    
    //‘重拍’按钮
    UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancalBtn.frame = CGRectMake(margin, 0, width, controlView.frame.size.height);
    [cancalBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [cancalBtn addTarget:self action:@selector(cancel1) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:cancalBtn];
    
    //‘使用照片’按钮
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(self.frame.size.width - margin - width, 0, width, controlView.frame.size.height);
    [doneBtn setTitle:@"使用照片" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [controlView addSubview:doneBtn];
}

//setter
- (void)setImageToDisplay:(UIImage *)imageToDisplay {
    _imageToDisplay = imageToDisplay;
    
    if (imageToDisplay == nil) {
        return;
    }
    
    CGSize size;
    size.width = [UIScreen mainScreen].bounds.size.width;
    size.height = ([UIScreen mainScreen].bounds.size.width / imageToDisplay.size.width) * imageToDisplay.size.height;
    CGFloat x = (self.frame.size.width - size.width) / 2;
    CGFloat y = (self.frame.size.height - size.height) / 2;
    _photoDisplayView.frame = CGRectMake(x, y, size.width, size.height);
    [_photoDisplayView setImage:imageToDisplay];
}

- (void)cancel1 {
    if ([_delegate respondsToSelector:@selector(cancleBtnClicked)]) {
        [_delegate cancleBtnClicked];
    }
    [self removeFromSuperview];
}

- (void)doneAction {
    if ([_delegate respondsToSelector:@selector(useBtnClicked)]) {
        [_delegate useBtnClicked];
    }
}

@end





@implementation MyCameraModel

//- (UIImage *)photoImage{
//    return [UIImage imageWithContentsOfFile:self.imagePath];
//}

@end




#import "UIView+Layout.h"
//#import "UIImage+ZLPhotoLib.h"

@interface MyCameraImgView ()
@property (strong, nonatomic) UIImageView *delBtnImgView;
@end

@implementation MyCameraImgView


//- (UIImageView *)delBtnImgView{
//    if (!_delBtnImgView) {
//
//        [self addSubview:_delBtnImgView];
//    }
//    return _delBtnImgView;
//}

- (void)setEdit:(BOOL)edit{
    self.delBtnImgView.hidden = NO;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (!_delBtnImgView) {
            _delBtnImgView = [[UIImageView alloc] init];
            _delBtnImgView.image = [UIImage imageNamed:@"photo_delete"];
            _delBtnImgView.width = 25;
            _delBtnImgView.height = 25;
            _delBtnImgView.hidden = YES;
            _delBtnImgView.x = frame.size.width-25;
            _delBtnImgView.y = 0;
            _delBtnImgView.userInteractionEnabled = YES;
            [_delBtnImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleImg:)]];
        }
        [self addSubview:_delBtnImgView];
        self.userInteractionEnabled = YES;
    }return self;
}

#pragma mark 删除图片
- (void)deleImg:(UITapGestureRecognizer *)tap{
    if ([self.delegatge respondsToSelector:@selector(deleteImgView:)]) {
        [self.delegatge deleteImgView:self];
    }
}

@end
