//
//  ViewController.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-10-21.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa
import Foundation

class ViewController: NSViewController {

    @IBOutlet weak var blockSizePopup: NSPopUpButton!
    @IBOutlet weak var manifestVersion: NSPopUpButton!
    @IBOutlet weak var manifestPretty: NSButton!
    
    @IBOutlet weak var outputFolderButton: NSButton!
    @IBOutlet weak var outputFolderField: NSTextField!
    @IBOutlet weak var outputNameField: NSTextField!
    
    @IBOutlet weak var addToQueueButton: NSButton!
    @IBOutlet weak var startQueueButton: NSButton!
    
    //The selected item will have a tag number equal to its framerate
    @IBOutlet weak var frameratePopup: NSPopUpButton!
    @IBOutlet weak var animationView: CBTAnimationView!
    @IBOutlet weak var renderQueueView: NSTableView!
    
    
    
    var imageArray:[AnyObject] = [];
    var outputFolder:NSURL?;
    var renderQueue:RenderQueue = RenderQueue();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.renderQueueView.setDelegate(self.renderQueue);
        self.renderQueueView.setDataSource(self.renderQueue);
        self.addToQueueButton.enabled = false;
        self.startQueueButton.enabled = false;
        
        self.blockSizePopup.enabled = false;
        self.frameratePopup.enabled = false;
        self.manifestVersion.enabled = false;
        self.manifestPretty.enabled = false;
        self.outputFolderButton.enabled = false;
        self.outputNameField.enabled = false;
    }
    
    @IBAction func openFileAction(sender: NSButton)
    {
        //Pop the dialog
        var dialog = NSOpenPanel();
        dialog.canChooseFiles = true;
        dialog.allowsMultipleSelection = true;
        dialog.canChooseDirectories = false;
        
        //Set up the multithreaded image loading
        var imageArrayLock = NSLock();
        var imageLoadQueue = NSOperationQueue();
        
        dialog.beginWithCompletionHandler { (result:Int) -> Void in
            if (result == NSFileHandlingPanelOKButton)
            {
                var urls = dialog.URLs;
                
                //File our image array with place holder blank objects
                self.imageArray = [AnyObject](count: urls.count, repeatedValue: NSNull());
                for (index, object) in enumerate(urls)
                {
                    var url = object as! NSURL;
                    imageLoadQueue.addOperation(NSBlockOperation(block: { () -> Void in
                        var image : NSImage! = NSImage(contentsOfFile: url.path!);
                        imageArrayLock.lock();
                        self.imageArray[index] = image;
                        imageArrayLock.unlock();
                        NSLog(url.path!);
                    }))
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    imageLoadQueue.waitUntilAllOperationsAreFinished();
                    self.animationView.setAnimation(self.imageArray);
                    self.animationView.startAnimation(self.frameratePopup.selectedTag());
                });
                
                //Enable all of the controls now
                self.blockSizePopup.enabled = true;
                self.frameratePopup.enabled = true;
                self.outputFolderButton.enabled = true;
                self.outputNameField.enabled = true;
                self.manifestVersion.enabled = true;
                self.manifestPretty.enabled = true;
            }
        };
    }
    
    @IBAction func outputFolder(sender: NSButton)
    {
        //Pop the dialog
        var dialog = NSOpenPanel();
        dialog.canChooseFiles = false;
        dialog.allowsMultipleSelection = false;
        dialog.canChooseDirectories = true;
        dialog.canCreateDirectories = true;
        
        dialog.beginWithCompletionHandler { (result:Int) -> Void in
            if (result == NSFileHandlingPanelOKButton)
            {
                var urls = dialog.URLs;
                self.outputFolder = urls[0] as? NSURL;
                self.outputFolderField.stringValue = self.outputFolder!.path!;
                self.addToQueueButton.enabled = true;
            }
        };
        
    }
    
    @IBAction func startQueue(sender: NSButton)
    {
        if let images = self.imageArray as? [NSImage]
        {
            self.renderQueue.startQueue(images);
        }
    }
    
    @IBAction func addToQueue(sender: NSButton)
    {
        let settings = Settings(
            width: Int(self.imageArray[0].size.width),
            height: Int(self.imageArray[0].size.height),
            frameCount: self.imageArray.count,
            framerate: FrameRate(rawValue: self.frameratePopup.selectedItem!.tag)!,
            outputName: self.outputNameField.stringValue,
            outputPath: self.outputFolder!.path!+"/",
            manifestVersion: ManifestVersion(rawValue: self.manifestVersion.selectedItem!.tag)!,
            prettyManifest:(self.manifestPretty.state == NSOnState),
            cellSize: CellSize(rawValue: self.blockSizePopup.selectedItem!.tag)!
        );
        self.renderQueue.queue.append(settings)
        self.renderQueueView.reloadData();
        self.startQueueButton.enabled = true;
    }
}

