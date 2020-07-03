//
//  GDIMoyaBaseModel.swift
//  GDInsuranceMobile
//
//  Created by 诺离 on 2020/4/30.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit
import HandyJSON

struct GDIMoyaBaseModel: HandyJSON, Decodable {
    /// 请求状态妈
    var status: Int!
    /// 信息描述
    var message: String!
    /// 业务code
    var bizcode: Int!
    /// 错误信息
    var error: String!
    /// 请求时间
    var timestamp: String!
    /// 请求路径
    var path: String!

}
