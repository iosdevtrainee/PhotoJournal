//
//  MemoriesDelegate.swift
//  PhotoJournal
//
//  Created by J on 1/14/19.
//  Copyright © 2019 J. All rights reserved.
//

import Foundation

protocol MemoriesDelegate: class {
  
  func updateMemories(photoDetail:PhotoDetail)
  func receiveUpdatedMemories() -> [PhotoDetail]
  func deleteMemory(photoDetailId: UUID)
  func editMemory(photoDetail:PhotoDetail)
  
}

extension MemoriesDelegate {
  func updateMemories(photoDetail:PhotoDetail){
    PhotoJournalModel.savePhotoDetails(memory: photoDetail)
  }
  func receiveUpdatedMemories() -> [PhotoDetail] {
    return PhotoJournalModel.getPhotoDetails()
  }
  func deleteMemory(photoDetailId: UUID) {
    PhotoJournalModel.deleteMemory(id: photoDetailId)
  }
  func editMemory(photoDetail:PhotoDetail){
    PhotoJournalModel.editMemory(memory: photoDetail)
  }
}
