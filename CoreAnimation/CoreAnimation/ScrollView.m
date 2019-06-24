//
//  ScrollView.m
//  CoreAnimation
//
//  Created by 草帽~小子 on 2019/6/4.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

+ (Class)layerClass{
    return [CAScrollLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

//xib
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp{
//    
//    self.layer.contents = (__bridge id)[UIImage imageNamed:@"image1.jpg"].CGImage;
//    self.layer.bounds = CGRectMake(0, 0, 200, 200);
//    self.layer.position = CGPointMake(150, 100);
//    self.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    self.layer.masksToBounds = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    NSLog(@"sss");
    //get the offset by subtracting the pan gesture
    //translation from the current bounds origin
    CGPoint offset = self.bounds.origin;
    offset.x -= [pan translationInView:self].x;
    offset.y -= [pan translationInView:self].y;
    [(CAScrollLayer *)self.layer scrollPoint:offset];
    [pan setTranslation:CGPointZero inView:self];
}

@end
