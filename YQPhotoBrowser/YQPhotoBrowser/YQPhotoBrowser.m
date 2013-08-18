//
//  YQPhotoBrowser.m
//  YQPhotoBrowser
//
//  Created by yang hai on 13-8-17.
//  Copyright (c) 2013年 billwang1990@gmail.com. All rights reserved.
//

#import "YQPhotoBrowser.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <SDImageCache.h>

@interface YQPhotoBrowser ()<UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat mContentOffset;
    NSInteger mcurrentIndex;
    UIPageControl *pageControl;
    NSMutableArray *descriptionHeight;
    CGFloat width;
}

@property (nonatomic) NSArray *imgUrlArray;
@property (nonatomic) NSMutableArray *imgViewArray;
@property (nonatomic) NSArray *descriptionArray;
@property (nonatomic) UIScrollView *mainScroll;

@end

@implementation YQPhotoBrowser

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    width = self.view.bounds.size.width ;
    mContentOffset = 0.0;
        
    self.view.backgroundColor = [UIColor blackColor];
    
    [self calculateTextHeight:_descriptionArray];

    self.mainScroll = [[UIScrollView alloc]initWithFrame:CGRectZero];
    self.mainScroll.backgroundColor = [UIColor clearColor];
    
    [self.mainScroll setPagingEnabled:YES];
    self.mainScroll.showsHorizontalScrollIndicator = NO;
    self.mainScroll.showsVerticalScrollIndicator = NO;
    self.mainScroll.delegate = self;
    
    if (!self.navigationController) {
        CGRect bounds = [[self view] bounds];
        [self.mainScroll setFrame:bounds];
    }
    else
    {
        [self.mainScroll setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    }
    
    
    [self setScrollContentSize];
    
    [self.view addSubview:self.mainScroll];
    [self addImagePage];
    
    pageControl = [[UIPageControl alloc]init];
    
    pageControl.numberOfPages = self.imgUrlArray.count;
    [pageControl sizeToFit];
    
    [pageControl setCenter:CGPointMake(self.mainScroll.frame.size.width/2.0, self.mainScroll.frame.size.height - 20)];
    [self.view addSubview:pageControl];

    mcurrentIndex = 0;
    
    [self scrollViewCurrentIndex:mcurrentIndex];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id)initWithImagesUrl:(NSArray *)img andDescription:(NSArray *)text
{
    if(self = [super init])
    {
        _imgUrlArray = img;
        if (text && (img.count == text.count)) {
            _descriptionArray = text;
        }
        else
            _descriptionArray = nil;
    }
    return self;
}

-(void)setScrollContentSize
{
    
    self.mainScroll.contentSize = CGSizeMake(self.mainScroll.bounds.size.width * [self.imgUrlArray count], self.mainScroll.bounds.size.height);
    
}

-(void)scrollViewCurrentIndex:(NSInteger)index
{
    [self.mainScroll setContentOffset:CGPointMake(self.view.bounds.size.width * index, 0) animated:YES];
}


