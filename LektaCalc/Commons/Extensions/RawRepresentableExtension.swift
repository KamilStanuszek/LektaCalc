//
//  RawRepresentableExtension.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == String {
    
    var localized: String {
        return rawValue.localized
    }
    
}
