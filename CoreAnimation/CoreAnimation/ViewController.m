//
//  ViewController.m
//  CoreAnimation
//
//  Created by 草帽~小子 on 2019/5/17.
//  Copyright © 2019 OnePiece. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <CoreText/CoreText.h>
#import "LayerLabel.h"
#import "NextViewController.h"
#import "ReflectionView.h"
#import "ScrollView.h"

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5


@interface ViewController ()<CALayerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) UIView *layerView;

@property (nonatomic, strong) UIView *oneView;
@property (nonatomic, strong) UIView *twoView;
@property (nonatomic, strong) UIView *threeView;
@property (nonatomic, strong) UIView *fourView;

@property (nonatomic, strong) UIView *layerView1;
@property (nonatomic, strong) CALayer *blueLayer;
@property (nonatomic, strong) UIView *back;
@property (nonatomic, strong) UIImageView *containView;
@property (nonatomic, strong) NSMutableArray *faceArr;
@property (nonatomic, assign) CATransform3D trans;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIView *unobviouseBack;
@property (nonatomic, strong) CALayer *layer1;
@property (nonatomic, strong) CALayer *colorLayer;
@property (nonatomic, strong) UIButton *display;
@property (nonatomic, strong) CALayer *layer2;

@property (nonatomic, strong) UIImageView *hourHand;
@property (nonatomic, strong) UIImageView *minuteHand;
@property (nonatomic, strong) UIImageView *secondHand;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self addSubViews1];
    //[self addSubViews2];
    //[self addSubView3];
    //maskToBoundsj裁减掉了阴影，创建两个图层，一个处理阴影，一个裁剪
    //[self addSubView4];
    //[self addSubView5];
    //方块
    //[self dice];
    //[self transform3D];
    
    //CAShapeLayer
    //[self shapeLayer];
    //CATextLayer
    //[self textLayer];
    //[self gradientLayer];
    //[self replicatorLayer];
    //[self scrollView];
    //隐式动画
    //[self unobvious];
    //[self unobvious1];
    //[self presentLayer];
    
    //[self displayAnimation];
    [self propertyAnimation];
    
//    NextViewController *next = [[NextViewController alloc] init];
//    [self presentViewController:next animated:YES completion:nil];
//    Do any additional setup after loading the view.
}

- (void)propertyAnimation {
    self.secondHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.minuteHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    self.hourHand.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    //start timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    //set initial hand positions
    [self updateHandsAnimated:NO];
}

- (void)tick{
    [self updateHandsAnimated:YES];
}

- (void)updateHandsAnimated:(BOOL)animated{
    //convert time to hours, minutes and seconds
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger units = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hourAngle = (components.hour / 12.0) * M_PI * 2.0;
    //calculate hour hand angle //calculate minute hand angle
    CGFloat minuteAngle = (components.minute / 60.0) * M_PI * 2.0;
    //calculate second hand angle
    CGFloat secondAngle = (components.second / 60.0) * M_PI * 2.0;
    //rotate hands
    [self setAngle:hourAngle forHand:self.hourHand animated:animated];
    [self setAngle:minuteAngle forHand:self.minuteHand animated:animated];
    [self setAngle:secondAngle forHand:self.secondHand animated:animated];
}

