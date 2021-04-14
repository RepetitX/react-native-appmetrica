/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

#import "AppMetrica.h"
#import "AppMetricaUtils.h"

static NSString *const kYMMReactNativeExceptionName = @"ReactNativeException";

@implementation AppMetrica

@synthesize methodQueue = _methodQueue;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(activate:(NSDictionary *)configDict)
{
    [YMMYandexMetrica activateWithConfiguration:[AppMetricaUtils configurationForDictionary:configDict]];
}

RCT_EXPORT_METHOD(getLibraryApiLevel)
{
    // It does nothing for iOS
}

RCT_EXPORT_METHOD(getLibraryVersion:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    resolve([YMMYandexMetrica libraryVersion]);
}

RCT_EXPORT_METHOD(pauseSession)
{
    [YMMYandexMetrica pauseSession];
}

RCT_EXPORT_METHOD(reportAppOpen:(NSString *)deeplink)
{
    [YMMYandexMetrica handleOpenURL:[NSURL URLWithString:deeplink]];
}

RCT_EXPORT_METHOD(reportError:(NSString *)message) {
    NSException *exception = [[NSException alloc] initWithName:message reason:nil userInfo:nil];
    [YMMYandexMetrica reportError:message exception:exception onFailure:NULL];
}

RCT_EXPORT_METHOD(reportEvent:(NSString *)eventName:(NSDictionary *)attributes)
{
    if (attributes == nil) {
        [YMMYandexMetrica reportEvent:eventName onFailure:^(NSError *error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }];
    } else {
        [YMMYandexMetrica reportEvent:eventName parameters:attributes onFailure:^(NSError *error) {
            NSLog(@"error: %@", [error localizedDescription]);
        }];
    }
}

RCT_EXPORT_METHOD(reportUserProfileNotificationsEnabled:(BOOL) state)
{
    YMMMutableUserProfile *profile = [[YMMMutableUserProfile alloc] init];
    id<YMMNotificationsEnabledAttribute> attribute = [YMMProfileAttribute notificationsEnabled];
    [profile apply:[attribute withValue:state]];
    
    [YMMYandexMetrica reportUserProfile:[profile copy] onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

RCT_EXPORT_METHOD(reportUserProfileCustomAttributes:(NSArray *)attributes)
{
    YMMMutableUserProfile *profile = [[YMMMutableUserProfile alloc] init];
    
    for (NSDictionary *property in attributes) {
        NSString *key = [property valueForKey:@"key"];
        
        if ([[property valueForKey:@"type"] isEqualToString:@"number"]) {
            double value = [[property objectForKey:@"value"] doubleValue];
            id<YMMCustomNumberAttribute> attribute = [YMMProfileAttribute customNumber:key];
            [profile apply:[attribute withValue:value]];
        } else if ([[property valueForKey:@"type"] isEqualToString:@"boolean"]) {
            BOOL value = [[property objectForKey:@"value"] boolValue];
            id<YMMCustomBoolAttribute> attribute = [YMMProfileAttribute customBool:key];
            [profile apply:[attribute withValue:value]];
        } else if ([[property valueForKey:@"type"] isEqualToString:@"string"]) {
            NSString *value = [[property objectForKey:@"value"] stringValue];
            id<YMMCustomStringAttribute> attribute = [YMMProfileAttribute customString:key];
            [profile apply:[attribute withValue:value]];
        }
    }
    
    [YMMYandexMetrica reportUserProfile:[profile copy] onFailure:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

RCT_EXPORT_METHOD(reportReferralUrl:(NSString *)referralUrl)
{
    [YMMYandexMetrica reportReferralUrl:[NSURL URLWithString:referralUrl]];
}

RCT_EXPORT_METHOD(requestAppMetricaDeviceID:(RCTResponseSenderBlock)listener)
{
    YMMAppMetricaDeviceIDRetrievingBlock completionBlock = ^(NSString *_Nullable appMetricaDeviceID, NSError *_Nullable error) {
        listener(@[[self wrap:appMetricaDeviceID], [self wrap:[AppMetricaUtils stringFromRequestDeviceIDError:error]]]);
    };
    [YMMYandexMetrica requestAppMetricaDeviceIDWithCompletionQueue:nil completionBlock:completionBlock];
}

RCT_EXPORT_METHOD(resumeSession)
{
    [YMMYandexMetrica resumeSession];
}

RCT_EXPORT_METHOD(sendEventsBuffer)
{
    [YMMYandexMetrica sendEventsBuffer];
}

RCT_EXPORT_METHOD(setLocation:(NSDictionary *)locationDict)
{
    [YMMYandexMetrica setLocation:[AppMetricaUtils locationForDictionary:locationDict]];
}

RCT_EXPORT_METHOD(setLocationTracking:(BOOL)enabled)
{
    [YMMYandexMetrica setLocationTracking:enabled];
}

RCT_EXPORT_METHOD(setStatisticsSending:(BOOL)enabled)
{
    [YMMYandexMetrica setStatisticsSending:enabled];
}

RCT_EXPORT_METHOD(setUserProfileID:(NSString *)userProfileID)
{
    [YMMYandexMetrica setUserProfileID:userProfileID];
}

- (NSObject *)wrap:(NSObject *)value
{
    if (value == nil) {
        return [NSNull null];
    }
    return value;
}

@end