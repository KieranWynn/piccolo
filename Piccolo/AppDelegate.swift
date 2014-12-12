//
//  AppDelegate.swift
//  Piccolo
//
//  Created by Kieran Wynn on 30/10/2014.
//  Copyright (c) 2014 Kieran Wynn. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    var statusItem: NSStatusItem!
    var statusButton: NSStatusBarButton!
    
    // Constant Images
    let inactiveIcon = NSImage(named: "StatusIcon_inactive")
    let activeIcon = NSImage(named: "StatusIcon_active")
    
    var task = NSTask()
    
    
    var enabled = false


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2.0)
        statusButton = statusItem.button
        //statusItem.button
        
        statusButton.toolTip = "Piccolo \nClick to prevent sleep. \nRight click for options."
        statusButton.image = inactiveIcon
        
        statusButton.action = "statusItemClicked:"
        //statusButton.menuForEvent(<#event: NSEvent#>)
    
        //statusItem.popUpStatusItemMenu(<#menu: NSMenu#>)
        //statusButton.sendActionOn((1 << 1) | (1 << 3))
        statusItem.menu = statusMenu
        
        //let processID = NSProcessInfo().processIdentifier
        //println(" -disu -w " + String(processID))
        //task.launchPath = "/usr/bin/caffeinate"
        //task.arguments = ["-disu", "-w", String(processID)]//["-disu -w " + String(processID)]
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        if (task.running) {
            task.terminate()
        }
    }

    @IBAction func menuClicked(sender: NSMenuItem) {
        
    }
    
    @IBAction func statusItemClicked(sender: NSStatusItem) {
        if (enabled) {
            // Disable
            if (task.running) {
                task.terminate()
                task.waitUntilExit()
            }
            statusButton.image = inactiveIcon
            enabled = false
        } else {
            // Enable
            if (task.running) {
                task.terminate()
                task.waitUntilExit()
            }
            // Make an launch a new NStask object to run the "caffeinate" terminal command
            task = NSTask.launchedTaskWithLaunchPath(
                "/usr/bin/caffeinate",
                arguments: ["-disu", "-w", String(NSProcessInfo().processIdentifier)]
            )

            
            statusButton.image = activeIcon
            enabled = true
        }
        
    }
    
    
    
    @IBAction func setTimeout(sender: NSMenuItem) {
        println(sender.value())
    }
    @IBAction func quitPressed(sender: AnyObject) {
        if (task.running) {
            task.terminate()
        }
        NSApplication.sharedApplication().terminate(self)
    }

}

