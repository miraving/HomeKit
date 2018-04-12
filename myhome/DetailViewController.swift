//
//  DetailViewController.swift
//  myhome
//
//  Created by Vitalii Obertynskyi on 4/12/18.
//  Copyright © 2018 Vitalii Obertynskyi. All rights reserved.
//

import UIKit
import HomeKit

class DetailViewController: UITableViewController {

    var acc: HMAccessory?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Service \(acc?.services.count ?? 0)"
    }
}

extension DetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acc?.services.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "serviceId") as UITableViewCell?
        if let service = acc?.services[indexPath.row] {
            cell?.textLabel?.text = service.name
            cell?.detailTextLabel?.text = service.accessory?.manufacturer
        }
        
        return (cell != nil) ? cell! : UITableViewCell()
    }
}
