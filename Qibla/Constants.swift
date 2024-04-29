//
//  CompassMeasurements.swift
//  Qibla
//
//  Created by shahid on 25/04/24.
//

import Foundation

struct CompassComponentsMeasurements {
    var circleSize: Double
    var circleSizeExpanded: Double
    
    var semiCirclePadding: Double
    var semiCircleLineWidth: Double
    
    var qiblaIconSize: Double
    var qiblaIconExpanded: Double
    
    init(){
    #if os(watchOS)
        circleSize = 14
        circleSizeExpanded = 24
        semiCirclePadding = 0.06
        semiCircleLineWidth = 10
        qiblaIconSize = 12
        qiblaIconExpanded = 18
        
        
    #else
        circleSize = 18
        circleSizeExpanded = 32
        semiCirclePadding = 0.03
        semiCircleLineWidth = 16
        qiblaIconSize = 16
        qiblaIconExpanded = 20
    #endif
    }
}