- (void)setAngle:(CGFloat)angle forHand:(UIView *)handView animated:(BOOL)animated{
    //generate transform
    CATransform3D transform = CATransform3DMakeRotation(angle, 0, 0, 1);
    if (animated) {
        //create transform animation
        CABasicAnimation *animation = [CABasicAnimation animation];
        [self updateHandsAnimated:NO];
        animation.keyPath = @"transform";
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.duration = 0.5;
        animation.delegate = self;
        [animation setValue:handView forKey:@"handView"];
        [handView.layer addAnimation:animation forKey:nil];
    } else {
        //set transform directly
        handView.layer.transform = transform;
    }
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    //set final position for hand view
    UIView *handView = [anim valueForKey:@"handView"];
    handView.layer.transform = [anim.toValue CATransform3DValue];
}
- (void)displayAnimation{
    self.layer2 = [CALayer layer];
    self.layer2.frame = CGRectMake(100, 100, 100, 100);
    self.layer2.backgroundColor = [self randomColor].CGColor;
    [self.view.layer addSublayer:self.layer2];
    
    UIButton *tap2 = [UIButton buttonWithType:UIButtonTypeCustom];
    tap2.frame = CGRectMake(100, 300, 100, 100);
    tap2.backgroundColor = [self randomColor];
    [self.view addSubview:tap2];
    [tap2 addTarget:self action:@selector(tap3:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tap3:(UIButton *)send {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)[self randomColor].CGColor;
    animation.delegate = self;
    [self.layer2 addAnimation:animation forKey:nil];
}
//CAAnimationDelegate
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    self.layer2.backgroundColor = [self randomColor].CGColor;
//    [CATransaction commit];
//}



- (void)presentLayer {
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
    self.colorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
    self.colorLayer.backgroundColor = [self randomColor].CGColor;
    [self.view.layer addSublayer:self.colorLayer];
    
}

- (void)unobvious1{
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:back];
    
    self.layer1 = [CALayer layer];
    self.layer1.frame = back.bounds;
    self.layer1.backgroundColor = [self randomColor].CGColor;
    //add a custom action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.layer1.actions = @{@"backgroundColor": transition};
    //add it to our view
    [back.layer addSublayer:self.layer1];
    
}


- (void)unobvious{
    self.unobviouseBack = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    self.unobviouseBack.backgroundColor = [self randomColor];
    [self.view addSubview:self.unobviouseBack];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 200, 200);
    [self.unobviouseBack addSubview:btn];
    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)btn:(UIButton *)btn {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    self.unobviouseBack.layer.backgroundColor = [self randomColor].CGColor;
    
    [CATransaction setCompletionBlock:^{
//        CGAffineTransform transform = self.unobviouseBack.layer.transform;
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        self.unobviouseBack.layer.transform = transform;
    }];
    
    [CATransaction commit];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.unobviouseBack.backgroundColor = [self randomColor];
//    }];
    
}

