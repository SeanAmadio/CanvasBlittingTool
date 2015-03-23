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
    @IBOutlet weak var frameRatePopup: NSPopUpButton!
    @IBOutlet weak var manifestVersion: NSPopUpButton!
    @IBOutlet weak var manifestPretty: NSButton!
    //The selected item will have a tag number equal to its framerate
    @IBOutlet weak var frameratePopup: NSPopUpButton!
    @IBOutlet weak var animationView: CBTAnimationView!
    @IBOutlet weak var renderQueueView: NSTableView!
    
    
    
    var imageArray:[AnyObject] = [];
    
    var renderQueue:RenderQueue = RenderQueue();
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        self.renderQueueView.setDelegate(self.renderQueue);
        self.renderQueueView.setDataSource(self.renderQueue);
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
        var docsDir:AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0];
        var databasePath = docsDir.stringByAppendingPathComponent("");
        
        var manifestVersion:ManifestVersion;
        var prettyManifest:Bool;
        let settings = Settings(
            width: 32,
            height: 32,
            frameCount: 4,
            framerate: FrameRate.F30,
            outputName: "output",
            outputPath: databasePath,
            manifestVersion: ManifestVersion.Version1,
            prettyManifest:true,
            cellSize: CellSize.S8
        );
        self.renderQueue.queue.append(settings)
        self.renderQueueView.reloadData();
    }
}