-(void)addImagePage
{
    if(self.imgUrlArray.count > 0)
    {
        
        if (!self.imgViewArray) {
            self.imgViewArray = [[NSMutableArray alloc]init];
        }
        
        [self.imgUrlArray  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:[self.mainScroll bounds]];
            imageView.tag = idx;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            
            
            UIScrollView *imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(self.mainScroll.bounds.size.width * idx,  5, self.mainScroll.bounds.size.width, self.mainScroll.frame.size.height - 10)];
            imageScrollView.contentSize=imageView.frame.size;
            imageScrollView.maximumZoomScale=3.0;
            imageScrollView.minimumZoomScale=1.0;
            imageScrollView.showsHorizontalScrollIndicator = NO;
            imageScrollView.showsVerticalScrollIndicator = NO;
            [imageScrollView setZoomScale:1.0];
            [imageScrollView addSubview:imageView];
            [imageScrollView setTag:idx];
            imageScrollView.delegate = self;

            [self.imgViewArray addObject:imageView];
            [imageScrollView addSubview:imageView];
            
            NSURL *url = [NSURL URLWithString:obj];
            
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];  
            hud.mode = MBProgressHUDModeDeterminate;
            hud.labelText = @"加载中";
            [imageView addSubview:hud];
            [hud show:YES];
            
            
            id object = [self.descriptionArray objectAtIndex:idx];
            
            BOOL haveDescription = NO;
            
            //we won't add textview if there isn'a description
            if ([object isKindOfClass:[NSString class]]) {
                
                haveDescription = YES;
                
                NSNumber *n = [descriptionHeight objectAtIndex:idx];
                
                CGFloat height = [n floatValue];
                
                UITextView *imgDescriptiong = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
                
                imgDescriptiong.text = [self.descriptionArray objectAtIndex:idx];
                imgDescriptiong.userInteractionEnabled = NO;
                [imgDescriptiong setFont:[UIFont systemFontOfSize:FONTSIZE]];
                imgDescriptiong.backgroundColor = [UIColor blackColor];
                imgDescriptiong.textColor = [UIColor whiteColor];
                imgDescriptiong.alpha = 0.0f;
                
                [imageView addSubview:imgDescriptiong];
            }
            
            [self.mainScroll addSubview:imageScrollView];
            
            
            //use sdwebimage
            [imageView setImageWithURL:url placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize) {
                
                CGFloat recv = (CGFloat)receivedSize / expectedSize;
                
                hud.progress = recv;
                                        
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                [hud hide:YES];
                [hud removeFromSuperview];
                
                UITapGestureRecognizer *tapForZoom = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapEvent:)];
                
                tapForZoom.delegate = self;
                tapForZoom.numberOfTapsRequired = 2;
                [imageScrollView addGestureRecognizer:tapForZoom];
                
                if (haveDescription) {
                    
                    UITapGestureRecognizer *tapShowDescription = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDescription:)];
                    
                    tapShowDescription.delegate = self;
                    tapShowDescription.numberOfTapsRequired = 1;
                    [tapShowDescription requireGestureRecognizerToFail:tapForZoom];
                    [imageScrollView addGestureRecognizer:tapShowDescription];
                }
            }];
            
        }];
    }
}

#pragma mark scrollview delegate method
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        
        return v;
    }
    return nil;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    
    
    if (scroll == self.mainScroll) {
        
        mcurrentIndex = scroll.contentOffset.x / scroll.frame.size.width;
        
#ifdef DEBUG
        NSLog(@"currentPage %d", mcurrentIndex);
#endif
        pageControl.currentPage = mcurrentIndex;
        
    }
}

-(void)handleTapEvent:(UIGestureRecognizer*)gesture
{
    UIScrollView *scroll = (UIScrollView*)gesture.view;
    
    if (scroll.zoomScale > scroll.minimumZoomScale) {
        [scroll setZoomScale:scroll.minimumZoomScale animated:YES];
    }
    else
    {
        CGPoint Pointview=[gesture locationInView:scroll];
        CGFloat newZoomscal=3.0;
        
        newZoomscal = MIN(newZoomscal, scroll.maximumZoomScale);
        
        CGSize scrollViewSize =  scroll.bounds.size;
        
        CGFloat w=scrollViewSize.width/newZoomscal;
        CGFloat h=scrollViewSize.height /newZoomscal;
        CGFloat x= Pointview.x-(w/2.0);
        CGFloat y = Pointview.y-(h/2.0);
        
        CGRect rectTozoom=CGRectMake(x, y, w, h);
        
        [scroll zoomToRect:rectTozoom animated:YES];
        
        [scroll setZoomScale:3.0 animated:YES];
    }
    
}

-(void)showDescription:(UIGestureRecognizer*)recongnizer
{
    UIScrollView *view = (UIScrollView*)recongnizer.view;
    
    __block UITextView *textView;
    
    //bad code
    [view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            UIImageView *img = (UIImageView*)obj;
            [img.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[UITextView class]]) {
                    *stop = YES;
                    textView = obj;
                    
                    if (textView.alpha > 0.0f) {
                        [UIView animateWithDuration:0.4 animations:^{
                            textView.alpha = 0.0f;
                        }];
                    }
                    else
                    {
                        [UIView animateWithDuration:0.4 animations:^{
                            textView.alpha = 0.7f;
                        }];
                    }
                }
            }];

        }
    }];
    
}

-(void)calculateTextHeight:(NSArray*)text
{
    if (!text) {
        return;
    }
    
    if (!descriptionHeight) {
        descriptionHeight = [[NSMutableArray alloc]initWithCapacity:text.count];
    }
    [text enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSString class]]) {
            
            
            NSString *str = (NSString *)obj;
            
            CGSize constraint = CGSizeMake(width - 20, MAXFLOAT);
            
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:FONTSIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByCharWrapping];
            
            NSNumber *height = [NSNumber numberWithFloat:size.height + 20];
            
            [descriptionHeight addObject:height];
        }
         else
         {
             [descriptionHeight addObject:[NSNull null]];
         }
     }];
    
}


@end