- (void)scrollView {
    CALayer * layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 300, 300);
    layer.position = CGPointMake(150, 100);
    layer.contents = (__bridge id)[UIImage imageNamed:@"image1.jpg"].CGImage;
    
    ScrollView *scr = [[ScrollView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
    scr.layer.borderColor = [UIColor cyanColor].CGColor;
    scr.layer.borderWidth = 1;
    //scr.center = CGPointMake(100, 100);
    [scr.layer addSublayer:layer];
    [self.view addSubview:scr];
}

- (void)replicatorLayer {
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 300, 300)];
    back.backgroundColor = [self randomColor];
    [self.view addSubview:back];
    
    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
    layer.frame = back.bounds;
    [back.layer addSublayer:layer];
    //configure the replicator
    layer.instanceCount = 4;
    //apply a transform for each instance
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, -50, 0);
    transform = CATransform3DRotate(transform, M_PI_2 / 4.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, 50, 0);
    layer.instanceTransform = transform;
    //apply a color shift for each instance
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    //create a sublayer and place it inside the replicator
    CALayer *la = [CALayer layer];
    la.frame = CGRectMake(0, 100, 50, 50);
    la.backgroundColor = [UIColor whiteColor].CGColor;
    [layer addSublayer:la];
    
    ReflectionView *flect = [[ReflectionView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    flect.backgroundColor = [self randomColor];
    [back addSubview:flect];
}

- (void)shapeLayer {
    //create path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    //[bezierPath moveToPoint:CGPointMake(175, 100)];
    [bezierPath addArcWithCenter:CGPointMake(150, 100) radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [bezierPath moveToPoint:CGPointMake(150, 125)];
    [bezierPath addLineToPoint:CGPointMake(150, 175)];
    //[bezierPath moveToPoint:CGPointMake(150, 175)];
    [bezierPath addLineToPoint:CGPointMake(125, 225)];
    [bezierPath moveToPoint:CGPointMake(150, 175)];
    [bezierPath addLineToPoint:CGPointMake(175, 225)];
    [bezierPath moveToPoint:CGPointMake(100, 150)];
    [bezierPath addLineToPoint:CGPointMake(200, 150)];
    
    //create shape layer
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.strokeColor = [self randomColor].CGColor;
    shape.fillColor = [UIColor cyanColor].CGColor;
    shape.lineWidth = 5;
    shape.lineJoin = kCALineJoinBevel;
    shape.lineCap =  kCALineCapRound;
    shape.path = bezierPath.CGPath;
    //add it to our view
    [self.view.layer addSublayer:shape];
    
    //画圆角
    UIColor *color = [self randomColor];
    [color set];
    CGRect rect = CGRectMake(300, 300, 100, 100);
    CGSize radii = CGSizeMake(20, 20);
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineCapStyle = kCGLineCapRound;
    path.lineWidth = 5.0;
    [path stroke];
    
    CAShapeLayer *sha = [CAShapeLayer layer];
    sha.path = path.CGPath;
    [self.view.layer addSublayer:sha];
    
}

- (void)textLayer {
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    back.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:back];
    //creat a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = back.bounds;
    [back.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor orangeColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    
    NSString *str = @"寥落古行宫，宫花寂寞红。白头宫女在，闲坐说玄宗。";
    //CGFontRelease(fontRef);
    //textLayer.string = str;
    
    
    //这是因为并没有以Retina的方式渲染，contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //create attributed string
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
    
    CTFontRef fontReg = CTFontCreateWithName(fontName, font.pointSize, NULL);
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blackColor].CGColor,
                              (__bridge id)kCTFontAttributeName: (__bridge id)fontReg
                              };
    [string setAttributes:attribs range:NSMakeRange(0, [string length])];
    
//    attribs = @{
//                (__bridge id)kCTForegroundColorAttributeName: (__bridge id)[UIColor redColor].CGColor,
//                (__bridge id)kCTUnderlineStyleAttributeName: @(kCTUnderlineStyleSingle),
//                (__bridge id)kCTFontAttributeName: (__bridge id)fontReg
//                };
//    [string setAttributes:attribs range:NSMakeRange(6, 5)];

    CGFontRelease(fontRef);
    textLayer.string = string;
    
    LayerLabel *layerLabel = [[LayerLabel alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    layerLabel.backgroundColor = [UIColor cyanColor];
    layerLabel.text = @"自定义性能label";
    layerLabel.textColor = [UIColor purpleColor];
    layerLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:layerLabel];
    
}

- (void)gradientLayer {
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 200, 200)];
    [self.view addSubview:back];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = back.bounds;
    layer.colors = @[ (__bridge id)[UIColor cyanColor].CGColor, (__bridge id)[UIColor orangeColor].CGColor];
    layer.startPoint = CGPointMake(0, 0.5);
    layer.endPoint = CGPointMake(1, 0.5);
    layer.locations = @[ @(0.5f), @(0.8)];
    [back.layer addSublayer:layer];
}

- (void)addSubViews1 {
    self.layerView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    self.layerView.backgroundColor = [UIColor orangeColor];
    //设置图层内容，实际是CGImageRef,指向CGImage结构体的指针
    UIImage *image = [UIImage imageNamed:@"image1.jpg"];
    self.layerView.layer.contents = (__bridge id)(image.CGImage);
    //被拉伸了,
    /*
     *UIViewContentModeScaleAspectFit 原图大小
     *UIViewContentModeScaleAspectFill 以中心点等比向四周拉伸
     *UIViewContentModeScaleToFill 适应内容大小 默认
     */
    //self.layerView.contentMode = UIViewContentModeScaleToFill;
    //CALayer与contentMode对应的属性叫做contentsGravity
    /**
     *kCAGravityResizeAspect 对应UIViewContentModeScaleAspectFit
     *kCAGravityResizeAspectFill 对应UIViewContentModeScaleAspectFill
     *kCAGravityResize 对应UIViewContentModeScaleToFill
     */
    self.layerView.layer.contentsGravity = kCAGravityCenter;
    //contentsScale 设置contentsGravity属性后不起作用，属性定义了寄宿图的像素尺寸和视图大小的比例，默认情况下它是一个值为1.0的浮点数。
    //如果contentsScale设置为1.0，将会以每个点1个像素绘制图片，如果设置为2.0，则会以每个点2个像素绘制图片，这就是我们熟知的Retina屏幕。
    //但是如果我们把contentsGravity设置为kCAGravityCenter（这个值并不会拉伸图片），那将会有很明显的变化
    //当用代码的方式来处理寄宿图的时候，一定要记住要手动的设置图层的contentsScale属性，否则，你的图片在Retina设备上就显示得不正确啦
    self.layerView.layer.contentsScale = image.scale;
    //UIView有一个叫做clipsToBounds的属性可以用来决定是否显示超出边界的内容，CALayer对应的属性叫做masksToBounds，把它设置为YES
    self.layerView.layer.masksToBounds = YES;
    [self.view addSubview:self.layerView];
    NSLog(@"-------%ld", self.layerView.layer.sublayers.count);
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor cyanColor].CGColor;
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"image2.jpg"].CGImage);
    //[self.layerView.layer addSublayer:layer];
    NSLog(@"-------%ld", self.layerView.layer.sublayers.count);
    
    //图片拼合 (单张大图比多张小图载入地更快）
    self.oneView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    self.oneView.backgroundColor = [self randomColor];
    [self.view addSubview:self.oneView];
    
    self.twoView = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
    self.twoView.backgroundColor = [self randomColor];
    [self.view addSubview:self.twoView];
    
    self.threeView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
    self.threeView.backgroundColor = [self randomColor];
    [self.view addSubview:self.threeView];
    
    self.fourView = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)];
    self.fourView.backgroundColor = [self randomColor];
    [self.view addSubview:self.fourView];
    
    UIImage *image1 = [UIImage imageNamed:@"image3.jpg"];
    [self addSpriteImage:image1 withContentRect:CGRectMake(0, 0, 0.5, 0.5) ￼toLayer:self.oneView.layer];
