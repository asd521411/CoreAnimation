//
//  ReflectionView.m
//  CoreAnimation
//
//  Created by 草帽~小子 on 2019/6/4.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ReflectionView.h"

@implementation ReflectionView

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

- (void)setUp {
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.instanceCount = 2;
    CATransform3D transform = CATransform3DIdentity;
    CGFloat verticalOffset = self.bounds.size.height + 2;
    transform = CATransform3DTranslate(transform, 0, verticalOffset, 0);
    transform = CATransform3DScale(transform, 1, -1, 0);
    layer.instanceTransform = transform;
    layer.instanceAlphaOffset = -0.6;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

@end
