//
//  UIImage+ImageNamedExtension.h
//  InstapaperActivity
//
//  Created by Justin Ridgewell on 2/27/13.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageNamedExtension)

+ (UIImage *)imageNamed:(NSString *)name fromDirectory:(NSString *)directory;

@end
