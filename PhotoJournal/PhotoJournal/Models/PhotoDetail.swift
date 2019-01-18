//
//  PhotoDetail.swift
//  PhotoJournal
//
//  Created by J on 1/14/19.
//  Copyright © 2019 J. All rights reserved.
//

import Foundation
struct PhotoDetail: Codable {
  public let id: UUID
  public let summary: String
  public let imageData: Data
  public let date: Date
  public var formattedDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, yyyy hh:mm a"
    return dateFormatter.string(from: date)
  }
}
