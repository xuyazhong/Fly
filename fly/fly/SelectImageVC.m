//
//  SelectImageVC.m
//  fly
//
//  Created by xyz on 15-3-9.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "SelectImageVC.h"
//#import "UzysAssetsPickerController.h"



@interface SelectImageVC ()//<UzysAssetsPickerControllerDelegate>
{
    selectImageBlock _finishedBlock;
    notSelectBlock _failedBlock;
}
@end

@implementation SelectImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *sucessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sucessBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sucessBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [sucessBtn setFrame:CGRectMake(0, 0, 60, 20)];
    [sucessBtn addTarget:self action:@selector(sucessBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:sucessBtn];
    self.navigationItem.rightBarButtonItem = item;
    
//    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
//    picker.delegate = self;
//    picker.maximumNumberOfSelectionVideo = 0;
//    picker.maximumNumberOfSelectionPhoto = 1;
//
//    [self presentViewController:picker animated:YES completion:^{
//        
//    }];
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
    }];
    
    // Do any additional setup after loading the view.
}
/*
-(void)sucessBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
 */
-(void)viewWillAppear:(BOOL)animated
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
-(void)requestImageSuccess:(selectImageBlock)selBlock failed:(notSelectBlock)notSelBlock
{
    _finishedBlock = selBlock;
    _failedBlock = notSelBlock;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - image delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"info:%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        NSLog(@"info:%@",info);
        NSData *pngData = UIImagePNGRepresentation(image);
        _finishedBlock(pngData);
        
    }else
    {
        _failedBlock(@"not have image");
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }];
}

//点击cancel按钮的时候,触发此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"cancel");
        }];
    }];
}
/*
#pragma mark - picker deleimage
- (void)UzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    NSLog(@"取消选择图片");
    _failedBlock(@"failed select image");
    [picker dismissViewControllerAnimated:YES completion:^{
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"cancel");
        }];
    }];
}

- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    //NSLog(@"选择图片:%@",assets);

    [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ALAsset *representation = obj;
        UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage scale:representation.defaultRepresentation.scale orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        NSData *pngData = UIImagePNGRepresentation(img);

        if (pngData)
        {
            _finishedBlock(pngData);
            NSLog(@"ok");
        }else
        {
            _failedBlock(@"not have image");
            NSLog(@"failed");
        }
    }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.51 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^
                   {
                       if (![self.presentedViewController isBeingDismissed])
                       {
                           [self dismissViewControllerAnimated:YES completion:^
                            {
                                NSLog(@"eof");
                            }];
                       }
                   });
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

*/
@end
