//
//  XYDGeoPoint.h
//  LeanCloud
//


#import "XYDGeoPoint.h"
#import "XYDLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@implementation  XYDGeoPoint

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)copyWithZone:(NSZone *)zone
{
    XYDGeoPoint *point = [[[self class] allocWithZone:zone] init];
    point.longitude = self.longitude;
    point.latitude = self.latitude;
    return point;
}

+ (XYDGeoPoint *)geoPoint
{
    XYDGeoPoint * result = [[XYDGeoPoint alloc] init];
    return result;
}

+ (XYDGeoPoint *)geoPointWithLocation:(CLLocation *)location
{
    XYDGeoPoint * point = [XYDGeoPoint geoPoint];
    point.latitude = location.coordinate.latitude;
    point.longitude = location.coordinate.longitude;
    return point;
}

+ (XYDGeoPoint *)geoPointWithLatitude:(double)latitude longitude:(double)longitude
{
    XYDGeoPoint * point = [XYDGeoPoint geoPoint];
    point.latitude = latitude;
    point.longitude = longitude;
    return point;
}

- (CLLocation *)location {
    return [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
}

#if XYD_IOS_ONLY
+ (void)geoPointForCurrentLocationInBackground:(void(^)(XYDGeoPoint *geoPoint, NSError *error))geoPointHandler
{
    [[AVLocationManager sharedInstance] updateWithBlock:geoPointHandler];
}
#endif

- (double)distanceInRadiansTo:(XYDGeoPoint*)point
{
    // 6378.140 is the Radius of the earth 
    return ([self distanceInKilometersTo:point] / 6378.140);
}

- (double)distanceInMilesTo:(XYDGeoPoint*)point
{
    return [self distanceInKilometersTo:point] / 1.609344;
}

- (double)distanceInKilometersTo:(XYDGeoPoint*)point
{
    return [[self location] distanceFromLocation:[point location]] / 1000.0;
}

+(NSDictionary *)dictionaryFromGeoPoint:(XYDGeoPoint *)point
{
    return @{ @"__type": @"GeoPoint", @"latitude": @(point.latitude), @"longitude": @(point.longitude) };
}

+(XYDGeoPoint *)geoPointFromDictionary:(NSDictionary *)dict
{
    XYDGeoPoint * point = [[XYDGeoPoint alloc]init];
    point.latitude = [[dict objectForKey:@"latitude"] doubleValue];
    point.longitude = [[dict objectForKey:@"longitude"] doubleValue];
    return point;
}

@end
