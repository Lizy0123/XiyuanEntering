//
//  MyGuidePageView.m
//  MyGuidePageView
//
//  Created by Apple on 16/7/14.
//  Copyright © 2016年 dingding3w. All rights reserved.
//

#import "MyGuidePageView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>


#define DDHidden_TIME   3.0
#define DDScreenW   [UIScreen mainScreen].bounds.size.width
#define DDScreenH   [UIScreen mainScreen].bounds.size.height

@interface MyGuidePageView ()<UIScrollViewDelegate>
{
    CGImageSourceRef gif;
    NSDictionary *gifProperties;
    size_t index;
    size_t count;
    NSTimer *timer;
}
@property (nonatomic, strong) NSArray                 *imageArray;
@property (nonatomic, strong) UIPageControl           *imagePageControl;
@property (nonatomic, assign) NSInteger               slideIntoNumber;
@property (nonatomic, strong) MPMoviePlayerController *playerController;
@end

@implementation MyGuidePageView

- (instancetype)initWithFrame:(CGRect)frame imageNameArray:(NSArray<NSString *> *)imageNameArray isButtonHidden:(BOOL)isHidden {
    if ([super initWithFrame:frame]) {
        self.slideInto = NO;
        if (isHidden == YES) {
            self.imageArray = imageNameArray;
        }
        
        // 设置引导视图的scrollview
        UIScrollView *guidePageView = [[UIScrollView alloc]initWithFrame:frame];
        [guidePageView setBackgroundColor:[UIColor lightGrayColor]];
        [guidePageView setContentSize:CGSizeMake(DDScreenW*imageNameArray.count, DDScreenH)];
        [guidePageView setBounces:NO];
        [guidePageView setPagingEnabled:YES];
        [guidePageView setShowsHorizontalScrollIndicator:NO];
        [guidePageView setDelegate:self];
        [self addSubview:guidePageView];
        
        // 设置引导页上的跳过按钮
        UIButton *skipButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.8, DDScreenW*0.1, 50, 25)];
        [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        [skipButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [skipButton setBackgroundColor:[UIColor grayColor]];
        // [skipButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        // [skipButton.layer setCornerRadius:5.0];
        [skipButton.layer setCornerRadius:(skipButton.frame.size.height * 0.5)];
        [skipButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        
        // 添加在引导视图上的多张引导图片
        for (int i=0; i<imageNameArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(DDScreenW*i, 0, DDScreenW, DDScreenH)];
            if ([[MyGuidePageView contentTypeForImageData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]]] isEqualToString:@"gif"]) {
                NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageNameArray[i] ofType:nil]];
                imageView = (UIImageView *)[[MyGuidePageView alloc] initWithFrame:imageView.frame gifImageData:localData];
                [guidePageView addSubview:imageView];
            } else {
                imageView.image = [UIImage imageNamed:imageNameArray[i]];
                [guidePageView addSubview:imageView];
            }
            
            // 设置在最后一张图片上显示进入体验按钮
            if (i == imageNameArray.count-1 && isHidden == NO) {
                [imageView setUserInteractionEnabled:YES];
                UIButton *startButton = [[UIButton alloc]initWithFrame:CGRectMake(DDScreenW*0.3, DDScreenH*0.8, DDScreenW*0.4, DDScreenH*0.08)];
                [startButton setTitle:@"开始体验" forState:UIControlStateNormal];
                [startButton setTitleColor:[UIColor colorWithRed:164/255.0 green:201/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
                [startButton.titleLabel setFont:[UIFont systemFontOfSize:21]];
                [startButton setBackgroundImage:[UIImage imageNamed:@"guideImage_button_backgound"] forState:UIControlStateNormal];
                [startButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:startButton];
            }
        }
        
        // 设置引导页上的页面控制器
        self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(DDScreenW*0.0, DDScreenH*0.9, DDScreenW*1.0, DDScreenH*0.1)];
        self.imagePageControl.currentPage = 0;
        self.imagePageControl.numberOfPages = imageNameArray.count;
        self.imagePageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.imagePageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        [self addSubview:self.imagePageControl];
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = scrollview.contentOffset.x / scrollview.frame.size.width;
    [self.imagePageControl setCurrentPage:page];
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == NO) {
        [self buttonClick:nil];
    }
    if (self.imageArray && page < self.imageArray.count-1 && self.slideInto == YES) {
        self.slideIntoNumber = 1;
    }
    if (self.imageArray && page == self.imageArray.count-1 && self.slideInto == YES) {
        UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:nil action:nil];
        if (swipeGestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight){
            self.slideIntoNumber++;
            if (self.slideIntoNumber == 3) {
                [self buttonClick:nil];
            }
        }
    }
}

