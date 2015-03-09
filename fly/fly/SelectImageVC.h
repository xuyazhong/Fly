//
//  SelectImageVC.h
//  fly
//
//  Created by xyz on 15-3-9.
//  Copyright (c) 2015年 xuyazhong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectImageBlock)(NSData *image);
typedef void(^notSelectBlock)(NSString *str);

@interface SelectImageVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

-(void)requestImageSuccess:(selectImageBlock)selBlock failed:(notSelectBlock)notSelBlock;

//@property (nonatomic,copy)selectImageBlock selBlock;
//@property (nonatomic,copy)notSelectBlock   notSelBlock;

@end
