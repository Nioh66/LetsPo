//
//  BoardBgImageSetVC.swift
//  LetsPo
//
//  Created by Pin Liao on 2017/7/20.
//  Copyright © 2017年 Walker. All rights reserved.
//

import Foundation
import UIKit

class BoardBgImageSetVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var photographer = UIImagePickerController()
    let imageFactory = MyPhoto()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageWidth = self.view.frame.size.width/3
        let imageHight = self.view.frame.size.height/5
        let width_Padding = self.view.frame.size.width/9
        let hight_Padding = self.view.frame.size.height/10
        
        
        
        let tapDefault = UITapGestureRecognizer(target: self, action: #selector(getDefaultBg))
        let tapGetPhotos = UITapGestureRecognizer(target: self, action: #selector(getPhotosBg))
        let tapTakePhoto = UITapGestureRecognizer(target: self, action: #selector(takeBgPhoto))
        
        let defaultBg01 = UIImageView(frame: CGRect(x: width_Padding, y: hight_Padding, width: imageWidth, height: imageHight))
        
        let defaultBg02 = UIImageView(frame: CGRect(x: (width_Padding*2)+imageWidth, y: hight_Padding, width: imageWidth, height: imageHight))
        
        let defaultBg03 = UIImageView(frame: CGRect(x: width_Padding, y: hight_Padding*2+imageHight, width: imageWidth, height: imageHight))
        
        let defaultBg04 = UIImageView(frame: CGRect(x: (width_Padding*2)+imageWidth, y: hight_Padding*2+imageHight, width: imageWidth, height: imageHight))
        
        let photosBg = UIImageView(frame: CGRect(x: width_Padding, y: hight_Padding*3+imageHight*2, width: imageWidth, height: imageHight))
        
        let takeAPhoto = UIImageView(frame: CGRect(x: (width_Padding*2)+imageWidth, y: hight_Padding*3+imageHight*2, width: imageWidth, height: imageHight))
        
        defaultBg01.image = UIImage(named: "ooxx")
        //   defaultBg01.image = UIImage(contentsOfFile: "ooxx")
        defaultBg02.image = UIImage(named: "myNigger.jpg")
        defaultBg03.image = UIImage(named: "whiteboard-303145_960_720")
        defaultBg04.image = UIImage(named: "Sky.jpg")
        photosBg.image = UIImage(named: "Photos")
        takeAPhoto.image = UIImage(named: "takePhoto")
        
        
        
        defaultBg01.layer.cornerRadius = 100.0
        defaultBg02.layer.cornerRadius = 100.0
        defaultBg03.layer.cornerRadius = 100.0
        defaultBg04.layer.cornerRadius = 100.0
        photosBg.layer.cornerRadius = 100.0
        takeAPhoto.layer.cornerRadius = 10.0
        //        defaultBg01.backgroundColor = UIColor.red
        //        defaultBg02.backgroundColor = UIColor.green
        //        defaultBg03.backgroundColor = UIColor.blue
        //        defaultBg04.backgroundColor = UIColor.brown
        //        photosBg.backgroundColor = UIColor.gray
        //        takeAPhoto.backgroundColor = UIColor.black
        defaultBg01.isUserInteractionEnabled = true
        defaultBg02.isUserInteractionEnabled = true
        defaultBg03.isUserInteractionEnabled = true
        defaultBg04.isUserInteractionEnabled = true
        photosBg.isUserInteractionEnabled = true
        takeAPhoto.isUserInteractionEnabled = true
        
        
        
        defaultBg01.addGestureRecognizer(tapDefault)
        defaultBg02.addGestureRecognizer(tapDefault)
        defaultBg03.addGestureRecognizer(tapDefault)
        defaultBg04.addGestureRecognizer(tapDefault)
        photosBg.addGestureRecognizer(tapGetPhotos)
        takeAPhoto.addGestureRecognizer(tapTakePhoto)
        
        self.view.addSubview(defaultBg01)
        self.view.addSubview(defaultBg02)
        self.view.addSubview(defaultBg03)
        self.view.addSubview(defaultBg04)
        self.view.addSubview(photosBg)
        self.view.addSubview(takeAPhoto)
        
        
    }
    
    func getDefaultBg(){
        print("get the default bg pic!")
    }
    func getPhotosBg(){
        self.addPictureBtn()
        print("get the bg pic from photos!")
    }
    func takeBgPhoto(){
        self.takePictureBtn()
        print("Take the photo for bg!")
        
    }
    
    
    
    // MARK: Add photo from photos
    
    func addPictureBtn() {
        let checkDeviceAccesse = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        if (checkDeviceAccesse){
            
            let importImage = UIImagePickerController()
            importImage.sourceType = .photoLibrary
            importImage.delegate = self
            importImage.allowsEditing = true
            
            present(importImage, animated: true, completion: nil)
        }
        else{
            print("Your photoLibrary are unvailable")
        }
    }
    
    // MARK: Take photo
    
    func takePictureBtn() {
        let checkDeviceAccesse = UIImagePickerController.isSourceTypeAvailable(.camera)
        if (checkDeviceAccesse){
            
            photographer = UIImagePickerController()
            photographer.sourceType = .camera
            photographer.cameraDevice = .rear
            photographer.allowsEditing = true
            photographer.delegate = self
            
            present(photographer, animated: true, completion: nil)
        }
        else{
            print("Your camera are unvailable")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let saveAlert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            saveAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(saveAlert, animated: true)
        } else {
            let saveAlert = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            saveAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(saveAlert, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            else{
                return
        }
        //resize image
        guard let imageX = imageFactory.resizeFromImage(input: image)
            else {
                return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageX, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}
