//
//  UIInstapaperActivity.m
//  InstapaperActivity
//
//  Created by Justin Ridgewell on 2/27/13.
//
//

#import "UIInstapaperActivity.h"
#import "InstapaperActivityRequest.h"

@interface UIInstapaperActivity ()

@property (strong, nonatomic) NSMutableArray *activityItems;
@property (strong, nonatomic) InstapaperActivityRequest *request;
- (ZYInstapaperActivityItem *)canPerformWithActivityItem:(id)item;

@end


@implementation UIInstapaperActivity

+ (instancetype)instance {
    static dispatch_once_t pred = 0;
    __strong static id _instance = nil;
    
    dispatch_once(&pred, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (NSString *)activityType {
	return @"UIInstapaperActivity.InstapaperActivity";
}

- (NSString *)activityTitle {
	return NSLocalizedString(@"Read Later", @"");
}

- (UIImage *)activityImage {
	UIUserInterfaceIdiom idiom = UI_USER_INTERFACE_IDIOM();
    UIImage *image = nil;
    
	switch (idiom) {
		case UIUserInterfaceIdiomPad:
			DLog(@"%s", "ipad");
			image = [UIImage imageNamed:@"InstapaperActivityIcon~iPad.png" fromDirectory:@"/System/Library/CoreServices/SpringBoard.app/"];
			break;
		case UIUserInterfaceIdiomPhone:
			DLog(@"%s", "iphone");
			image = [UIImage imageNamed:@"InstapaperActivityIcon~iPhone.png" fromDirectory:@"/System/Library/CoreServices/SpringBoard.app/"];
			break;
		default:
			DLog(@"Error loading idiom in InstapaperActivity");
			break;
	}
    
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
	__block BOOL canPerform = NO;
	[activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self canPerformWithActivityItem:obj]) {
            canPerform = YES;
            *stop = YES;
        }
    }];
	
	DLog("%i", canPerform);
	return canPerform;
}

- (ZYInstapaperActivityItem *)canPerformWithActivityItem:(id)item {
	ZYInstapaperActivityItem *activityItem = nil;
	
	//If it's an InstapaperActivityItem (internal, non-empty URL is guaranteed).
	if ([item isKindOfClass:[ZYInstapaperActivityItem class]] == YES) {
		activityItem = item;
	}
	//If it's a non-empty URL.
	else if ([item isKindOfClass:[NSURL class]] == YES) {
#if __has_feature(objc_arc)
		activityItem = [[ZYInstapaperActivityItem alloc] initWithURL:item];
#else
		activityItem = [[[ZYInstapaperActivityItem alloc] initWithURL:item] autorelease];
#endif
	}
	//If it's a well formated URL string.
	else if ([item isKindOfClass:[NSString class]] == YES) {
		NSURL *url = [NSURL URLWithString:item];
		if (url) {
#if __has_feature(objc_arc)
			activityItem = [[ZYInstapaperActivityItem alloc] initWithURL:item];
#else
			activityItem = [[[ZYInstapaperActivityItem alloc] initWithURL:item] autorelease];
#endif
		}
	}
	
	DLog(@"%@", activityItem);
	return activityItem;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
	if (!self.activityItems) {
		self.activityItems = [NSMutableArray array];
	}
	[activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		ZYInstapaperActivityItem *item = [self canPerformWithActivityItem:obj];
        if (item) {
            [self.activityItems addObject:item];
        }
    }];
	DLog(@"%@", self.activityItems);
}

- (void)performActivity {

	[self.activityItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		ZYInstapaperActivityItem *item = (ZYInstapaperActivityItem *)obj;
		DLog(@"%@", item);
		self.request = [[InstapaperActivityRequest alloc] initWithItem:item username:self.username password:self.password delegate:self];
    }];
}

#pragma mark - Protocols
#pragma mark ZYInstapaperAddRequestDelegate

- (void)instapaperAddRequestSucceded:(id)request {
	DLog();
#if !__has_feature(objc_arc)
	[self.request release];
#endif
	[self activityDidFinish:YES];
}

- (void)instapaperAddRequestFailed:(id)request {
	DLog();
#if !__has_feature(objc_arc)
	[self.request release];
#endif
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failure", @"")
													message:NSLocalizedString(@"An unexpected error occured. Try again later.", @"")
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"OK", @"")
										  otherButtonTitles:nil];
	[alert show];
#if !__has_feature(objc_arc)
	[alert release];
#endif
	[self activityDidFinish:NO];
}

- (void)instapaperAddRequestIncorrectPassword:(id)request {
	DLog();
#if !__has_feature(objc_arc)
	[self.request release];
#endif
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
													message:NSLocalizedString(@"Incorrect password. Please correct in Settings.app", @"")
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"OK", @"")
										  otherButtonTitles:nil];
	[alert show];
#if !__has_feature(objc_arc)
	[alert release];
#endif
	[self activityDidFinish:NO];
}


@end
