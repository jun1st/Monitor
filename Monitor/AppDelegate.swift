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
        
//        updateTimer = Timer.init(timeInterval: <#T##TimeInterval#>, target: <#T##Any#>, selector: <#T##Selector#>, userInfo: <#T##Any?#>, repeats: <#T##Bool#>)
        updateTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(updateSpeed), userInfo: nil, repeats: true)
        
        RunLoop.current.add(updateTimer!, forMode: .common)
//        updateTimer.fire()
        
//        for interface in netConfig.interfaceDetails() {
//            let detail = interface as? NSDictionary
//            if let interfaceDetail = detail {
//                print(interfaceDetail["name"])
//                print(interfaceDetail["devicename"])
//            }
//        }
        
//        NSArray *interfaceDetails = [netConfig interfaceDetails];
//        if ([interfaceDetails count]) {
//            NSEnumerator *detailEnum = [interfaceDetails objectEnumerator];
//            NSDictionary *details = nil;
//            while ((details = [detailEnum nextObject])) {
//                // Array entry is a service/interface
//                NSMutableDictionary *interfaceUpdateMenuItems = [NSMutableDictionary dictionary];
//                NSString *interfaceDescription = [details objectForKey:@"name"];
//                NSLog(@"%@", interfaceDescription);
//                NSString *speed = nil;
//                // Best guess if this is an active interface, default to assume it is active
//                BOOL isActiveInterface = YES;
//
//                if ([details objectForKey:@"linkactive"]) {
//                    isActiveInterface = [[details objectForKey:@"linkactive"] boolValue];
//                }
//
//                if ([details objectForKey:@"pppstatus"]) {
//                    if ([(NSNumber *)[[details objectForKey:@"pppstatus"] objectForKey:@"status"] unsignedIntValue] == PPP_IDLE) {
//                        isActiveInterface = NO;
//                    }
//                }
//
//                // Calc speed
//                if ([details objectForKey:@"linkspeed"] && isActiveInterface) {
//                    if ([[details objectForKey:@"linkspeed"] doubleValue] > 1000000000) {
//                        speed = [NSString stringWithFormat:@" %.0f %@",
//                                    ([[details objectForKey:@"linkspeed"] doubleValue] / 1000000000),
//                                    [localizedStrings objectForKey:kGbpsLabel]];
//                    } else if ([[details objectForKey:@"linkspeed"] doubleValue] > 1000000) {
//                        speed = [NSString stringWithFormat:@" %.0f %@",
//                                    ([[details objectForKey:@"linkspeed"] doubleValue] / 1000000),
//                                    [localizedStrings objectForKey:kMbpsLabel]];
//                    } else {
//                        speed = [NSString stringWithFormat:@" %@ %@",
//                                    [bytesFormatter stringForObjectValue:
//                                        [NSNumber numberWithDouble:([[details objectForKey:@"linkspeed"] doubleValue] / 1000)]],
//                                    [localizedStrings objectForKey:kKbpsLabel]];
//                    }
//                }
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
                        print(deviceName)
                        let deviceNetLoad = netload[deviceName] as? NSDictionary
                        if let load = deviceNetLoad {
    //                        self.statusItem.button!.title = String(Double(load["deltaout"]!))
                            let out = load["deltaout"] as? Int
                            if let deltaOut = out {
    //                            print(deltaOut)
                            
                                let button: NSStatusBarButton = self.statusItem.button!
                                button.title = String(deltaOut)
                            }
                        }
    //                        print(deviceNetLoad["deltaout"])
    //                        print(deviceNetLoad["deltain"])
    //                    }
    //                    let linkSpeed: Double? = dicItem.object(forKey: "linkspeed") as? Double
    //                    if let speed = linkSpeed, speed > 10000000 {
    //                        print(speed)
    //
    //                        if let button = statusItem.button {
    //                            button.title = String(speed)
    //                        }
    //                    }
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

