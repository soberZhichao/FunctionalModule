//
//  DecodePlugin.swift
//  GDInsuranceMobile
//
//  Created by zww on 2020/3/27.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import Foundation
import Moya
import HandyJSON
//import Result

struct DecodePlugin: PluginType {
    
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
        if case let .success(response) = result {
        }
        if case let .failure(response) = result {
                print(response)
                return .failure(response)
        }
        return result
    }
}
