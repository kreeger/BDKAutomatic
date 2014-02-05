@import MapKit;

@interface MKPolyline (BDKEncodedString)

+ (MKPolyline *)polylineWithEncodedString:(NSString *)encodedString;

@end