@import MapKit;

@interface MKPolyline (BDKEncodedString)

/**
 Praise be to http://stackoverflow.com/a/9219856/194869
 */
+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString;

@end