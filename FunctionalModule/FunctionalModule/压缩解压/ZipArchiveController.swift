//
//  ZipArchiveController.swift
//  FunctionalModule
//
//  Created by 诺离 on 2020/7/1.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit
import SSZipArchive

class ZipArchiveController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        unZipFile(atPath: "/Users/nuoli/Desktop/gsb_mobile_beta_data.zip", toDestination: "/Users/nuoli/Desktop/Temp")
    }
    
    private func unZipFile(atPath path: String, toDestination destination: String) {
        DispatchQueue.global(qos: .background).async {
            
            SSZipArchive.unzipFile(atPath: path, toDestination: destination, progressHandler: { (entry, zipInfo, entryNumber, total) in
                
            }) { (path, succeeded, error) in
                // 删除压缩包
                try? FileManager.default.removeItem(atPath: path)
                if succeeded {
                    let message = "success"
                    print(message)
                }else {
                    let message = "数据文件解压失败,重新下载或退出程序"
                    print(message)
                }
            }
        }
    }

}
