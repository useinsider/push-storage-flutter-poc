#import "NotificationService.h"
#import <InsiderMobileAdvancedNotification/InsiderPushNotification.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

// FIXME-INSIDER: Please change with your app group.
static NSString *APP_GROUP = @"group.com.useinsider.mobile-ios";

@implementation NotificationService

-(void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUP];
    NSMutableArray *savedNotifications = [[sharedDefaults arrayForKey:@"savedNotifications"] mutableCopy];

    if (!savedNotifications) {
        savedNotifications = [[NSMutableArray alloc] init];
    }

    NSDictionary *newNotification = request.content.userInfo;
    
    if (newNotification) {
        [savedNotifications addObject:newNotification];
    }

    [sharedDefaults setObject:savedNotifications forKey:@"savedNotifications"];
    [sharedDefaults synchronize];
    
    // MARK: You can customize these.
    NSString *nextButtonText = @">>";
    NSString *goToAppText = @"Launch App";
    
    [InsiderPushNotification showInsiderRichPush:request appGroup:APP_GROUP nextButtonText:nextButtonText goToAppText:goToAppText success:^(UNNotificationAttachment *attachment) {
        if (attachment) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attachment];
        }
        
        self.contentHandler(self.bestAttemptContent);
    }];
}

-(void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