- (void)buttonClick:(UIButton *)button {
    [UIView animateWithDuration:DDHidden_TIME animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DDHidden_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self performSelector:@selector(removeGuidePageHUD) withObject:nil afterDelay:1];
        });
    }];
}

- (void)removeGuidePageHUD {
    [self removeFromSuperview];
}

/**< APP视频新特性页面(新增测试模块内容) */
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)videoURL {
    if ([super initWithFrame:frame]) {
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.playerController.view setFrame:frame];
        [self.playerController.view setAlpha:1.0];
        [self.playerController setControlStyle:MPMovieControlStyleNone];
        [self.playerController setRepeatMode:MPMovieRepeatModeOne];
        [self.playerController setShouldAutoplay:YES];
        [self.playerController prepareToPlay];
        [self addSubview:self.playerController.view];
        
        // 视频引导页进入按钮
        UIButton *movieStartButton = [[UIButton alloc] initWithFrame:CGRectMake(20, DDScreenH-30-40, DDScreenW-40, 40)];
        [movieStartButton.layer setBorderWidth:1.0];
        [movieStartButton.layer setCornerRadius:20.0];
        [movieStartButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [movieStartButton setTitle:@"开始体验" forState:UIControlStateNormal];
        [movieStartButton setAlpha:0.0];
        [self.playerController.view addSubview:movieStartButton];
        [movieStartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:DDHidden_TIME animations:^{
            [movieStartButton setAlpha:1.0];
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - 通过图片Data数据第一个字节来获取图片扩展名
+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}

#pragma mark - 通过图片字符串的截取来获取图片的扩展名
+ (NSString *)contentTypeForImageURL:(NSString *)url {
    NSString *extensionName = url.pathExtension;
    if ([extensionName.lowercaseString isEqualToString:@"jpeg"]) {
        return @"jpeg";
    }
    if ([extensionName.lowercaseString isEqualToString:@"gif"]) {
        return @"gif";
    }
    if ([extensionName.lowercaseString isEqualToString:@"png"]) {
        return @"png";
    }
    return nil;
}

#pragma mark - 自定义播放Gif图片(Path)
- (id)initWithFrame:(CGRect)frame gifImagePath:(NSString *)gifImagePath {
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:gifImagePath], (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(play) userInfo:nil repeats:YES];/**< 0.12->0.06 */
        [timer fire];
    }
    return self;
}

#pragma mark - 自定义播放Gif图片(Data)(本地+网络)
- (id)initWithFrame:(CGRect)frame gifImageData:(NSData *)gifImageData {
    self = [super initWithFrame:frame];
    if (self) {
        gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
        gif = CGImageSourceCreateWithData((CFDataRef)gifImageData, (CFDictionaryRef)gifProperties);
        count =CGImageSourceGetCount(gif);
        timer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(play) userInfo:nil repeats:YES];/**< 0.12->0.06 */
        [timer fire];
    }
    return self;
}

- (void)play {
    if (count > 0) {
        index ++;
        index = index%count;
        CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
        self.layer.contents = (__bridge id)ref;
        CFRelease(ref);
    } else {
        static dispatch_once_t onceToken;
        // 只执行一次
        dispatch_once(&onceToken, ^{
            NSLog(@"请检测网络或者http协议");
        });
    }
}

- (void)removeFromSuperview {
    [timer invalidate];
    timer = nil;
    self.block();
    [super removeFromSuperview];
}

#pragma mark - 加载本地GIF图片无需设置NSTimer(自定义播放Gif图片(Name))
/**< 使用案例: [self.XXX addSubview:[[DHGifImageOperation alloc] initWithFrame:self.adFrame gifImageName:@"XXX.gif"]]; */
- (id)initWithFrame:(CGRect)frame gifImageName:(NSString *)gifImageName {
    self = [super initWithFrame:frame];
    if (self) {
        NSString *gifImgName = [gifImageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
        NSData *gifData      = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifImgName ofType:@"gif"]];
        UIWebView *webView   = [[UIWebView alloc] initWithFrame:frame];
        [webView setBackgroundColor:[UIColor clearColor]];
        [webView setScalesPageToFit:YES];
        [webView.scrollView setScrollEnabled:NO];
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:@"" baseURL:[NSURL URLWithString:@""]];
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setFrame:webView.frame];
        [clearButton setBackgroundColor:[UIColor clearColor]];
        [clearButton addTarget:self action:@selector(activiTap:) forControlEvents:UIControlEventTouchUpInside];
        [webView addSubview:clearButton];
        [self addSubview:webView];
    }
    return self;
}

- (void)activiTap:(UITapGestureRecognizer*)recognizer{
    NSLog(@"[DHGifImageOperation.h]:activiTap:recognizer");
}


@end
