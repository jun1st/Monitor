//
//  AppDelegate.swift
//  Monitor
//
//  Created by fengde on 2019/9/19.
//  Copyright © 2019 fengde. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    let popover = NSPopover()
    
    let netConfig = MonitorNetConfig()
    
    var updateTimer: Timer?
    
    let netHistoryData = NSMutableArray()
    let netHistoryIntervals = NSMutableArray()
    let netStats = MonitorNetStats()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
//            button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
        }
        
        popover.contentViewController = QuotesViewController.freshController()
        
        updateTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
        
        RunLoop.current.add(updateTimer!, forMode: .common)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func updateSpeed() {
        let netload = netStats.netStats(forInterval: TimeInterval(1.0))!
        let interfaceDetails = netConfig.interfaceDetails()
        if let detail = interfaceDetails, detail.count > 0 {
            for (_, item) in detail.enumerated() {

                if let dicItem = item as? NSDictionary {
                    let interfaceName = dicItem["name"] as! String

                    if interfaceName == "Wi-Fi" {
                        let deviceName = dicItem.object(forKey: "devicename") as! String
                        let deviceNetLoad = netload[deviceName] as? NSDictionary
                        if let load = deviceNetLoad, let out = load["deltain"] as? Int {
                            let button: NSStatusBarButton = self.statusItem.button!
                            button.title = humanizeTraffic(out)
                        }
                    }
                    
                }
            }
            
        }
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }

    func humanizeTraffic(_ trafficLoad: Int) -> String {
        var formattedString = "0 B/s"
        
        if trafficLoad > 1073741824 {
            formattedString = String(Double(trafficLoad) / 1073741824) + " GB/s"
        } else if trafficLoad > 1048576 {
            formattedString = String(Double(trafficLoad) / 1048576) + " MB/s"
        } else if trafficLoad > 1024 {
            formattedString = String(Double(trafficLoad) / 1024) + " KB/s"
        }
        
        return formattedString
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
}

