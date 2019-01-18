//
//  PhotoJournalPersistence.swift
//  PhotoJournal
//
//  Created by J on 1/15/19.
//  Copyright © 2019 J. All rights reserved.
//

import Foundation
struct PhotoJournalModel {
  public static let filename = "Memories.plist"
  public static var memories = getPhotoDetails()
  
  public static func savePhotoDetails(memory: PhotoDetail?) {
    if let memory = memory {
        memories.append(memory)
    }
    let url = DataPersistanceManager.getFilePath(filename: filename)
    if let data = try? PropertyListEncoder().encode(memories) {

      do {
         try data.write(to: url, options: .atomic)
      } catch {
        print(error)
      }
      
    }
    
  }
  
  public static func getPhotoDetails() -> [PhotoDetail] {
    let url = DataPersistanceManager.getFilePath(filename: filename)
    var photoDetails = [PhotoDetail]()
    
    if FileManager.default.fileExists(atPath: url.path) {
      if let data = try? Data(contentsOf: url) {
        
        do {
            photoDetails = try PropertyListDecoder().decode([PhotoDetail].self, from: data)
        } catch {
          print(error)
        }
        
      }
    }
    return photoDetails
  }
  
  public static func deleteMemory(id:UUID){
    if let memoryToDeleteIndex = (memories.firstIndex { $0.id == id }) {
      memories.remove(at: memoryToDeleteIndex)
      savePhotoDetails(memory: nil)
    }
  }
  
  public static func editMemory(memory:PhotoDetail){
    if let memoryToEditIndex = (memories.firstIndex { $0.id == memory.id }) {
      memories[memoryToEditIndex] = memory
      savePhotoDetails(memory: nil)
    }
  }
}
