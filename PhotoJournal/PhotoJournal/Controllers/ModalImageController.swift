//
//  ModalImageController.swift
//  PhotoJournal
//
//  Created by J on 1/18/19.
//  Copyright © 2019 J. All rights reserved.
//

import UIKit

class ModalImageController: UIViewController {
  public var image: UIImage!
  @IBOutlet weak var modalImage: UIImageView!
  override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
  private func updateUI(){
    modalImage.image = image
  }
}
