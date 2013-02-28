#line 1 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"
#import <UIKit/UIKit.h>
#import "UIInstapaperActivity.h"

#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/name.ridgewell.InstapaperActivity.plist"
#define READING_LIST_ACTIVITY_TYPE @"com.apple.mobilesafari.activity.addToReadingList"

static BOOL instapaperActivityIsEnabled;
static NSString *instapaperUsername;
static NSString *instapaperPassword;

#include <logos/logos.h>
#include <substrate.h>
@class UIActivityViewController; 
static NSArray * (*_logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes)(UIActivityViewController*, SEL); static NSArray * _logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes(UIActivityViewController*, SEL); static id (*_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$)(UIActivityViewController*, SEL, NSArray *, NSArray *); static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController*, SEL, NSArray *, NSArray *); 

#line 11 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"

static NSArray * _logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes(UIActivityViewController* self, SEL _cmd) {
	NSArray *originalExcludes = _logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes(self, _cmd);
	if (instapaperActivityIsEnabled) {
		NSMutableArray *excludes = [NSMutableArray arrayWithArray:originalExcludes];
		[excludes addObject:READING_LIST_ACTIVITY_TYPE];
		originalExcludes = [NSArray arrayWithArray:excludes];
	}
	return originalExcludes;
}

static id _logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(UIActivityViewController* self, SEL _cmd, NSArray * activityItems, NSArray * applicationActivities) {
	NSArray *activities = applicationActivities;
	if (instapaperActivityIsEnabled) {
		NSMutableArray *array = [NSMutableArray arrayWithArray:applicationActivities];
		UIInstapaperActivity *instapaperActivity = [UIInstapaperActivity instance];
		instapaperActivity.username = instapaperUsername;
		instapaperActivity.password = instapaperPassword;
		[array addObject:instapaperActivity];
		activities = [NSArray arrayWithArray:array];
	}
	return _logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$(self, _cmd, activityItems, activities);
}


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

static __attribute__((constructor)) void _logosLocalCtor_9f2e78ec() {
	@autoreleasepool {
		LoadSettings();
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, SettingsChanged, CFSTR("name.ridgewell.InstapaperActivity.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$UIActivityViewController = objc_getClass("UIActivityViewController"); MSHookMessageEx(_logos_class$_ungrouped$UIActivityViewController, @selector(excludedActivityTypes), (IMP)&_logos_method$_ungrouped$UIActivityViewController$excludedActivityTypes, (IMP*)&_logos_orig$_ungrouped$UIActivityViewController$excludedActivityTypes);MSHookMessageEx(_logos_class$_ungrouped$UIActivityViewController, @selector(initWithActivityItems:applicationActivities:), (IMP)&_logos_method$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$, (IMP*)&_logos_orig$_ungrouped$UIActivityViewController$initWithActivityItems$applicationActivities$);} }
#line 68 "/Users/ridgewell/src/jridgewell/InstapaperActivity/InstapaperActivity/InstapaperActivity.xm"
