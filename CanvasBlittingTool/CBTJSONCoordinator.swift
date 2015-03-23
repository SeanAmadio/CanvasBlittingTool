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
    case UnsupportedVersion(ManifestVersion)
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
    
    func writeManifest(path: String, name: String, version:ManifestVersion, pretty:Bool) -> ManifestWriteError
    {
        //Ok
        var manifest = [String:AnyObject]();
        
        switch (version)
        {
            case ManifestVersion.Version1:
                manifest["version"] = version.rawValue;
                manifest["frameCount"] = self.data.count;
                manifest["blockSize"] = 8;
                manifest["frames"] = self.data;
            default:
                NSLog("Unsupported format %i", version.rawValue);
                return ManifestWriteError.UnsupportedVersion(version);
        }
        
        //Write the manifest to the file
        let settings = pretty ? NSJSONWritingOptions.PrettyPrinted : nil;
        if (NSJSONSerialization.isValidJSONObject(manifest))
        {
            if let data = NSJSONSerialization.dataWithJSONObject(manifest, options: settings, error: nil)
            {
                data.writeToFile("\(path)\(name)Manifest.json", atomically: true);
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
