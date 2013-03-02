#line 1 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"
#import <UIKit/UIKit.h>
#import "RWInstapaperActivity.h"

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/"
#define PREFERENCES_FILE PREFERENCES_PATH APP_ID @".plist"
#define READING_LIST_ACTIVITY_TYPE @"com.apple.mobilesafari.activity.addToReadingList"

static BOOL instapaperActivityIsEnabled;
static NSString *instapaperUsername;
static NSString *instapaperPassword;

#include <logos/logos.h>
#include <substrate.h>
@class UIActivityViewController; 
static NSArray * (*_logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes)(UIActivityViewController*, SEL); static NSArray * _logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes(UIActivityViewController*, SEL); static id (*_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$)(UIActivityViewController*, SEL, NSArray *, NSArray *); static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController*, SEL, NSArray *, NSArray *); 

#line 12 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"

static NSArray * _logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes(UIActivityViewController* self, SEL _cmd) {
	NSArray *originalExcludes = _logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes(self, _cmd);
	if (instapaperActivityIsEnabled) {
		NSMutableArray *excludes = [NSMutableArray arrayWithArray:originalExcludes];
		[excludes addObject:READING_LIST_ACTIVITY_TYPE];
		originalExcludes = excludes;
	}
	return originalExcludes;
}

static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController* self, SEL _cmd, NSArray * activityItems, NSArray * applicationActivities) {
	NSArray *activities = applicationActivities;
	if (instapaperActivityIsEnabled) {
		RWInstapaperActivity *instapaperActivity = [RWInstapaperActivity instance];
		activities = [activities arrayByAddingObject:instapaperActivity];
	}
	return _logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(self, _cmd, activityItems, activities);
}


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

static __attribute__((constructor)) void _logosLocalCtor_4bc127fe() {
	@autoreleasepool {
		LoadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SettingsChanged, CFSTR("APP_ID.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIActivityViewController = objc_getClass("UIActivityViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIActivityViewController, @selector(excludedActivityTypes), (IMP)&_logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes, (IMP*)&_logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes);MSHookMessageEx(_logos_class$_ungrouped$UIActivityViewController, @selector(initWithActivityItems:applicationActivities:), (IMP)&_logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$, (IMP*)&_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$);} }
#line 70 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"
