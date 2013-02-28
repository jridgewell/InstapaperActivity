#import <UIKit/UIKit.h>
#import "UIInstapaperActivity.h"

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/name.ridgewell.InstapaperActivity.plist"
#define READING_LIST_ACTIVITY_TYPE @"com.apple.mobilesafari.activity.addToReadingList"

static BOOL instapaperActivityIsEnabled;
static NSString *instapaperUsername;
static NSString *instapaperPassword;

%hook UIActivityViewController
- (NSArray *)excludedActivityTypes {
	NSArray *originalExcludes = %orig;
	if (instapaperActivityIsEnabled) {
		NSMutableArray *excludes = [NSMutableArray arrayWithArray:originalExcludes];
		[excludes addObject:READING_LIST_ACTIVITY_TYPE];
		originalExcludes = [NSArray arrayWithArray:excludes];
	}
	return originalExcludes;
}

- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
	NSArray *activities = applicationActivities;
	if (instapaperActivityIsEnabled) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:applicationActivities];
		UIInstapaperActivity *instapaperActivity = [UIInstapaperActivity instance];
		instapaperActivity.username = instapaperUsername;
		instapaperActivity.password = instapaperPassword;
		[array addObject:instapaperActivity];
		activities = [NSArray arrayWithArray:array];
	}
	return %orig(activityItems, activities);
}
%end

#pragma mark - Settings

static void LoadSettings() {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_PATH];
	
	id enablePref = [dict objectForKey:@"enabled"];
	instapaperActivityIsEnabled = enablePref ? [enablePref boolValue] : YES;
	DLog(@"%i", instapaperActivityIsEnabled);

	if (instapaperActivityIsEnabled) {
		id usernamePref = [dict objectForKey:@"username"];
		id passwordPref = [dict objectForKey:@"password"];
		instapaperUsername = usernamePref ? usernamePref : @"";
		instapaperPassword = passwordPref ? passwordPref : @"";
		DLog(@"%@", instapaperUsername);
		DLog(@"%@", instapaperPassword);
	} else {
		instapaperUsername = nil;
		instapaperPassword = nil;
	}
}

static void SettingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	LoadSettings();
}

%ctor {
	@autoreleasepool {
		LoadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SettingsChanged, CFSTR("name.ridgewell.InstapaperActivity.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}