//
//  XYDGeoPoint.h
//  LeanCloud
//


#import <Foundation/Foundation.h>

@class CLLocation;

NS_ASSUME_NONNULL_BEGIN

/*!
 Object which may be used to embed a latitude / longitude point as the value for a key in a XYDObject.
 XYDObjects with a XYDGeoPoint field may be queried in a geospatial manner using XYDQuery's whereKey:nearGeoPoint:.
 
 This is also used as a point specifier for whereKey:nearGeoPoint: queries.
 
 Currently, object classes may only have one key associated with a GeoPoint type.
 */

@interface XYDGeoPoint : NSObject<NSCopying>

/** @name Creating a XYDGeoPoint */
/*!
 Create a XYDGeoPoint object.  Latitude and longitude are set to 0.0.
 @return a new XYDGeoPoint.
 */
+ (instancetype)geoPoint;

/*!
 Creates a new XYDGeoPoint object for the given CLLocation, set to the location's
 coordinates.
 @param location CLLocation object, with set latitude and longitude.
 @return a new XYDGeoPoint at specified location.
 */
+ (instancetype)geoPointWithLocation:(CLLocation *)location;

/*!
 Creates a new XYDGeoPoint object with the specified latitude and longitude.
 @param latitude Latitude of point in degrees.
 @param longitude Longitude of point in degrees.
 @return New point object with specified latitude and longitude.
 */
+ (instancetype)geoPointWithLatitude:(double)latitude longitude:(double)longitude;

#if XYD_IOS_ONLY
/*!
 Fetches the user's current location and returns a new XYDGeoPoint object via the
 provided block.
 @param geoPointHandler A block which takes the newly created XYDGeoPoint as an
 argument.
 */
+ (void)geoPointForCurrentLocationInBackground:(void(^)(AVGeoPoint * _Nullable geoPoint, NSError * _Nullable error))geoPointHandler;
#endif

/** @name Controlling Position */

/// Latitude of point in degrees.  Valid range (-90.0, 90.0).
@property (nonatomic) double latitude;
/// Longitude of point in degrees.  Valid range (-180.0, 180.0).
@property (nonatomic) double longitude;

/** @name Calculating Distance */

/*!
 Get distance in radians from this point to specified point.
 @param point XYDGeoPoint location of other point.
 @return distance in radians
 */
- (double)distanceInRadiansTo:(AVGeoPoint*)point;

/*!
 Get distance in miles from this point to specified point.
 @param point XYDGeoPoint location of other point.
 @return distance in miles
 */
- (double)distanceInMilesTo:(AVGeoPoint*)point;

/*!
 Get distance in kilometers from this point to specified point.
 @param point XYDGeoPoint location of other point.
 @return distance in kilometers
 */
- (double)distanceInKilometersTo:(AVGeoPoint*)point;

+(NSDictionary *)dictionaryFromGeoPoint:(AVGeoPoint *)point;
+(AVGeoPoint *)geoPointFromDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