//    [self addSpriteImage:image1 withContentRect:CGRectMake(0.5, 0, 0.5, 0.5) ￼toLayer:self.twoView.layer];
//    [self addSpriteImage:image1 withContentRect:CGRectMake(0, 0.5, 0.5, 0.5) ￼toLayer:self.threeView.layer];
//    [self addSpriteImage:image1 withContentRect:CGRectMake(0.5, 0.5, 0.5, 0.5) ￼toLayer:self.fourView.layer];
    
}

- (void)addSpriteImage:(UIImage *)image withContentRect:(CGRect)rect ￼toLayer:(CALayer *)layer //set image
{
    layer.contents = (__bridge id)image.CGImage;
    
    //scale contents to fit
    //layer.contentsGravity = kCAGravityResizeAspectFill;
    
    //set contentsRect
    //layer.contentsRect = rect;
    
    //set contentCenter
    layer.contentsCenter = rect;
}

- (void)addSubViews2 {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(50, 100, 200, 200);
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:layer];
    layer.delegate = self;
    layer.contentsScale = [UIScreen mainScreen].scale;
    [layer display];
    
}

- (void)addSubView3 {
    
    self.layerView1 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    self.layerView1.backgroundColor = [self randomColor];
    [self.view addSubview:self.layerView1];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
//    [self.layerView1 addGestureRecognizer:tap1];
    
    //create sublayer
    self.blueLayer = [CALayer layer];
    self.blueLayer.frame = CGRectMake(80.0f, 80.0f, 100.0f, 100.0f);
    self.blueLayer.backgroundColor = [self randomColor].CGColor;
    //add it to our view
    [self.layerView1.layer addSublayer:self.blueLayer];
    //从打印结果看出self.view.layer
    //NSLog(@"---------=========%@--------%@", self.view.layer.sublayers, self.view.layer);
    
//    UIView *layerView2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    layerView2.backgroundColor = [self randomColor];
//    [self.view addSubview:layerView2];
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
//    [layerView2 addGestureRecognizer:tap2];
//    NSLog(@"---------%f=========%f--------%@", self.layerView1.layer.zPosition, layerView2.layer.zPosition, self.view.layer.sublayers);
//    //打印self.layerView1.layer和layerView2.layer.zPosition的zPosition位置都为0，将self.layerView1.layer Z轴向前一个像素，相机（”相机“指x用户视觉）前置，但是手势方法还是x执行layerView2的
//    self.layerView1.layer.zPosition = 1.0f;
    
    //cornerRadius borderWidth 边框是绘制在图层边界里面的，而且在所有子内容之前，也在子图层之前
    //self.blueLayer.cornerRadius = 2.0;
    //self.blueLayer.borderWidth = 1.0;
    
    self.blueLayer.shadowColor = [self randomColor].CGColor;
    self.blueLayer.shadowOpacity = 0.5;
    //默认（0， -3）
    self.blueLayer.shadowOffset = CGSizeMake(10, 0);
    //默认0，模糊度，当它的值是0的时候，阴影就和视图一样有一个非常确定的边界线。当值越来越大的时候，边界线看上去就会越来越模糊和自然
    self.blueLayer.shadowRadius = 10;
    
}

