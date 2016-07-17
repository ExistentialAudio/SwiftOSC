//
//  ViewController.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/15/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Cocoa
import SwiftOSC

let defaults = UserDefaults.standard

class ViewController: NSViewController, NSTableViewDataSource, OSCServerDelegate {
    
    
    
    var tableData: [TableData] = []
    var addressValue = OSCAddress()

    @IBOutlet weak var port: NSTextField!
    @IBOutlet weak var address: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        server.port = defaults.integer(forKey: "Port")
        self.port.stringValue = String(server.port)
        if let address = defaults.string(forKey: "Address") {
            self.addressValue.string = address
            self.address.stringValue = address
        }
        
        //setup to receive data from server
        server.delegate = self
        tableView.dataSource = self
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //add osc data from notification
    func didReceive(_ message: OSCMessage) {
        if message.address.matches(path: self.addressValue) {
            let tableData = TableData(Date(), message)
            self.tableData.append(tableData)
            tableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if tableColumn?.identifier == "Date" {
            let index = (tableData.count - 1 - row)
            return tableData[index].dateDescription
        }
        if tableColumn?.identifier == "Address" {
            let index = (tableData.count - 1 - row)
            return tableData[index].message.address.string
        }
        if tableColumn?.identifier == "Arguments" {
            let index = (tableData.count - 1 - row)
            return tableData[index].argumentsDescription
        }
        
        return nil
    }
    @IBAction func changePort(_ sender: NSTextField) {
        server.port = sender.integerValue
        defaults.set(sender.integerValue, forKey: "Port")
    }
    
    @IBAction func changeOSCAddress(_ sender: NSTextField) {
        self.addressValue = OSCAddress(sender.stringValue)
        sender.stringValue = self.addressValue.string
        defaults.set(self.addressValue.string, forKey: "Address")
        
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
                do {
                    try url.appendPathExtension("txt")
                }
                catch {/* error handling here */}
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
    @IBAction func startServer(_ sender: NSButton) {
        if sender.integerValue == 0 {
            sender.title = "Start"
            server.stop()
        } else {
            server.start()
            sender.title = "Stop"
            
        }
    }
}

