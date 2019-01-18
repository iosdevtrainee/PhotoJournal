//
//  DataPersistanceManager.swift
//  PhotoJournal
//
//  Created by J on 1/14/19.
//  Copyright © 2019 J. All rights reserved.
//

import Foundation
final class DataPersistanceManager {
  
  private init () { }
  
  public static func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  public static func getFilePath(filename:String) -> URL {
    return getDocumentsDirectory().appendingPathComponent(filename)
  }
}