- (void)addSubView4 {
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view1.backgroundColor = [self randomColor];
    //[self.view addSubview:view1];
//    view1.layer.cornerRadius = 20;
//    view1.layer.borderWidth = 5.0;
//    view1.layer.borderColor = [self randomColor].CGColor;
//    view1.layer.shadowColor = [self randomColor].CGColor;
//    view1.layer.shadowOpacity = 0.8;
//    view1.layer.shadowRadius = 5.0;
//    view1.layer.shadowOffset = CGSizeMake(0, 0);
//    view1.layer.masksToBounds = YES;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view2.backgroundColor = [self randomColor];
    //[self.view addSubview:view2];
    view2.layer.borderColor = [self randomColor].CGColor;
    view2.layer.cornerRadius = 20;
    view2.layer.borderWidth = 5.0;
    view2.layer.masksToBounds = YES;
    
    //
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(0, 0, 100, 100);
    layer2.shadowOpacity = 0.5;
    layer2.shadowColor = [UIColor cyanColor].CGColor;
    layer2.shadowOffset = CGSizeMake(0, 0);
    layer2.shadowRadius = 5.0;
    //[view1.layer addSublayer:layer2];
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(0, 0, 100, 100);
    layer1.backgroundColor = [self randomColor].CGColor;
    layer1.cornerRadius = 20;
    layer1.borderColor = [self randomColor].CGColor;
    //layer1.borderWidth = 5;
    //[view1.layer addSublayer:layer1];
    //NSLog(@"======%@", view1.layer.sublayers);
    
    //画任意形状的阴影
//    CGMutablePathRef squarePath = CGPathCreateMutable();
//    CGPathAddRect(squarePath, NULL, view1.bounds);
//    view1.layer.shadowPath = squarePath;
//    CGPathRelease(squarePath);
    
//    CGMutablePathRef circlePath = CGPathCreateMutable();
//    CGPathAddEllipseInRect(circlePath, NULL, view1.bounds);
//    view1.layer.shadowPath = circlePath;
//    CGPathRelease(circlePath);
    
//    如果是一个矩形或者是圆，用CGPath会相当简单明了。但是如果是更加复杂一点的图形，UIBezierPath类会更合适，它是一个由UIKit提供的在CGPath基础上的Objective-C包装类。
    
    //mask
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    imgV.image = [UIImage imageNamed:@"image2.jpg"];
    //[self.view addSubview:imgV];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(50, 50, 100, 100);
    //maskLayer.backgroundColor = [UIColor redColor].CGColor;
    UIImage *img1 = [UIImage imageNamed:@"image1.jpg"];
    maskLayer.contents = (__bridge id)img1.CGImage;
    //[imgV.layer addSublayer:maskLayer];
    //imgV.layer.mask = maskLayer;//x按照image1.jpg的不规则形状显示image2.jpg
    
    //CGAffineTransform
//    CGAffineTransformMakeRotation(<#CGFloat angle#>)
//    CGAffineTransformMakeScale(<#CGFloat sx#>, <#CGFloat sy#>)
//    CGAffineTransformMakeTranslation(<#CGFloat tx#>, <#CGFloat ty#>)
    
    //放射变换
//    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
//    view1.layer.affineTransform = transform;
//    NSLog(@"======%@", NSStringFromCGRect(view1.frame));
//
//    NSLog(@"======%@", NSStringFromCGRect(view1.frame));
//    //create a new transform 单位矩阵
//    CGAffineTransform transform1 = CGAffineTransformIdentity;
//    //scale by 50% (缩小50%)
//    transform1 = CGAffineTransformScale(transform1, 0.5, 0.5);
//    //rorate by 30 degrees(旋转30°)
//    transform1 = CGAffineTransformRotate(transform1, M_PI / 180 * 30.0);//弧度转度
//    //translate 200 by points(右移200像素)
//    transform1 = CGAffineTransformTranslate(transform1, 200, 0);
//    //apply transform to layer
//    view1.layer.affineTransform = transform1;
//    NSLog(@"======%@", NSStringFromCGRect(view1.frame));
    
    //3D
//    CATransform3DMakeRotation(<#CGFloat angle#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat z#>)
//    CATransform3DMakeScale(<#CGFloat sx#>, <#CGFloat sy#>, <#CGFloat sz#>)
//    CATransform3DMakeTranslation(<#CGFloat tx#>, <#CGFloat ty#>, <#CGFloat tz#>)
    //rotate the layer 45 degrees along the Y axis
//    CATransform3D transform3D = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//    view1.layer.transform = transform3D;
    //透视投影
    //m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位
//    CATransform3D transform3D1 = CATransform3DIdentity;
//    //apply perspective
//    transform3D1.m34 = -1.0 / 500.0;
//    //rotate by 45 degrees along the Y axis
//    transform3D1 = CATransform3DRotate(transform3D1, M_PI_4, 0, 1, 0);
//    imgV.layer.transform = transform3D1;
    //灭点Core当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外，见第三章）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
    //
    
//    UIView *contain = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    contain.backgroundColor = [self randomColor];
//    [self.view addSubview:contain];
//
//    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
//    imgV1.image = [UIImage imageNamed:@"image2.jpg"];
//    imgV1.layer.doubleSided = NO;
//    [contain addSubview:imgV1];
//
//    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(contain.frame.size.width - 100, 50, 100, 100)];
//    imgV2.image = [UIImage imageNamed:@"image3.jpg"];
//    [contain addSubview:imgV2];
//
//    CATransform3D perspective = CATransform3DIdentity;
//    perspective.m34 = -1.0 / 500;
//    contain.layer.sublayerTransform = perspective;
//
//    CATransform3D transform3D1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//    imgV1.layer.transform = transform3D1;
//
//    CATransform3D transform3D2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
//    imgV2.layer.transform = transform3D2;
    
    UIView *vi1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 100, 200, 200)];
    vi1.backgroundColor = [self randomColor];
    [self.view addSubview:vi1];
    
    UIView *vi2 = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    vi2.backgroundColor = [self randomColor];
    [vi1 addSubview:vi2];
    
    CATransform3D outer = CATransform3DIdentity;
    CATransform3D inner = CATransform3DMakeRotation(0, 0, 0, 0);
    
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(50, 50, 100, 100);
//    layer.backgroundColor = [self randomColor].CGColor;
//    layer.transform = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1);
//    [vi1.layer addSublayer:layer];
    
    //Z轴旋转
    outer.m34 = -1.0 / 500.0;
    outer = CATransform3DRotate(outer, M_PI_4, 0, 1, 0);
    vi1.layer.transform = outer;
    inner.m34 = -1.0 / 500.0;
    inner = CATransform3DRotate(inner, -M_PI_4, 0, 1, 0);
    vi2.layer.transform = inner;
    
}

