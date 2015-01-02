//
//  AppDelegate.swift
//  Piccolo
//
//  Created by Kieran Wynn on 30/10/2014.
//  Copyright (c) 2014 Kieran Wynn. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    
    @IBOutlet weak var aboutWindow: NSView!
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
        statusItem.highlightMode = false
        
        statusButton = statusItem.button
        
        statusButton.image = inactiveIcon
        statusButton.toolTip = "Piccolo: Click to prevent sleep. \n-option + click for options \n-command + click to quit"
        
        statusButton.action = "statusButtonClicked:"
        statusButton.menu = statusMenu
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        if (task.running) {
            task.terminate()
        }
    }
    
    @IBAction func statusButtonClicked(sender: NSStatusItem) {
        var event: NSEvent
        event = NSApp.currentEvent!!
        
        println(event.type.rawValue)

        if  event.modifierFlags & NSEventModifierFlags.CommandKeyMask != nil {
            println("Command pressed")
            if (task.running) {
                task.terminate()
            }
            NSApplication.sharedApplication().terminate(self)
        }
        if  event.modifierFlags & NSEventModifierFlags.AlternateKeyMask != nil {
            println("Alt pressed")
            statusItem.popUpStatusItemMenu(statusButton.menu!)
            return
            
        }
        
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
    
    
    @IBAction func aboutPressed(sender: NSMenuItem) {
        aboutWindow.display()
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

