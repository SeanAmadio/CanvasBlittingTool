//
//  CBTJSONCoordinator.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2014-12-08.
//  Copyright (c) 2014 Two Amadios. All rights reserved.
//

import Cocoa

enum ManifestWriteError
{
    case None
    case UnsupportedVersion(Int)
    case InvalidManifest
    case SerializationError
    case EncodingError
}

class CBTJSONCoordinator: CBTCoordinator
{
    var data:[[[Int]]];
    
    init (frames: Int)
    {
        data = [[[Int]]](count: frames, repeatedValue: []);
        super.init();
    }
    
    //Adds one cell write to our manifest data
    func addCellData(sourceIndex:Int, destinationIndex:Int, frame: Int, callbackClosure: () -> Void)
    {
        var operation = NSBlockOperation { () -> Void in
            self.data[frame].append([sourceIndex, destinationIndex]);
            callbackClosure();
        };
        self.modifyQueue.addOperation(operation);
    }
    
    func writeManifest(version:Int, pretty:Bool) -> ManifestWriteError
    {
        //Ok
        var manifest = [String:AnyObject]();
        
        switch (version)
        {
            case 1:
                manifest["version"] = 1;
                manifest["frameCount"] = self.data.count;
                manifest["blockSize"] = 8;
                manifest["frames"] = self.data;
            default:
                NSLog("Unsupported format %i", version);
                return ManifestWriteError.UnsupportedVersion(version);
        }
        
        var docsDir:AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0];
        var databasePath = docsDir.stringByAppendingPathComponent("manifest.json");
        
        //Write the manifest to the file
        let settings = pretty ? NSJSONWritingOptions.PrettyPrinted : nil;
        if (NSJSONSerialization.isValidJSONObject(manifest))
        {
            if let data = NSJSONSerialization.dataWithJSONObject(manifest, options: settings, error: nil)
            {
                data.writeToFile(databasePath, atomically: true);
                /*if let JSONString = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    return JSONString
                }
                else
                {
                    return ManifestWriteError.EncodingError;
                }*/
                return ManifestWriteError.None;
            }
            else
            {
                return ManifestWriteError.SerializationError;
            }
        }
        else
        {
            return ManifestWriteError.InvalidManifest;
        }
    }
}
