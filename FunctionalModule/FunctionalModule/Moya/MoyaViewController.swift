//
//  MoyaViewController.swift
//  FunctionalModule
//
//  Created by 诺离 on 2020/6/4.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit
import Moya
import WebKit
import Kingfisher
import CoreServices
import CommonCrypto

let wkWebViewProvider = MoyaProvider<WkWebViewTarget>()
enum WkWebViewTarget {
    case webUrl(url: String)
}
extension WkWebViewTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .webUrl(url: let webUrl):
            return URL(string: webUrl)!
        }
    }
    
    
    var path: String {
        return ""
        
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var headers: [String : String]? {
        //        switch self {
        //        case .webUrl(url: let webUrl):
        //            if webUrl.contains(".css") {
        //                return ["Content-Type": "text/css"]
        //            }else if webUrl.contains(".js"){
        return ["Content-Type": "application/javascript"]
        //            }else{
        //                return ["Content-Type": "text/html"]
        //            }
        //        }
        return nil
    }
    
    var task: Task {
        return .requestPlain
    }
}


class MoyaViewController: UIViewController {
    
    lazy var label: UILabel = {
        let la = UILabel()
        la.numberOfLines = 0
        return la
    }()
    
    lazy var webview: WKWebView = {
        let configuration = WKWebViewConfiguration()
        if #available(iOS 11.0, *) {
            // 校验自定义 customScheme 是否已经可用，没有注册过才能使用
            guard let _ =  configuration.urlSchemeHandler(forURLScheme: "customScheme") else {
                configuration.setURLSchemeHandler(self, forURLScheme: "customScheme")
                let webview = WKWebView(frame: .zero, configuration: configuration)
                return webview
            }
        }
        let webview = WKWebView(frame: .zero, configuration: configuration)
        return webview
    }()
    
    var holdUrlSchemeTasks = [AnyHashable: Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let path = "customScheme://www.baidu.com"
        let path2 = "customScheme://mitphone.sunlife-everbright.com/app/proposalBook/"
        let url = URL(string: path)
        let request = URLRequest(url: url!)
        webview.load(request)
        
        view.addSubview(webview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        label.frame = view.bounds
        webview.frame = view.bounds
    }
    
    func network(){
        view.addSubview(label)
        let aa = "https://mitphone.sunlife-everbright.com/app/proposalBook/assets/js/chunk-vendors.d38af8f9.js"
        wkWebViewProvider.request(.webUrl(url: aa)) { (result) in
            switch result {
            case .success(let response):
                let res = response.response
                self.label.text = res?.description
                break
            case .failure(let error):
                self.label.text = error.response?.description
                break
            }
        }
    }
    
}

@available(iOS 11.0, *)
extension MoyaViewController: WKURLSchemeHandler {
    // 自定义拦截请求开始
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        holdUrlSchemeTasks[urlSchemeTask.description] = true
        
        let headers = urlSchemeTask.request.allHTTPHeaderFields
        guard let accept = headers?["Accept"] else { return }
        guard let requestUrlString = urlSchemeTask.request.url?.absoluteString else { return }
        if accept.count >= "text".count && accept.contains("text/html") {
            // html 拦截
            requestWebViewData(urlSchemeTask: urlSchemeTask)
            print("html = \(String(describing: requestUrlString))")
        } else if (requestUrlString.isJSOrCSSFile()) {
            // js || css 文件
            print("js || css = \(String(describing: requestUrlString))")
            requestWebViewData(urlSchemeTask: urlSchemeTask)

        } else if accept.count >= "image".count && accept.contains("image") {
            // 图片
            print("image = \(String(describing: requestUrlString))")
            guard let originUrlString = urlSchemeTask.request.url?.absoluteString.replacingOccurrences(of: "customscheme", with: "https") else { return }
            KingfisherManager.shared.retrieveImage(with: URL(string: originUrlString)!, options: nil, progressBlock: nil) { (image, error, catchType, url) in
                if let `image` = image {
                    guard let imageData = image.jpegData(compressionQuality: 1) else { return }
                    self.resendRequset(urlSchemeTask: urlSchemeTask, mineType: "image/jpeg", requestData: imageData)
                }
            }
            
        } else {
            // other resources
            print("other resources = \(String(describing: requestUrlString))")
            
        }
    }
    
    /// 自定义请求结束时调用
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        holdUrlSchemeTasks[urlSchemeTask.description] = false
    }
    
    func requestRomote(urlSchemeTask: WKURLSchemeTask) {
        // 没有缓存,替换url，重新加载
        guard let urlString = urlSchemeTask.request.url?.absoluteString.replacingOccurrences(of: "customscheme", with: "https") else { return }
        print("开始重新发送网络请求")
        // 替换成https请求
        wkWebViewProvider.request(.webUrl(url: urlString)) { (result) in
            switch result {
            case .success(let response):
                
                guard let urlResponse = response.response else {
                    return
                }
                //                    urlSchemeTask.didReceive(urlResponse)
                //                    urlSchemeTask.didReceive(response.data)
                //                    urlSchemeTask.didFinish()
                
                break
            case .failure(let error):
                print(error.response?.description ?? "customURLSchemeHandler")
                break
            }
        }
    }
    
    private func requestWebViewData(urlSchemeTask: WKURLSchemeTask){
        let schemeUrl:String = urlSchemeTask.request.url?.absoluteString ?? ""  //***这个搞过来好像都是小写的
        //换成原始的请求地址
        let replacedStr = schemeUrl.replacingOccurrences(of: "customscheme", with: "https")
        //发出请求结果返回
        let request = URLRequest.init(url: URL.init(string: replacedStr)!)
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config)
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            // urlSchemeTask 是否提前结束，结束了调用实例方法会崩溃
           if let isValid = self.holdUrlSchemeTasks[urlSchemeTask.description] {
               if !isValid {
                   return
               }
           }
            if error != nil{
                urlSchemeTask.didFailWithError(error!)
            }else{
                if let `response` = response, let `data` = data {
                    urlSchemeTask.didReceive(response)
                    urlSchemeTask.didReceive(data)
                    urlSchemeTask.didFinish()
                }
            }
        }
        dataTask.resume()
    }
    
    func resendRequset(urlSchemeTask: WKURLSchemeTask, mineType: String?, requestData: Data) {
        guard let url = urlSchemeTask.request.url else { return }
        
        let mineT = mineType ?? "text/html"
        let response = URLResponse(url: url, mimeType: mineT, expectedContentLength: requestData.count, textEncodingName: "utf-8")
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(requestData)
        urlSchemeTask.didFinish()
    }
}

extension String {
    func isJSOrCSSFile() -> Bool {
        if self.count == 0 { return false }
        let pattern = "\\.(js|css)"
        do {
            let result = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive).matches(in: self, options: NSRegularExpression.MatchingOptions.init(rawValue: 0), range: NSRange(location: 0, length: self.count))
            return result.count > 0
        } catch {
            return false
        }
    }
    
    //根据后缀获取对应的Mime-Type
    static func mimeType(pathExtension: String?) -> String {
        guard let pathExtension = pathExtension else { return "application/octet-stream" }
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString,
                                                           nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?
                .takeRetainedValue() {
                return mimetype as String
            }
        }
        
        //文件资源类型如果不知道，传万能类型application/octet-stream，服务器会自动解析文件类
        return "application/octet-stream"
    }
}
