//
//  PDFReaderViewerController.swift
//  FunctionalModule
//
//  Created by 诺离 on 2020/5/28.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit
import WebKit

class PDFReaderViewerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        let pdf1 =         "http://wwwfujian.book118.com//dianzishu/%E5%90%8C%E5%9F%8E%E7%BD%91/3%E6%9C%88%E5%88%9D_83402/pdf/%E5%90%8C%E7%A8%8B%E7%BD%91%E5%BC%80%E5%B9%B3%E6%97%85%E6%B8%B8%E6%94%BB%E7%95%A5%EF%BC%882012%E5%B9%B4%E7%89%88%EF%BC%89.pdf"
        let pdf2 = "https://xinyidongzhanyeguangsubao-st-1254235118.cos.ap-beijing.myqcloud.com/Default/HCT010-T.pdf"
        let url = URL(string: pdf1)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
    }
    

}
