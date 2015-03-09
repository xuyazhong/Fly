//
//  SelectImageVC.m
//  fly
//
//  Created by xyz on 15-3-9.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import "SelectImageVC.h"

@interface SelectImageVC ()
{
    selectImageBlock _finishedBlock;
    notSelectBlock _failedBlock;
}
@end

@implementation SelectImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIButton *sucessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sucessBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [sucessBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [sucessBtn setFrame:CGRectMake(0, 0, 60, 20)];
//    [sucessBtn addTarget:self action:@selector(sucessBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:sucessBtn];
//    self.navigationItem.rightBarButtonItem = item;
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
    }];
    // Do any additional setup after loading the view.
}
-(void)sucessBtnAction
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - image delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"info:%@",info);
//    _sendText(_myTextField.text);
//    [self.navigationController popViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
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
    }];
}

@end
