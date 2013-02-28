Instapaper-Activity
===================

iOS UIActivity for reading later on Instapaper. Initially conceived to be used on one of my own projects: [Nyndoo](http://www.nyndoo.com) a page-per-tweet twitter client.

Feel free to add any request, bug or inquiry on the issues section!

Previews
========
![](https://raw.github.com/marianoabdala/ZYInstapaperActivity/master/Resources/Intro.PNG)
![](https://raw.github.com/marianoabdala/ZYInstapaperActivity/master/Resources/UIActivityViewController.PNG)
![](https://raw.github.com/marianoabdala/ZYInstapaperActivity/master/Resources/WithTheGang.PNG)
![](https://raw.github.com/marianoabdala/ZYInstapaperActivity/master/Resources/Credentials.PNG)
![](https://raw.github.com/marianoabdala/ZYInstapaperActivity/master/Resources/Adding.PNG)

Usage sample
============

    NSURL *url =
    [NSURL URLWithString:@"http://mariano.zerously.com/post/28497816299/fixed-quotes"];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[ url ]
                                      applicationActivities:@[ [ZYInstapaperActivity instance] ]];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];


**With some extra options**

    NSURL *url =
    [NSURL URLWithString:@"http://mariano.zerously.com/post/28497816299/fixed-quotes"];
    
    ZYInstapaperActivityItem *item =
    [[ZYInstapaperActivityItem alloc] initWithURL:textFieldURL];
    
    item.title = @"Fixed quotes";
    item.description = @"Saved using @Nyndoo.";
    
    NSArray *activityItems =
    @[ item ];
    
    NSArray *applicationActivities =
    @[ [ZYInstapaperActivity instance] ];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                      applicationActivities:applicationActivities];
    
    //Show only Instapaper Activity.
    activityViewController.excludedActivityTypes =
    @[  UIActivityTypePostToFacebook,
        UIActivityTypePostToTwitter,
        UIActivityTypePostToWeibo,
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll  ];
    
    [self presentViewController:activityViewController
                       animated:YES
                     completion:nil];

How to install
==============

1. Drag the ZYInstapaperActivity folder into your own project.
2. Make sure the Security.framework is linked, if not link it.
3. Make sure you are not already using Apple's KeychainItemWrapper, if you are you'll have it duplicate. Choose one and delete the other.

Other referenced projects
=========================
* [KeychainItemWrapper ARCified](https://gist.github.com/1170641) by [David Hoerl](https://github.com/dhoerl)
* [ZYActivity](https://github.com/marianoabdala/ZYActivity) by [Mariano Abdala](https://github.com/marianoabdala)
* [ZYTopAlignedLabel](https://github.com/marianoabdala/Zerously-toolkit) by [Mariano Abdala](https://github.com/marianoabdala)
