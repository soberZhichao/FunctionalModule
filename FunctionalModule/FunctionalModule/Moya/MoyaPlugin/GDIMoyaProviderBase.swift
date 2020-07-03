//
//  GDIMoyaProviderBase.swift
//  GDInsuranceMobile
//
//  Created by 诺离 on 2020/4/23.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit
import Moya

/// 请求前后要做的事情
let networkActivityPlugin = NetworkActivityPlugin { (changeType, targetType) in
    switch changeType {
    case .began:
        break
    case .ended:
        break
    }
}

/// 统一在request中添加的参数
let authPlugin = AuthPlugin()
