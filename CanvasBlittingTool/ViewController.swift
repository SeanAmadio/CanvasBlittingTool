//
//  ViewController.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-21.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var blockSizePopup: NSPopUpButton!
    @IBOutlet weak var frameratePopup: NSPopUpButton!
    @IBOutlet weak var hashComparisonCheck: NSButton!
    @IBOutlet weak var loopCheck: NSButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func openFileAction(sender: NSButton)
    {
        
        var dialog = NSOpenPanel();
        dialog.canChooseFiles = true;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseDirectories = false;
        
        dialog.beginWithCompletionHandler { (Int result) -> Void in
            if (result == NSFileHandlingPanelOKButton)
            {
                var urls = dialog.URLs;
                
                for object in urls
                {
                    NSLog(object.description);
                }
            }
        };
    }

}

