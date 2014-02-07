# BDKAutomatic

[![Version](http://cocoapod-badges.herokuapp.com/v/BDKAutomatic/badge.png)](http://cocoadocs.org/docsets/BDKAutomatic)
[![Platform](http://cocoapod-badges.herokuapp.com/p/BDKAutomatic/badge.png)](http://cocoadocs.org/docsets/BDKAutomatic)
[![Build Status](https://travis-ci.org/kreeger/BDKAutomatic.png?branch=master)](https://travis-ci.org/kreeger/BDKAutomatic)

## Overview

A library, along with a sample project, that demonstrates some basic usage of the [Automatic REST API][rest]. Right now, the library does the following:

- Downloads and parses trip data
- Downloads and parses trip's vehicle and location ('terminus') data
- Parses trip paths to `MKPolyline` object (separate subspec included)

Sweet GIF action:

![In action](https://raw.github.com/kreeger/BDKAutomatic/master/Project/BDKAutomaticDemo.gif)

## Usage

Just include `#import <BDKAutomatic/BDKAutomatic.h>` at the top of whatever Objective-C thing you're doing, and fire away.

``` objective-c
BDKAutomatic *adapter = [[BDKAutomatic alloc] initWithClientId:clientId
                                                 clientSecret:clientSecret
                                                  redirectUrl:redirectUrl];
```

You'll need to authenticate it against a user account using the OAuth2 dance. See `-[BDKAuthViewController handleAutomaticAuthenticationQueryString:]` for usage examples. Once you trade your authorization code for a legitimate `BDKAutomaticToken` (which conforms to `NSCopying`, by the way, so you can marshal that bad boy to Keychain or something), you can make calls on behalf of an Automatic user.

``` objective-c
[self.automatic getTrips:^(NSError *error, NSArray *trips) {
    BDKAutomaticTrip *trip = []trips firstObject];
    NSLog(@"Trip started %@.", trip.startTime);
}];
```

If you want an `MKPolyline` out of `-[BDKAutomaticTrip path]`, you'll want to include the separate `BDKAutomatic/MKPolylineSupport` subspec in your `Podfile`, and use it like so.

``` objective-c
#import <BDKAutomatic/MKPolyline+BDKEncodedString.h>
...
MKPolyline *mapPath = [MKPolyline polylineWithEncodedString:trip.path];
[self.mapView addOverlay:mapPath level:MKOverlayLevelAboveRoads];
```

You get the idea. See `BDKMapViewController.m` for more goodies.

## Example project setup

To run the example project; clone the repo, and run `pod install` from the Project directory first. Then, open `BDKAutomatic.xcworkspace` in the Project directory.

You'll want to copy the secret PLIST file from `Project/Classes/BDKAutomaticSecrets.plist.example` to `Project/Classes/BDKAutomaticSecrets.plist` and fill it out with your Automatic API client ID and client secret.

## Installation

BDKAutomatic is available through [CocoaPods](http://cocoapods.org), which is righteously awesome. To install it, simply add the following line to your Podfile.

``` ruby
pod 'BDKAutomatic'
```

If you wish to use the "path-to-`MKPolyline`" functionality, you'll want to include a separate subspec for that.

``` ruby
pod 'BDKAutomatic/MKPolylineSupport'
```

## Author

Ben Kreeger, ben@kree.gr

## License

BDKAutomatic is available under the MIT license. See the LICENSE file for more info.

[rest]:    https://www.automatic.com/developer/
