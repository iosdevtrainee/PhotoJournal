//
//  PhotoDetailController.swift
//  PhotoJournal
//
//  Created by J on 1/14/19.
//  Copyright © 2019 J. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoDetailController: UIViewController {
  private var delegate: MemoriesDelegate?
  private var imagePickerController = UIImagePickerController()
  @IBOutlet weak var photoDescriptionEditTextView: UITextView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var cameraImageView: UIImageView!
  public var editableMemory: PhotoDetail?

  
  
  
  @IBAction func dimssTextView(_ sender: UITapGestureRecognizer) {
    photoDescriptionEditTextView.resignFirstResponder()
  }
  override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupDelegates()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    editMemory()
  }
  
  private func setupDelegates(){
    delegate = self
    imagePickerController.delegate = self
    photoDescriptionEditTextView.delegate = self
  }
  
  private func editMemory() {
    if let memory = editableMemory {
      cameraImageView.image = UIImage(data: memory.imageData)
      photoDescriptionEditTextView.text = memory.summary
      delegate?.editMemory(photoDetail:memory)
    }
  }
  
  @IBAction func cancelButton(_ sender: UIBarButtonItem) {
    dismissView()
  }
  
  private func dismissView() {
    dismiss(animated: true, completion: nil)
  }
  
  private func editMemory(memory:PhotoDetail) {
    if let imageData = cameraImageView.image?.jpegData(compressionQuality: 0.5),
      let summary = photoDescriptionEditTextView.text {
      let memory = PhotoDetail(id: memory.id, summary: summary, imageData: imageData, date: memory.date)
      delegate?.editMemory(photoDetail: memory)
      dismissView()
    }
  }
  
  private func saveMemory() {
    let id = UUID()
    let date = Date()
    if let imageData = cameraImageView.image?.jpegData(compressionQuality: 0.5),
      let summary = photoDescriptionEditTextView.text {
      let memory = PhotoDetail(id: id, summary: summary, imageData: imageData, date: date)
      delegate?.updateMemories(photoDetail: memory)
      dismissView()
    }
  }
  
  @IBAction func saveButton(_ sender: UIBarButtonItem) {
    if let memory = editableMemory {
      editMemory(memory:memory)
      return
    }
    saveMemory()
  }
  
  
  
  
  @IBAction func showPhotoLibrary(_ sender: UIBarButtonItem) {
    imagePickerController.sourceType = .photoLibrary
    presentImagePickerController()
  }
  
  @IBAction func takePhoto(_ sender: UIBarButtonItem) {
    imagePickerController.sourceType = .camera
    presentImagePickerController()
  }
  
  private func presentImagePickerController() {
    present(imagePickerController, animated: true, completion: nil)
  }
  
  private func updateUI() {
    if !UIImagePickerController.isSourceTypeAvailable(.camera) {
      cameraButton.isEnabled = false
    }
    
  }

}

extension PhotoDetailController: MemoriesDelegate {
  
}

extension PhotoDetailController : UIImagePickerControllerDelegate{
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      cameraImageView.image = image
    } else {
      print("original image is nil")
    }
    dismiss(animated: true, completion: nil)
  }
}

extension PhotoDetailController: UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

extension PhotoDetailController: UITextViewDelegate {
  func textViewDidEndEditing(_ textView: UITextView) {
    textView.resignFirstResponder()
  }
}
