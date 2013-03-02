#import <UIKit/UIKit.h>
#import "RWInstapaperActivity.h"

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/"
#define PREFERENCES_FILE PREFERENCES_PATH APP_ID @".plist"
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
		originalExcludes = excludes;
	}
	return originalExcludes;
}

- (id)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray *)applicationActivities {
	NSArray *activities = applicationActivities;
	if (instapaperActivityIsEnabled) {
		RWInstapaperActivity *instapaperActivity = [RWInstapaperActivity instance];
		activities = [activities arrayByAddingObject:instapaperActivity];
	}
	return %orig(activityItems, activities);
}
%end

#pragma mark - Settings

static void updateInstapaperCredentials() {
	RWInstapaperActivity *instapaperActivity = [RWInstapaperActivity instance];
	instapaperActivity.username = instapaperUsername;
	instapaperActivity.password = instapaperPassword;
}

static void LoadSettings() {
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREFERENCES_FILE];
	
	id enablePref = [dict objectForKey:@"enabled"];
	instapaperActivityIsEnabled = enablePref ? [enablePref boolValue] : YES;
	DLog(@"%i", instapaperActivityIsEnabled);

	if (instapaperActivityIsEnabled) {
		id usernamePref = [dict objectForKey:@"username"];
		id passwordPref = [dict objectForKey:@"password"];
		instapaperUsername = usernamePref ? usernamePref : @"";
		instapaperPassword = passwordPref ? passwordPref : @"";
		updateInstapaperCredentials();
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
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SettingsChanged, CFSTR("APP_ID.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}