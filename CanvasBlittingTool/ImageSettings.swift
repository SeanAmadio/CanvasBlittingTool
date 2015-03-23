//
//  ImageSettings.swift
//  CanvasBlittingTool
//
//  Created by Sean Amadio on 2015-03-11.
//  Copyright (c) 2015 Two Amadios. All rights reserved.
//

import Foundation


enum FrameRate : Int
{
    case F30 = 30
    case F60 = 60
}

enum CellSize : Int
{
    case S8 = 8
    case S16 = 16
    case S32 = 32
}

enum ManifestVersion : Int
{
    case Version1 = 1
    case Version2 = 2
    case Version3 = 3
}

//Describing cell metadata
struct Settings
{
    //Animation properties
    var width:Int;
    var height:Int;
    var frameCount:Int;
    var framerate:FrameRate;
    
    //Output Settings
    var outputName:String;
    var outputPath:String;
    var manifestVersion:ManifestVersion;
    var prettyManifest:Bool;
    
    
    //Cell size
    var cellSize:CellSize;
    var cellRows:Int
    {
        get
        {
            return Int(ceil(Float(width)/Float(cellSize.rawValue)));
        }
    }
    
    var cellColumns:Int
    {
        get
        {
            return Int(ceil(Float(height)/Float(cellSize.rawValue)));
        }
    }
    
    var cells:Int
    {
        get
        {
            return cellRows*cellColumns;
        }
    }
    
    //Returns the numbers of bits needed to represent these dimensions
    var bits:Int
    {
        get
        {
            return Int(ceil(log2(Double(cells))));
        }
    }
    
    var folderPath: String
    {
        get
        {
            return outputPath+"/"+outputName;
        }
    }
    
    var imagePath: String
    {
        get
        {
            return folderPath+"/"+outputName+".png";
        }
    }
    
    var manifestPath: String
    {
        get
        {
            return folderPath+"/"+outputName+"Manifest.json";
        }
    }
    
    //Returns a suitable string to be used as a label for this render setup in the interface
    var label:String
    {
        get
        {
            return "\(outputName) [\(cellSize.rawValue)x\(cellSize.rawValue)] [\(framerate.rawValue)fps]";
        }
    }
}


struct RenderSettings
{
    
}