//
//  RWInstapaperActivityRequest.m
//  InstapaperActivity
//
//  Created by Justin Ridgewell on 2/28/13.
//
//

#import "RWInstapaperActivityRequest.h"
#import "ZYInstapaperActivityItem.h"
#import "NSData+Base64.h"

#define RESPONSE_SUCCESS            @"201"
#define RESPONSE_PASSWORD_INCORRECT @"403"

@interface RWInstapaperActivityRequest ()
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseMutableData;
@property (assign, nonatomic) id<ZYInstapaperAddRequestDelegate> delegate;

- (void)startRequestWithItem:(ZYInstapaperActivityItem *)item;
@end

@implementation RWInstapaperActivityRequest

- (id)initWithItem:(ZYInstapaperActivityItem *)item username:(NSString *)username password:(NSString *)password delegate:(id<ZYInstapaperAddRequestDelegate>)delegate {
    if (item == nil) {
        return nil;
    }
    
    if (self = [super init]) {
		self.username = username;
		self.password = password;
		self.delegate = delegate;
		[self startRequestWithItem:item];
    }
    
    return self;
}

- (void)cancel {
    [self.connection cancel];
}

- (void)startRequestWithItem:(ZYInstapaperActivityItem *)item {
	NSString *urlString = [NSString stringWithFormat:
							@"https://www.instapaper.com/api/add"
							"?url=%@"
							"&title=%@"
							"&selection=%@",
							item.url,
							item.title,
						   item.description];

	NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
	NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
	NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];

	
	DLog(@"%@", urlString);
	NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	DLog(@"%@", url);
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
	[urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
	DLog(@"%@", urlRequest);
	NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
	DLog(@"%@", urlConnection);
	
	if (urlConnection != nil) {
		self.responseMutableData = [NSMutableData data];
		[urlConnection start];
	}
}


#pragma mark - Protocols
#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	DLog();
    [self.responseMutableData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	DLog();
    [self.responseMutableData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	DLog();
    self.responseMutableData    = nil;
    self.connection             = nil;
    
    DLog(@"Request for adding to instapaper failed.");
	
    [self.delegate instapaperAddRequestFailed:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	DLog();
    NSString *responseString = [[NSString alloc] initWithData:self.responseMutableData encoding:NSUTF8StringEncoding];
	DLog(@"%@", responseString);
    self.responseMutableData    = nil;
    self.connection             = nil;
	
    if ([responseString compare:RESPONSE_SUCCESS] == NSOrderedSame) {
        [self.delegate instapaperAddRequestSucceded:self];
    } else if ([responseString compare:RESPONSE_PASSWORD_INCORRECT] == NSOrderedSame) {
        [self.delegate instapaperAddRequestIncorrectPassword:self];
    } else {
        [self.delegate instapaperAddRequestFailed:self];
    }
}

@end
