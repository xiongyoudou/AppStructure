//
//  UIApplication-Permissions.m
//  UIApplication-Permissions Sample
//
//  Created by Jack Rostron on 12/01/2014.
//  Copyright (c) 2014 Rostron. All rights reserved.
//

#import "UIApplication+XYDPermissions.h"
#import <objc/runtime.h>

//Import required frameworks
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import <EventKit/EventKit.h>

typedef void (^JKLocationSuccessCallback)();
typedef void (^JKLocationFailureCallback)();

static char JKPermissionsLocationManagerPropertyKey;
static char JKPermissionsLocationBlockSuccessPropertyKey;
static char JKPermissionsLocationBlockFailurePropertyKey;

@interface UIApplication () <CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *xyd_permissionsLocationManager;
@property (nonatomic, copy) JKLocationSuccessCallback xyd_locationSuccessCallbackProperty;
@property (nonatomic, copy) JKLocationFailureCallback xyd_locationFailureCallbackProperty;
@end


@implementation UIApplication (Permissions)


#pragma mark - Check permissions
-(XYDPermissionAccess)hasAccessToBluetoothLE {
    switch ([[[CBCentralManager alloc] init] state]) {
        case CBCentralManagerStateUnsupported:
            return JKPermissionAccessUnsupported;
            break;
            
        case CBCentralManagerStateUnauthorized:
            return JKPermissionAccessDenied;
            break;
            
        default:
            return JKPermissionAccessGranted;
            break;
    }
}

-(XYDPermissionAccess)hasAccessToCalendar {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent]) {
        case EKAuthorizationStatusAuthorized:
            return JKPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return JKPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return JKPermissionAccessRestricted;
            break;
            
        default:
            return JKPermissionAccessUnknown;
            break;
    }
}

-(XYDPermissionAccess)hasAccessToContacts {
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusAuthorized:
            return JKPermissionAccessGranted;
            break;
            
        case kABAuthorizationStatusDenied:
            return JKPermissionAccessDenied;
            break;
            
        case kABAuthorizationStatusRestricted:
            return JKPermissionAccessRestricted;
            break;
            
        default:
            return JKPermissionAccessUnknown;
            break;
    }
}

-(XYDPermissionAccess)hasAccessToLocation {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorized:
            return JKPermissionAccessGranted;
            break;
            
        case kCLAuthorizationStatusDenied:
            return JKPermissionAccessDenied;
            break;
            
        case kCLAuthorizationStatusRestricted:
            return JKPermissionAccessRestricted;
            break;
            
        default:
            return JKPermissionAccessUnknown;
            break;
    }
    return JKPermissionAccessUnknown;
}

-(XYDPermissionAccess)hasAccessToPhotos {
    switch ([ALAssetsLibrary authorizationStatus]) {
        case ALAuthorizationStatusAuthorized:
            return JKPermissionAccessGranted;
            break;
            
        case ALAuthorizationStatusDenied:
            return JKPermissionAccessDenied;
            break;
            
        case ALAuthorizationStatusRestricted:
            return JKPermissionAccessRestricted;
            break;
            
        default:
            return JKPermissionAccessUnknown;
            break;
    }
}

-(XYDPermissionAccess)hasAccessToReminders {
    switch ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder]) {
        case EKAuthorizationStatusAuthorized:
            return JKPermissionAccessGranted;
            break;
            
        case EKAuthorizationStatusDenied:
            return JKPermissionAccessDenied;
            break;
            
        case EKAuthorizationStatusRestricted:
            return JKPermissionAccessRestricted;
            break;
            
        default:
            return JKPermissionAccessUnknown;
            break;
    }
    return JKPermissionAccessUnknown;
}


#pragma mark - Request permissions
-(void)xyd_requestAccessToCalendarWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)xyd_requestAccessToContactsWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if(addressBook) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    accessGranted();
                } else {
                    accessDenied();
                }
            });
        });
    }
}

-(void)xyd_requestAccessToMicrophoneWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}

-(void)xyd_requestAccessToMotionWithSuccess:(void(^)())accessGranted {
    CMMotionActivityManager *motionManager = [[CMMotionActivityManager alloc] init];
    NSOperationQueue *motionQueue = [[NSOperationQueue alloc] init];
    [motionManager startActivityUpdatesToQueue:motionQueue withHandler:^(CMMotionActivity *activity) {
        accessGranted();
        [motionManager stopActivityUpdates];
    }];
}

-(void)xyd_requestAccessToPhotosWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        accessGranted();
    } failureBlock:^(NSError *error) {
        accessDenied();
    }];
}

-(void)xyd_requestAccessToRemindersWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                accessGranted();
            } else {
                accessDenied();
            }
        });
    }];
}


#pragma mark - Needs investigating
/*
 -(void)requestAccessToBluetoothLEWithSuccess:(void(^)())accessGranted {
 //REQUIRES DELEGATE - NEEDS RETHINKING
 }
 */

-(void)xyd_requestAccessToLocationWithSuccess:(void(^)())accessGranted andFailure:(void(^)())accessDenied {
    self.xyd_permissionsLocationManager = [[CLLocationManager alloc] init];
    self.xyd_permissionsLocationManager.delegate = self;
    
    self.xyd_locationSuccessCallbackProperty = accessGranted;
    self.xyd_locationFailureCallbackProperty = accessDenied;
    [self.xyd_permissionsLocationManager startUpdatingLocation];
}


#pragma mark - Location manager injection
-(CLLocationManager *)xyd_permissionsLocationManager {
    return objc_getAssociatedObject(self, &JKPermissionsLocationManagerPropertyKey);
}

-(void)setxyd_permissionsLocationManager:(CLLocationManager *)manager {
    objc_setAssociatedObject(self, &JKPermissionsLocationManagerPropertyKey, manager, OBJC_ASSOCIATION_RETAIN);
}

-(XYDLocationSuccessCallback)locationSuccessCallbackProperty {
    return objc_getAssociatedObject(self, &JKPermissionsLocationBlockSuccessPropertyKey);
}

-(void)setxyd_locationSuccessCallbackProperty:(XYDLocationSuccessCallback)locationCallbackProperty {
    objc_setAssociatedObject(self, &JKPermissionsLocationBlockSuccessPropertyKey, locationCallbackProperty, OBJC_ASSOCIATION_COPY);
}

-(XYDLocationFailureCallback)locationFailureCallbackProperty {
    return objc_getAssociatedObject(self, &JKPermissionsLocationBlockFailurePropertyKey);
}

-(void)setxyd_locationFailureCallbackProperty:(XYDLocationFailureCallback)locationFailureCallbackProperty {
    objc_setAssociatedObject(self, &JKPermissionsLocationBlockFailurePropertyKey, locationFailureCallbackProperty, OBJC_ASSOCIATION_COPY);
}


#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorized) {
        self.locationSuccessCallbackProperty();
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        self.locationFailureCallbackProperty();
    }
}

@end
