//
//  ViewController.swift
//  Consolidation_9-Meme_Generator
//
//  Created by Edwin Przeźwiecki Jr. on 01/11/2022.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    var shareButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
    var topLineText: String?
    var bottomLineText: String?
    
    var currentImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme Generator"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let importButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        
        navigationItem.rightBarButtonItems = [spacer, importButton]
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareImage))
        
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editImage))
        
        shareButton.isEnabled = false
        editButton.isEnabled = false
        
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
        currentImage = image
        
        shareButton.isEnabled = true
        editButton.isEnabled = true
    }
    
    @objc func shareImage() {
        
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(vc, animated: true)
    }
    
    @objc func editImage() {
        
        let ac = UIAlertController(title: "Top and bottom lines", message: "Please type in top and bottom line texts. If you need only one of the lines, please leave the other one blank.", preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Save", style: .default) { [weak self, weak ac] _ in
            let newTopLineText = ac?.textFields?[0].text ?? ""
            let newBottomLineText = ac?.textFields?[1].text ?? ""
            
            self?.topLineText = newTopLineText
            self?.bottomLineText = newBottomLineText
            
            self?.drawMeme()
        })
        
        present(ac, animated: true)
    }
    
    func drawMeme() {
        
        guard let image = currentImage else { return }
        
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let meme = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let fontScale = CGFloat((image.size.width + image.size.height) / 30)
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: fontScale),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -2,
                .paragraphStyle: paragraphStyle
            ]
            
            let topLineString = topLineText
            let bottomLineString = bottomLineText
            
            let attributedTopString = NSAttributedString(string: topLineString!, attributes: attributes)
            
            let attributedBottomString = NSAttributedString(string: bottomLineString!, attributes: attributes)
            
            let stringWidth = Int((image.size.width) / 6) * 2
            let textX = Int(image.size.width / 3)
            let topTextY = Int(image.size.height / 8)
            let bottomTextY = Int((image.size.height / 8) * 7)
            
            attributedTopString.draw(with: CGRect(x: textX, y: topTextY, width: stringWidth, height: 100), context: nil)
            
            attributedBottomString.draw(with: CGRect(x: textX, y: bottomTextY, width: stringWidth, height: 100), context: nil)
        }
        
        imageView.image = meme
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

