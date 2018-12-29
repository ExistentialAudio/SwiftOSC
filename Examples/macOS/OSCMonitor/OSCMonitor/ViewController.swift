//
//  ViewController.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/15/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Cocoa
//import SwiftOSC
import SwiftOSC

let defaults = UserDefaults.standard

class ViewController: NSViewController, NSTableViewDataSource, OSCDelegate {
    
    var server: OSCServer?
    
    var tableData: [TableData] = []

    @IBOutlet weak var port: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let defaultPort = defaults.integer(forKey: "Port")
        if defaultPort != 0 {
            server = OSCServer(port: defaultPort)
            self.port.stringValue = String(defaultPort)
        } else {
            server = OSCServer(port: 8080)
            self.port.stringValue = String(8080)
        }
        
        //setup to receive data from server
        server?.delegate = self
        tableView.dataSource = self
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //add osc data from notification
    func didReceive(_ message: OSCMessage) {
        let tableData = TableData(Date(), message)
        self.tableData.append(tableData)
        tableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        if (tableColumn?.identifier)!.rawValue == "Date" {
            let index = (tableData.count - 1 - row)
            return tableData[index].dateDescription
        }
        if (tableColumn?.identifier)!.rawValue == "Address" {
            let index = (tableData.count - 1 - row)
            return tableData[index].message.address.string
        }
        if (tableColumn?.identifier)!.rawValue == "Arguments" {
            let index = (tableData.count - 1 - row)
            return tableData[index].argumentsDescription
        }
        
        return nil
    }
    @IBAction func changePort(_ sender: NSTextField) {
        if sender.integerValue != defaults.integer(forKey: "Port") {
            _ = server?.change(port: sender.integerValue)
            defaults.set(sender.integerValue, forKey: "Port")
        }
    }

    @IBAction func clear(_ sender: NSButton) {
        tableData.removeAll()
        tableView.reloadData()
    }
    @IBAction func saveToFile(_ sender: NSButton) {
        
        //prompt save location
        let savePanel = NSSavePanel()
        savePanel.runModal()
        
        if let url = savePanel.url {
            var url = url
            if url.pathExtension != "txt" {
                url.appendPathExtension("txt")
            }
            //generate data
            var text = ""
            for data in tableData {
                text += "\(data.dateDescription), \(data.message.address.string), \(data.argumentsDescription)\n"
            }
            
            //writing
            do {
                try text.write(to: url, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
    }

}

