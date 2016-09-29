//
//  TWD97toLongitudeLatitude.swift
//  TaipeiConstructions
//
//  Created by Sean on 2016/9/29.
//  Copyright © 2016年 SeanYin. All rights reserved.
//

import Foundation

func twd97ToWGS84 (inout x longitude: Double, inout y latitude: Double) {
    
    let a = 6378137.0
    let b = 6356752.314245
    let lng0 = 121 * M_PI / 180
    let k0 = 0.9999
    let dx = 250000.0
    let dy = 0.0
    let e = pow((1.0 - (pow(b,2) / pow(a, 2))), 0.5)
    
    longitude -= dx
    latitude -= dy
    
    let m = latitude/k0
    let mu = m / (a * (1.0 - pow(e, 2) / 4.0 - 3.0 * pow(e, 4) / 64.0 - 5.0 * pow(e, 6) / 256.0))
    let e1 = (1.0 - pow((1.0 - pow(e, 2)), 0.5)) / (1.0 + pow((1.0 - pow(e, 2)), 0.5))
    
    let j1 = (3.0 * e1 / 2.0 - 27.0 * pow(e1, 3) / 32.0)
    let j2 = (21.0 * pow(e1, 2) / 16 - 55 * pow(e1, 4) / 32.0)
    let j3 = (151.0 * pow(e1, 3) / 96.0)
    let j4 = (1097 * pow(e1, 4) / 512.0)
    
    // Split a series of multiplication into two parts for Xcode's suggestion perfermance
    var fp = mu + (j1 * sin(2 * mu)) + (j2 * sin(4 * mu))
    fp += (j3 * sin(6 * mu)) + (j4 * sin(8 * mu))
    
    let e2 = pow((e * a / b), 2)
    let c1 = pow(e2 * cos(fp), 2)
    let t1 = pow(tan(fp), 2)
    let r1 = a * (1 - pow(e, 2)) / pow((1 - pow(e, 2) * pow(sin(fp), 2)), (3.0 / 2.0))
    let n1 = a / pow((1 - pow(e, 2) * pow(sin(fp), 2)), 0.5)
    
    let d = longitude / (n1 * k0)
    
    let q1 = n1 * tan(fp) / r1
    let q2 = (pow(d, 2) / 2.0)
    let q3 = (5 + 3 * t1 + 10 * c1 - 4 * pow(c1, 2) - 9 * e2) * pow(d, 4) / 24.0
    let q4 = (61 + 90 * t1 + 298 * c1 + 45 * pow(t1, 2) - 3 * pow(c1, 2) - 252 * e2) * pow(d, 6) / 720.0
    let lat = fp - q1 * (q2 - q3 + q4)
    let q5 = d
    let q6 = (1 + 2 * t1 + c1) * pow(d, 3) / 6
    let q7 = (5 - 2 * c1 + 28 * t1 - 3 * pow(c1, 2) + 8 * e2 + 24 * pow(t1, 2)) * pow(d, 5) / 120.0
    let lng = lng0 + (q5 - q6 + q7) / cos(fp)
    
    latitude = (lat * 180) / M_PI
    longitude = (lng * 180) / M_PI
}