- (void)addSubView5{
    self.back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    self.back.backgroundColor = [self randomColor];
    [self.view addSubview:self.back];
    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500;
    self.back.layer.sublayerTransform = perspective;
    
    for (NSUInteger i = 0; i < 6; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4, 100, self.view.frame.size.width / 2, self.view.frame.size.width / 2)];
        img.backgroundColor = [self randomColor];
        img.image = [UIImage imageNamed:@"image1.jpg"];
        [self.faceArr addObject:img];
        CATransform3D transform3D = CATransform3DIdentity;
        switch (i) {
            case 0:
                transform3D = CATransform3DMakeTranslation(0, 0, 100);
                transform3D = CATransform3DRotate(transform3D, 0, 0, 1, 0);
                [self addBoardView:i Transform3D:transform3D];
                break;
            case 1:
                transform3D = CATransform3DMakeTranslation(100, 0, 0);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, 0, 1, 0);
                [self addBoardView:i Transform3D:transform3D];
                break;
            case 2:
//                transform3D = CATransform3DMakeTranslation(0, 0, -100);
//                transform3D = CATransform3DRotate(transform3D, M_PI, 0, 1, 0);
//                [self addBoardView:i Transform3D:transform3D];
                break;
            case 3:
                transform3D = CATransform3DMakeTranslation(-100, 0, 0);
                transform3D = CATransform3DRotate(transform3D, -M_PI_2, 0, 1, 0);
                [self addBoardView:i Transform3D:transform3D];
                break;
            case 4:
                transform3D = CATransform3DMakeTranslation(0, 100, 0);
                transform3D = CATransform3DRotate(transform3D, -M_PI_2, 1, 0, 0);
                [self addBoardView:i Transform3D:transform3D];
                break;
            case 5:
                transform3D = CATransform3DMakeTranslation(0, -100, 0);
                transform3D = CATransform3DRotate(transform3D, M_PI_2, 1, 0, 0);
                [self addBoardView:i Transform3D:transform3D];
                break;
            default:
                break;
        }
    }
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
}

