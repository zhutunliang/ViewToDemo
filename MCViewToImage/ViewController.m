//
//  ViewController.m
//  MCViewToImage
//
//  Created by nemo on 2019/9/16.
//  Copyright © 2019 nemo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic ,strong) UIView *shareView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"View生成图片";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createShareView];
    [self combineImageFromColor];
    
}

- (void)combineImageFromColor {
    UIImage *image0 = [self imageFromColor:[UIColor whiteColor] size:CGSizeMake(375, 657)];
    UIImage *image1 = [self imageFromColor:[UIColor greenColor] size:CGSizeMake(375, 10)];
    UIImage *image2 = [self imageFromColor:[UIColor yellowColor] size:CGSizeMake(375, 647)];
    UIImage *image3 = [self imageFromColor:[UIColor redColor] size:CGSizeMake(375, 85)];
    
    UIImage *resultImage =  [self addImage:image0 image1:image1 image2:image2 image3:image3];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 375, 657)];
    imageView.image = resultImage;
    [self.view addSubview:imageView];
}

- (UIImage*)imageFromColor:(UIColor*)color size:(CGSize)size {
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(size);//创建图片
    CGContextRef context = UIGraphicsGetCurrentContext();//创建图片上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);//设置当前填充颜色的图形上下文
    CGContextFillRect(context, rect);//填充颜色
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (void)createShareView{
    // view 生成图片
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.shareView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.shareView];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 200, 200)];
    image.image = [UIImage imageNamed:@"bicycle.png"];
    image.backgroundColor = [UIColor greenColor];
    [self.shareView addSubview:image];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, [UIScreen mainScreen].bounds.size.width - 20, 30)];
    label.text = @"Stay hungry Stay foolish.";
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [self.shareView addSubview:label];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 100, [UIScreen mainScreen].bounds.size.width-40, 44)];
    btn.backgroundColor = [UIColor redColor];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"Share" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}




// 多个Image 拼接成一个Image
- (UIImage *)addImage:(UIImage*)image0 image1:(UIImage*)image1 image2:(UIImage*)image2 image3:(UIImage*)image3 {
    CGSize size = image0.size;
    // 1.以其中一个图的size创建绘制上下文
    UIGraphicsBeginImageContext(size);
    // 2. 首先必须先绘制此size的图，切记
    [image0 drawInRect:CGRectMake(0, 0, image0.size.width, image0.size.height)];
    // 3. 然后在此size上绘制其他图
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, 10, image2.size.width, image2.size.height)];
    [image3 drawInRect:CGRectMake(0, image2.size.height + 10, image3.size.width, image3.size.height)];
    // 4.根据此上下文生成图
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}


/// view -> Image
- (UIImage *)createViewImage:(UIView *)shareView {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数 [UIScreen mainScreen].scale。
    
    UIGraphicsBeginImageContextWithOptions(shareView.bounds.size, YES, [UIScreen mainScreen].scale);
    [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片保存成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        
        NSLog(@"保存成功");
    }else{
        
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片保存失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alter show];
        NSLog(@"保存失败");
    }
}

#pragma mark - Action

- (void)BtnClicked {
    UIImage *img = [self createViewImage:self.shareView];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}



@end
