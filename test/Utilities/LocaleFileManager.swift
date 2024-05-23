//
//  LocaleFileManager.swift
//  test
//
//  Created by rabie houssaini on 26/5/2024.
//

import Foundation
import SwiftUI
class LocaleFileManager {
    static let instance = LocaleFileManager()
    private init(){
        
    }
    
    func saveImage(image:UIImage,ImageName:String , folderName: String){
        createFolderIfNeded(folderName: folderName)
         guard  let data  = image.pngData(), let url = getURLForImage(imageName: ImageName, folderName: folderName) else {return}
         
         do {
             try  data.write(to: url)
         } catch let error {
             print("error saving image \(error.localizedDescription)")
         }
    }
    
    func getImage(imageName:String, folderName:String)->UIImage?{
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),FileManager.default.fileExists(atPath: url.path) else {return nil}
        return UIImage(contentsOfFile: url.path)
    }
    
    
    private func createFolderIfNeded(folderName: String){
        guard let url = getURLForFolder(folderName: folderName)
        else {return}
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error creating directory \(error)")
            }
        }
    }
    private func getURLForFolder(folderName:String)->URL?{
        guard  let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else
        {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName:String, folderName:String)->URL?{
        guard let folderURL = getURLForFolder(folderName: folderName) else{return nil }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
}
