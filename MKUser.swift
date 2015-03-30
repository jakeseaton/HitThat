//
//  MKUser.swift
//  snatch
//
//  Created by Jake Seaton on 3/26/15.
//  Copyright (c) 2015 Jake Seaton. All rights reserved.
//

import MapKit

extension PFUser:MKAnnotation{
    public var coordinate:CLLocationCoordinate2D{
        let location = objectForKey("location") as AnyObject as PFGeoPoint
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    public var title:String! {
        let name = objectForKey("fullName") as AnyObject as String
        return name
    }
//    public var subtitle:String!{
//        return username
//    }
}

