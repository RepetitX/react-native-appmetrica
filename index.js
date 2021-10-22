/*
 * Version for React Native
 * © 2020 YANDEX
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * https://yandex.com/legal/appmetrica_sdk_agreement/
 */

import { NativeModules, Platform } from 'react-native';

const { AppMetrica } = NativeModules;

type AppMetricaConfig = {
    apiKey: string,
    appVersion?: string,
    crashReporting?: boolean,
    firstActivationAsUpdate?: boolean,
    location: Location,
    locationTracking?: boolean,
    logs?: boolean,
    sessionTimeout?: number,
    statisticsSending?: boolean,
    preloadInfo?: PreloadInfo,
    // Only Android
    installedAppCollecting?: boolean,
    maxReportsInDatabaseCount?: number,
    nativeCrashReporting?: boolean,
    // Only iOS
    activationAsSessionStart?: boolean,
    sessionsAutoTracking?: boolean,
}

type PreloadInfo = {
    trackingId: string,
    additionalInfo?: Object,
}

type Location = {
    latitude: number,
    longitude: number,
    altitude?: number,
    accuracy?: number,
    course?: number,
    speed?: number,
    timestamp?: number
}

type AppMetricaDeviceIdReason = 'UNKNOWN' | 'NETWORK' | 'INVALID_RESPONSE';

export default {

    activate(config: AppMetricaConfig) {
        AppMetrica.activate(config);
    },

    // Android
    async getLibraryApiLevel(): number {
        return AppMetrica.getLibraryApiLevel();
    },

    async getLibraryVersion(): string {
        return AppMetrica.getLibraryVersion();
    },

    pauseSession() {
        AppMetrica.pauseSession();
    },

    reportAppOpen(deeplink: ?string = null) {
        AppMetrica.reportAppOpen(deeplink);
    },

    reportError(id: string, message: string, details: Object) {
        AppMetrica.reportError(id, message, JSON.stringify(details));
    },

    reportEvent(eventName: string, attributes: ?Object = null) {
        AppMetrica.reportEvent(eventName, attributes);
    },

    reportUserProfileCustomAttributes(customAttributes) {
        if (Platform.OS === 'ios') {
            const preparedAttributes = [];

            for (let key in customAttributes) {
                const type = typeof customAttributes[key];

                if (type !== 'number' && type !== 'boolean' && type !== 'string') continue;

                preparedAttributes.push({
                    key,
                    type,
                    value: customAttributes[key]
                })
            }

            if (preparedAttributes.length) {
                AppMetrica.reportUserProfileCustomAttributes(preparedAttributes);
            }
        } else {
            AppMetrica.reportUserProfileCustomAttributes(customAttributes);
        }
    },

    reportUserProfileNotificationsEnabled(state) {
        AppMetrica.reportUserProfileNotificationsEnabled(state);
    },

    reportReferralUrl(referralUrl: string) {
        AppMetrica.reportReferralUrl(referralUrl);
    },

    requestAppMetricaDeviceID(listener: (deviceId?: String, reason?: AppMetricaDeviceIdReason) => void) {
        AppMetrica.requestAppMetricaDeviceID(listener);
    },

    resumeSession() {
        AppMetrica.resumeSession();
    },

    sendEventsBuffer() {
        AppMetrica.sendEventsBuffer();
    },

    setLocation(location: ?Location) {
        AppMetrica.setLocation(location);
    },

    setLocationTracking(enabled: boolean) {
        AppMetrica.setLocationTracking(enabled);
    },

    setStatisticsSending(enabled: boolean) {
        AppMetrica.setStatisticsSending(enabled);
    },

    setUserProfileID(userProfileID?: string) {
        AppMetrica.setUserProfileID(userProfileID);
    },
};
