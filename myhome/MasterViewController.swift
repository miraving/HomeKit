//
//  MasterViewController.swift
//  myhome
//
//  Created by Vitalii Obertynskyi on 4/12/18.
//  Copyright © 2018 Vitalii Obertynskyi. All rights reserved.
//

import UIKit
import HomeKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    let homeManager = HMHomeManager()
    var activeHome: HMHome?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeManager.delegate = self
        
        if let h = homeManager.primaryHome {
            activeHome = h
            activeHome?.delegate = self
            activeHome?.accessories.forEach( { $0.delegate = self } )
            
            
            title = "\(h.rooms.count) room(s))"
        } else {
            print("Primary home is not found!!!")
        }
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let cell = sender as? UITableViewCell,
                let index = tableView.indexPath(for: cell),
                let nav = segue.destination as? UINavigationController,
                let controller = nav.topViewController as? DetailViewController else {
                return
            }
            
            let a = activeHome?.rooms[index.section].accessories[index.row]
            controller.acc = a
        }
    }
}

extension MasterViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return activeHome?.rooms.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let accessories = activeHome?.rooms[section].accessories {
            return accessories.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceId") as UITableViewCell?
        let accessory = activeHome?.rooms[indexPath.section].accessories[indexPath.row] as! HMAccessory
        cell?.textLabel?.text = accessory.name
        
        // ignore the information service
        cell?.detailTextLabel?.text = "\(accessory.services.count - 1) service(s)"
        
        return (cell != nil) ? cell! : UITableViewCell()
    }
}

extension MasterViewController: HMAccessoryDelegate {
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        print("Update accessories")
        if let index = activeHome?.rooms.index(of: accessory.room!) {
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.bottom)
        }
    }
}

extension MasterViewController: HMHomeDelegate {
    func home(_ home: HMHome, didAdd service: HMService, to group: HMServiceGroup) {
        print("Home did add service \(service.name)")
    }
    
    func home(_ home: HMHome, didRemove service: HMService, from group: HMServiceGroup) {
        print("HOme did remove service \(service.name)")
    }
}

extension MasterViewController: HMHomeManagerDelegate {
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        print("Home manager did add home")
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        print("Home manager did remove home")
    }
}

extension MasterViewController: HMAccessoryBrowserDelegate {
    // Informs us when we've located a new accessory
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print("Did find new accessory")
    }
    
    // Informs us when a device, that was previously reachable, is no longer reachable
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didRemoveNewAccessory accessory: HMAccessory) {
        print("Did remove new accessory")
    }
}
