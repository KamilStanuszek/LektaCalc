//
//  StringExtension.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import Foundation

extension String {
    var hasOnlyMathematicCharacters: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "(", ")", "*", "/", "+", "-"]
        return Set(self).isSubset(of: nums)
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
