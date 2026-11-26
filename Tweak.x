static BOOL looksLikeAd(NSString *cls) {
    static NSArray *keys;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        keys = @[@"GAD", @"MAAd", @"FBAd", @"UnityAds", @"IronSource", @"LevelPlay",
                 @"PAG", @"MTG", @"Vungle", @"AdView", @"AdBanner", @"AdOverlay",
                 @"AdContainer", @"AdMrec", @"Banner"];
    });
    NSString *n = cls.lowercaseString;
    for (NSString *k in keys)
        if ([n containsString:k.lowercaseString]) return YES;
    return NO;
}

%hook UIWindow
- (void)addSubview:(UIView *)view {
    if (looksLikeAd(NSStringFromClass(view.class))) return;
    %orig;
}
%end

%hook UIViewController
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)a completion:(void (^)(void))c {
    if (looksLikeAd(NSStringFromClass(vc.class))) {
        if (c) c();
        return;
    }
    %orig;
}
%end