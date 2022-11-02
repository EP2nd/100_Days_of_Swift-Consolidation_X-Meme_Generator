//
//  ViewController.swift
//  Consolidation_9-Meme_Generator
//
//  Created by Edwin Przeźwiecki Jr. on 01/11/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.rightBarButtonItems = [spacer, importButton]
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editImage))
        toolbarItems = [shareButton, spacer, editButton]
        navigationController?.isToolbarHidden = false
        
        drawWelcomeScreen()
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        imageView.image = image
    }
    
    @objc func shareImage() {
        
    }
    
    @objc func editImage() {
        
    }
    
    func drawWelcomeScreen() {
        let imageViewSize = imageView.frame.size
        let renderer = UIGraphicsImageRenderer(size: imageViewSize)
        
        let welcomeScreen = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.systemGray,
                .paragraphStyle: paragraphStyle
            ]
            
            let welcomeString = "Add an image to proceed"
            let attributedString = NSAttributedString(string: welcomeString, attributes: attributes)
            
            let marginSize = 32
            let stringWidth = Int(imageViewSize.width) - (marginSize * 2)
            let stringY = Int(imageViewSize.height) / 2
            
            attributedString.draw(with: CGRect(x: marginSize, y: stringY, width: stringWidth, height: 32), options: .usesLineFragmentOrigin, context: nil)
        }
        imageView.image = welcomeScreen
    }
}

