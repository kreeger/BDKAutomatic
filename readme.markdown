# NLAutomatic

[![Version](http://cocoapod-badges.herokuapp.com/v/NLAutomatic/badge.png)](http://cocoadocs.org/docsets/NLAutomatic)
[![Platform](http://cocoapod-badges.herokuapp.com/p/NLAutomatic/badge.png)](http://cocoadocs.org/docsets/NLAutomatic)

## Overview

A library, along with a sample project, that demonstrates some basic usage of the [Automatic REST API][rest]. Right now, the library does the following:

- Downloads and parses trip data
- Downloads and parses trip's vehicle and location ('terminus') data
- Parses trip paths to `MKPolyline` object (separate subspec included)

Sweet GIF action:

![In action](https://raw.github.com/nelsonleduc/NLAutomatic/master/Project/NLAutomaticDemo.gif)

## Usage

Just include `#import <NLAutomatic/NLAutomatic.h>` at the top of whatever Objective-C thing you're doing, and fire away.

``` objective-c
NLAutomatic *adapter = [[NLAutomatic alloc] initWithClientId:clientId
                                                  clientSecret:clientSecret
                                                   redirectUrl:redirectUrl];
```

You'll need to authenticate it against a user account using the OAuth2 dance. See `-[NLAuthViewController handleAutomaticAuthenticationQueryString:]` for usage examples. Once you trade your authorization code for a legitimate `NLAutomaticToken` (which conforms to `NSCopying`, by the way, so you can marshal that bad boy to Keychain or something), you can make calls on behalf of an Automatic user.

``` objective-c
[self.automatic getTrips:^(NSError *error, NSArray *trips) {
    NLAutomaticTrip *trip = [trips firstObject];
    NSLog(@"Trip started %@.", trip.startTime);
}];
```

If you want an `MKPolyline` out of `-[NLAutomaticTrip path]`, you'll want to include the separate `NLAutomatic/MKPolylineSupport` subspec in your `Podfile`, and use it like so.

``` objective-c
#import <NLAutomatic/MKPolyline+NLEncodedString.h>
...
MKPolyline *mapPath = [MKPolyline polylineWithEncodedString:trip.path];
[self.mapView addOverlay:mapPath level:MKOverlayLevelAboveRoads];
```

You get the idea. See `NLMapViewController.m` for more goodies.

## Example project setup

To run the example project; clone the repo, and run `pod install` from the Project directory first. Then, open `NLAutomatic.xcworkspace` in the Project directory.

You'll want to copy the secret PLIST file from `Project/Classes/NLAutomaticSecrets.plist.example` to `Project/Classes/NLAutomaticSecrets.plist` and fill it out with your Automatic API client ID and client secret.

## Installation

NLAutomatic is available through [CocoaPods](http://cocoapods.org), which is righteously awesome. To install it, simply add the following line to your Podfile.

``` ruby
pod 'NLAutomatic'
```

If you don't want to use the "path-to-`MKPolyline`" functionality, just use [the subspec for the adapter](https://github.com/nelsonleduc/NLAutomatic/blob/master/NLAutomatic.podspec#L14).

``` ruby
pod 'NLAutomatic/Adapter'
```

## Author

Ben Kreeger, ben@kree.gr

## License

NLAutomatic is available under the MIT license. See the LICENSE file for more info.

[rest]:    https://www.automatic.com/developer/
