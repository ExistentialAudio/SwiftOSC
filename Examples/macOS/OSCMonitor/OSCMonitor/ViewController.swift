//
//  ViewController.swift
//  OSCMonitor
//
//  Created by Devin Roth on 7/15/16.
//  Copyright © 2016 Devin Roth Music. All rights reserved.
//

import Cocoa
import SwiftOSC

class ViewController: NSViewController, NSTableViewDataSource {
    
    var tableData: [TableData] = []

    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Setup tableview
        
        //set view to receive notifications from server
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addOSCMessage),
            name: OSCServer.didReceiveMessage,
            object: nil
        )

        tableView.dataSource = self
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    //print osc data from notification
    func addOSCMessage(notification: Notification) {
        let message = notification.object as! OSCMessage
        let tableData = TableData(Date(), message)
        self.tableData.append(tableData)
        tableView.reloadData()
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
    }
    
    @IBAction func changeOSCAddress(_ sender: AnyObject) {
    }
    @IBAction func clear(_ sender: NSButton) {
        tableData = []
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
        server.start()
    }
    
    @IBAction func stopServer(_ sender: NSButton) {
        server.stop()
    }

}

