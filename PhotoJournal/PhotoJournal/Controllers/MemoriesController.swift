//
//  ViewController.swift
//  PhotoJournal
//
//  Created by J on 1/14/19.
//  Copyright © 2019 J. All rights reserved.
//

import UIKit

class MemoriesController: UIViewController {
  private var delegate: MemoriesDelegate?
  private var memories = [PhotoDetail]()  {
    didSet {
      memoriesCollection.reloadData()
    }
  }
  private var menuAlert: UIAlertController?
  @IBOutlet weak var memoriesCollection: UICollectionView!
  @IBOutlet weak var memoriesSearchBar: UISearchBar!
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupDelegates()
  }
  
  private func setupDelegates(){
    delegate = self
    memoriesCollection.dataSource = self
    memoriesSearchBar.delegate = self
  }
  
  private func updateMemories() {
    if let memories = delegate?.receiveUpdatedMemories(){
      self.memories = memories
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    updateMemories()
  }

  @IBAction func addMemory(_ sender: UIBarButtonItem) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let photoDetailVC = storyboard.instantiateViewController(withIdentifier: "PhotoDetailVC")
    present(photoDetailVC, animated: true, completion: nil)
  }
  
  private func setupUI(){
    menuAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
  }
  
  @IBAction func showMenu(_ sender: UIButton) {
    let memory = memories[sender.tag]
    if let alertVC = menuAlert {
      if alertVC.actions.count == 0 {
      let editAction = UIAlertAction(title: "Edit", style: .default) {(action) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let photoDetailVC = storyboard.instantiateViewController(withIdentifier: "PhotoDetailVC") as? PhotoDetailController else { return }
        photoDetailVC.editableMemory = memory
        self.present(photoDetailVC, animated: true, completion: nil)
        
      }
      let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {(action) in
        self.delegate?.deleteMemory(photoDetailId: memory.id)
        self.updateMemories()
      }
      let shareAction = UIAlertAction(title: "Share", style: .default) {(action) in
        if let image = UIImage(data: memory.imageData){
          let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
          self.present(shareVC, animated: true, completion: nil)
        }
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
          [editAction,deleteAction,shareAction,cancelAction].forEach { menuAlert?.addAction($0)}
      }
      
      present(alertVC, animated: true, completion: nil)
    }
  }
  @objc private func showImage(sender:UILongPressGestureRecognizer){
    let imageView = sender.view as! UIImageView
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let modalImageVC = storyboard.instantiateViewController(withIdentifier: "ModalImageVC") as? ModalImageController else { return }
    modalImageVC.image = imageView.image
    present(modalImageVC,animated: true,completion: nil)
  }
  
}

extension MemoriesController: MemoriesDelegate {
  
}

extension MemoriesController: UICollectionViewDataSource{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return memories.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = memoriesCollection.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoDetailCell else { return UICollectionViewCell() }
    let memory = memories[indexPath.row]
    let longPressGesture = UILongPressGestureRecognizer()
    longPressGesture.addTarget(self, action: #selector(showImage(sender:)))
    //cell.addGestureRecognizer(longPressGesture)
    cell.photoImageView.addGestureRecognizer(longPressGesture)
    cell.photoImageView.isUserInteractionEnabled = true
    cell.photoDescriptionLabel.text = memory.summary
    cell.photoImageView.image = UIImage(data: memory.imageData)
    cell.photoOptionsButton.tag = indexPath.row
    cell.photoImageView.tag = indexPath.row
    cell.photoTimestampLabel.text = memory.formattedDate
    cell.layer.cornerRadius = 20
    
    return cell
  }
  
}

extension MemoriesController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: UIScreen.main.bounds.height / 2,
           height: UIScreen.main.bounds.width / 2)
  }
}

extension MemoriesController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      updateMemories()
      return
    }
    memories = memories.filter { $0.summary.contains(searchText) }
  }
}

