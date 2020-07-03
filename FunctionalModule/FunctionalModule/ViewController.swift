//
//  ViewController.swift
//  FunctionalModule
//
//  Created by 诺离 on 2020/5/14.
//  Copyright © 2020 HangZhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var propertyList: [[String: String]] = []
// master-change-2
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let property = getPropertyList() as? [[String: String]] else {
            return
        }
        
        propertyList = property
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = UIImage()
        title = "Functional Module"
        
    }

    private func getPropertyList() -> Any? {
        guard let ipaPlistBundlePath = Bundle.main.path(forResource: "FunctionList", ofType: "plist") else {
            return nil
        }
        
        let ipaPlistBundleUrl = URL(fileURLWithPath: ipaPlistBundlePath)
        do {
            let propertyData = try Data(contentsOf: ipaPlistBundleUrl)
            let property = try PropertyListSerialization.propertyList(from: propertyData, options: [], format: nil)
            return property
        }catch{
            print(error.localizedDescription)
            return nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyList.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = propertyList[indexPath.row]["func"]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let className = propertyList[indexPath.row]["class"] else{
            return
        }
        var projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        projectName = projectName.replacingOccurrences(of: "-", with: "_")
        guard let classT = NSClassFromString(projectName + "." + className) as? UIViewController.Type else {
            return
        }
        let vc = classT.init()
        navigationController?.pushViewController(vc, animated: true)
    }
}

