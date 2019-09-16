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
}

- (void)createShareView{
    // view 生成图片
    self.shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 200)];
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

- (void)BtnClicked {
    UIImage *img = [self createViewImage:self.shareView];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

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

- (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
    // 图片拼接
    UIImage *image1 = [UIImage imageNamed:imageName1];
    UIImage *image2 = [UIImage imageNamed:imageName2];
    
    UIGraphicsBeginImageContext(image1.size);
    
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    [image2 drawInRect:CGRectMake((image1.size.width - image2.size.width)/2,(image1.size.height - image2.size.height)/2, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}
@end
