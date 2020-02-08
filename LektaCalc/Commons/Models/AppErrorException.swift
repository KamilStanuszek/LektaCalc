//
//  AppErrorException.swift
//  LektaCalc
//
//  Created by Kamil Stanuszek on 08/02/2020.
//  Copyright © 2020 Kamil Stanuszek. All rights reserved.
//

import Foundation

enum AppErrorException: Error {
    case runtimeException(message: String)
}