- (void)addBoardView:(NSInteger)board Transform3D:(CATransform3D)transform {
    UIImageView *v = self.faceArr[board];
    [self.view addSubview:v];
    CGSize contain = v.bounds.size;
    NSLog(@"=====%@", NSStringFromCGSize(contain));
    //v.center = CGPointMake(contain.width / 2.0, contain.height / 2.0);
    //v.layer.position = CGPointMake(contain.width / 2.0, contain.height / 2.0);
    v.layer.transform = transform;
}

- (void)dice{
    CGFloat width = self.view.frame.size.width / 2;
    self.back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 2, width * 2)];
    self.back.backgroundColor = [self randomColor];
    [self.view addSubview:self.back];
    
    self.trans = CATransform3DIdentity;
    CATransform3D tr = CATransform3DIdentity;
    tr.m34 = -1.0 / 500.0;
    self.trans = tr;
    CGRect rect = CGRectMake(width / 2, width / 2, width, width);
    CGFloat width1 = width / 2;
    
    UIView *v1 = [[UIView alloc] initWithFrame:rect];
    v1.backgroundColor = [self randomColor];
    [self.back addSubview:v1];
    CATransform3D trans1 = CATransform3DIdentity;
    trans1 = CATransform3DMakeTranslation(0, 0, width1);
    trans1 = CATransform3DRotate(trans1, 0, 0, 0, 0);
    v1.layer.transform = trans1;
    
    UIView *v2 = [[UIView alloc] initWithFrame:rect];
    v2.backgroundColor = [self randomColor];
    [self.back addSubview:v2];
    CATransform3D trans2 = CATransform3DIdentity;
    trans2 = CATransform3DMakeTranslation(width1, 0, 0);
    trans2 = CATransform3DRotate(trans2, M_PI_2, 0, 1, 0);
    v2.layer.transform = trans2;
    
    UIView *v3 = [[UIView alloc] initWithFrame:rect];
    v3.backgroundColor = [self randomColor];
    [self.back addSubview:v3];
    CATransform3D trans3 = CATransform3DIdentity;
    trans3 = CATransform3DMakeTranslation(0, 0, -width1);
    trans3 = CATransform3DRotate(trans3, M_PI, 0, 1, 0);
    v3.layer.transform = trans3;
    
    UIView *v4 = [[UIView alloc] initWithFrame:rect];
    v4.backgroundColor = [self randomColor];
    [self.back addSubview:v4];
    CATransform3D trans4 = CATransform3DIdentity;
    trans4 = CATransform3DMakeTranslation(-width1, 0, 0);
    trans4 = CATransform3DRotate(trans4, -M_PI_2, 0, 1, 0);
    v4.layer.transform = trans4;

    UIView *v5 = [[UIView alloc] initWithFrame:rect];
    v5.backgroundColor = [self randomColor];
    [self.back addSubview:v5];
    CATransform3D trans5 = CATransform3DIdentity;
    trans5 = CATransform3DMakeTranslation(0, -width1, 0);
    trans5 = CATransform3DRotate(trans5, M_PI_2, 1, 0, 0);
    v5.layer.transform = trans5;
    
    UIView *v6 = [[UIView alloc] initWithFrame:rect];
    v6.backgroundColor = [self randomColor];
    [self.back addSubview:v6];
    CATransform3D trans6 = CATransform3DIdentity;
    trans6 = CATransform3DMakeTranslation(0, width1, 0);
    trans6 = CATransform3DRotate(trans6, -M_PI_2, 1, 0, 0);
    v6.layer.transform = trans6;
    
    self.trans = CATransform3DRotate(self.trans, M_PI_4, 0, 1, 0);
    self.trans = CATransform3DRotate(self.trans, -M_PI_4, 1, 0, 0);
    self.back.layer.sublayerTransform = self.trans;
    
    [self applyLightingToFace:self.back.layer];
    
}

