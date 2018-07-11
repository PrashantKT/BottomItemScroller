//
//  ViewController.m
//  ScrollTest
//
//  Created by Prashant Tukadiya  on 01/06/18.
//  Copyright © 2018 Prashant Tukadiya. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) int count;
@property (nonatomic) int currentItem;
@property (nonatomic) CGFloat  previousOffset;
@property (nonatomic,strong) UIScrollView *aScrollView;
@property (nonatomic,strong) UIView *parentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 26;
    btnCapture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCapture.frame = CGRectMake((self.view.frame.size.width-100)/2,self.view.frame.size.height - 120, 100, 100);
    [btnCapture setImage:[UIImage imageNamed:@"capture.png"] forState:UIControlStateNormal];
    
    [self setscrollview];
    [self.view addSubview:btnCapture];
    self.currentItem = 1;
    self.previousOffset = 0.0;
}

-(void)setscrollview
{
    UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 100)];
    aScrollView.backgroundColor = [UIColor clearColor];
    aScrollView.delegate = self;
    
    _parentView = [UIView new];
    self.parentView.frame = aScrollView.bounds;
    for (int i = 0; i < self.count; i++)
    {
        CGRect frame;
        if(i == 0) {
            frame = CGRectMake((self.view.frame.size.width-90)/2,5, 90, 90);
           
        } else {
           frame  = CGRectMake([self.parentView viewWithTag:i].frame.origin.x + 90, 5, 90, 90);
        }
        UIImageView *imgProfile = [[UIImageView alloc] initWithFrame:frame];

        imgProfile.image = [UIImage imageNamed:@"profile.jpg"];
        imgProfile.tag = i + 1;
        imgProfile.contentMode = UIViewContentModeScaleAspectFill;
        imgProfile.clipsToBounds = TRUE;
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2;
        imgProfile.backgroundColor = [UIColor redColor];
        [self.parentView addSubview:imgProfile];
    }
    
    [aScrollView setContentSize:CGSizeMake([self.parentView viewWithTag:self.count].frame.origin.x + [self.parentView viewWithTag:1].frame.origin.x + 90, 90)];
    self.parentView.frame = (CGRect){CGPointZero, aScrollView.contentSize};
    [aScrollView addSubview:self.parentView];
    self.aScrollView = aScrollView;
    [self.view addSubview:aScrollView];
}

- (void) findCenterImages {
    NSMutableArray *arrIntersect = [NSMutableArray new];
    CGRect convertedRect =  [self.view convertRect:btnCapture.frame toView:self.parentView];
    
    for (UIImageView *imageview in self.parentView.subviews) {
        
        if (CGRectIntersectsRect(convertedRect, imageview.frame)) {
            [arrIntersect addObject:imageview];
            
        }
    }
    
    
    if (arrIntersect.count == 3) {
        [arrIntersect removeObject:[arrIntersect firstObject]];
    }
    
    
    CGRect frame;

    if (arrIntersect.count == 1) {
        frame =  ((UIImageView *)arrIntersect[0]).frame;

    } else if (arrIntersect.count == 2){
        if (CGRectIntersection(convertedRect, ((UIImageView *)arrIntersect[0]).frame).size.width >  CGRectIntersection(convertedRect, ((UIImageView *)arrIntersect[1]).frame).size.width ) {
            frame =  ((UIImageView *)arrIntersect[0]).frame;
        } else {
            frame =  ((UIImageView *)arrIntersect[1]).frame;
        }
    }

    
    CGFloat pointX = convertedRect.origin.x -  frame.origin.x;

 
    
    [UIView animateWithDuration:0.12 delay:0.0 usingSpringWithDamping:2 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.aScrollView.contentOffset = CGPointMake(self.aScrollView.contentOffset.x -pointX , self.aScrollView.contentOffset.y);

    } completion:^(BOOL finished) {
        
    }];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self findCenterImages];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    [self findCenterImages];
    
}











@end
