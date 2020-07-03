//
//  AuthPlugin.swift
//  GDInsuranceMobile
//
//  Created by zww on 2020/3/27.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import Foundation
import Moya
//import Result

// 请求添加令牌
struct AuthPlugin: PluginType {

    //准备发起请求
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
       

        return request
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        
    }
}
