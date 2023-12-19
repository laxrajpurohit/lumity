//
//  MapViewPinClass.swift
//  Bar-Surge
//
//  Created by iroid on 21/01/20.
//  Copyright © 2020 iroid. All rights reserved.
//

import Foundation
import MapKit

class customPin: NSObject, MKAnnotation{
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var storeImage:String?
    var actionId:Int?
    init(pinTitle:String,Location:CLLocationCoordinate2D,storeImage:String,actionId:Int) {
        self.coordinate = Location
        self.title = pinTitle
        self.storeImage = storeImage
        self.actionId = actionId
    }
}




