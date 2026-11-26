#import <UIKit/UIKit.h>

static BOOL looksLikeAd(NSString *cls) {
    if (!cls) return NO;
    static NSArray<NSString *> *keys;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        keys = @[@"gad", @"maad", @"fbad", @"unityads", @"ironsource", @"levelplay",
                 @"pag", @"mtg", @"vungle", @"adview", @"adbanner", @"adoverlay",
                 @"adcontainer", @"admrec"];
    });
    NSString *n = cls.lowercaseString;
    for (NSString *k in keys) {
        if ([n containsString:k]) return YES;
    }
    return NO;
}

%hook UIView
- (void)didMoveToWindow {
    %orig;
    if (self.window && looksLikeAd(NSStringFromClass(self.class))) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}
%end

%hook UIViewController
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)a completion:(void (^)(void))c {
    if (vc && looksLikeAd(NSStringFromClass(vc.class))) {
        if (c) c();
        return;
    }
    %orig;
}
%end