- (void)applyLightingToFace:(CALayer *)face
{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}


//- (void)displayLayer:(CALayer *)layer {
//    NSLog(@"======%@", layer);
//}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    NSLog(@"-=-=-=-%@", layer);
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor cyanColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}

- (void)transform3D{
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view1];
    NSLog(@"----------%@==========%@", view.layer, self.view.layer.sublayers);
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = touches.anyObject;
//    self.startPoint = [touch locationInView:self.view];
//    NSLog(@"ssssss");
//
//    //1.convertPoint:fromLayer:
////    point = [self.layerView1.layer convertPoint:point fromLayer:self.view.layer];
////    if ([self.layerView1.layer containsPoint:point]) {
////        point = [self.blueLayer convertPoint:point fromLayer:self.layerView1.layer];
////        if ([self.blueLayer containsPoint:point]) {
////            [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
////                                        message:nil
////                                       delegate:nil
////                              cancelButtonTitle:@"OK"
////                              otherButtonTitles:nil] show];
////        } else {
////            [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
////                                        message:nil
////                                       delegate:nil
////                              cancelButtonTitle:@"OK"
////                              otherButtonTitles:nil] show];
////        }
////    }
//
//    //2.hitTest
//    CALayer *layer = [self.layerView1.layer hitTest:point];
//    if (layer == self.blueLayer) {
//        [[[UIAlertView alloc] initWithTitle:@"Inside Blue Layer"
//                                    message:nil
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }else {
//        [[[UIAlertView alloc] initWithTitle:@"Inside White Layer"
//                                    message:nil
//                                   delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil] show];
//    }
    
    //presentLayer
    CGPoint point = [[touches anyObject] locationInView:self.view];
    //check if we've tapped the moving layer
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        self.colorLayer.backgroundColor = [self randomColor].CGColor;
    }else {
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0];
        self.colorLayer.backgroundColor = [self randomColor].CGColor;
        self.colorLayer.position = point;
        [CATransaction commit];
    }
    
}

//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint movePoint = [touch locationInView:self.back];
//    //从0转M_PI 对应 点移动了 width = self.view.frame.size.width / 2
//    CGFloat moveX = movePoint.x - self.startPoint.x;
//    CGFloat moveY = self.startPoint.y - movePoint.y;
//    CGFloat width = self.view.frame.size.width;
//    CGFloat rateX =  moveX / width * M_PI_2;
//    NSLog(@"------%f", rateX);
//    CGFloat rateY = moveY / width * M_PI_2;
//    CGFloat rate = 0.1;
//    if (movePoint.x > self.startPoint.x) {
//        self.trans = CATransform3DRotate(self.trans, rateX * rate, 0, 1, 0);
//        if (movePoint.y < self.startPoint.y) {
//            self.trans = CATransform3DRotate(self.trans, rateY * rate, 1, 0, 0);
//        }else {
//            self.trans = CATransform3DRotate(self.trans, rateY * rate, 1, 0, 0);
//        }
//    }else{
//        self.trans = CATransform3DRotate(self.trans, rateX * rate, 0, 1, 0);
//        if (movePoint.y < self.startPoint.y) {
//            self.trans = CATransform3DRotate(self.trans, rateY * rate, 1, 0, 0);
//        }else {
//            self.trans = CATransform3DRotate(self.trans, rateY * rate, 1, 0, 0);
//        }
//    }
//
//    self.back.layer.sublayerTransform = self.trans;
//}


- (void)tap1:(UIGestureRecognizer *)tap {
    NSLog(@"tap1");
}

- (void)tap2:(UIGestureRecognizer *)tap {
    NSLog(@"tap2");
}








- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
}

- (NSMutableArray *)faceArr {
    if (!_faceArr) {
        _faceArr = [[NSMutableArray alloc] init];
    }
    return _faceArr;
}


@end
