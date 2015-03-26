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
    
    func writeManifest(settings: Settings) -> ManifestWriteError
    {
        //Ok
        var manifest = [String:AnyObject]();
        
        switch (settings.manifestVersion)
        {
            case ManifestVersion.Version1:
                manifest["version"] = settings.manifestVersion.rawValue;
                manifest["frameCount"] = settings.frameCount;
                manifest["cellSize"] = settings.cellSize.rawValue;
                manifest["frames"] = self.data;
                manifest["frameRate"] = settings.framerate.rawValue;
            default:
                NSLog("Unsupported format %i", settings.manifestVersion.rawValue);
                return ManifestWriteError.UnsupportedVersion(settings.manifestVersion);
        }
        
        //Write the manifest to the file
        let jsonSettings = settings.prettyManifest ? NSJSONWritingOptions.PrettyPrinted : nil;
        if (NSJSONSerialization.isValidJSONObject(manifest))
        {
            if let data = NSJSONSerialization.dataWithJSONObject(manifest, options: jsonSettings, error: nil)
            {
                data.writeToFile(settings.manifestPath, atomically: true);
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
