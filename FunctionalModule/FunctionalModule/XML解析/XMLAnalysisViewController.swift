//
//  XMLAnalysisViewController.swift
//  FunctionalModule
//
//  Created by 诺离 on 2020/5/14.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit

class XMLAnalysisViewController: UIViewController, XMLParserDelegate {
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.frame = view.bounds
        label.textAlignment = .center
        return label
    }()
    /// 标记需要解析的节点
    var elementTag: String!
    /// 解析的版本号
    var version: String! {
        didSet{
            textLabel.text = "productVersion:  " + version
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(textLabel)
        analysisXML()
    }
    
    private func analysisXML(){
        guard let xmlBundlePath = Bundle.main.path(forResource: "config", ofType: "xml") else {
            return
        }
        
        let xmlBundleUrl = URL(fileURLWithPath: xmlBundlePath)
        let parser = XMLParser(contentsOf: xmlBundleUrl)
        parser?.delegate = self
        parser?.parse()
    }
    
    /// 查询节点以及节点的属性
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        elementTag = elementName
    }
    
    /// 查询节点下的内容
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let str: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        print(elementTag!, string)
        if elementTag == "productVersion" && str != "" {
            version = string
        }
    }
    
}
