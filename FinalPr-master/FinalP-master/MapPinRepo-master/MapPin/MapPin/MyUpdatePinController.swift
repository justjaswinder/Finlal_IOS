//
//  MyUpdatePinController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class MyUpdatePinController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ItemControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
 
 var gender_list = ["Male","Female","Other"]
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
   return 1
 }
 
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return  gender_list.count
 }
 
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
return gender_list[row]
 }
 
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     genderTxtField.text = gender_list[row]
 }
 
    func addItemViewController(_ controller: CountryViewController, didFinishAdding item: String) {
        countryTxtField.text = item
                     navigationController?.popViewController(animated:true)
    }
    
    
    
   // var managedContext: NSManagedObjectContext!
       var datePicker = UIDatePicker()
       let picker = UIPickerView()
    @IBOutlet weak var birthDateTxt: UITextField!
     var image1: UIImage?
    @IBOutlet weak var imageViewPick: UIImageView!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var latitudeTxtField: UITextField!
    @IBOutlet weak var longitudeTxtField: UITextField!
    
    
    
    
    
    
    //  var coreDataStack = CoreDataStack(modelName: "MapData")
    @IBAction func updatePindata(_ sender: Any) {
        let dateFormatter = DateFormatter()
                   dateFormatter.dateStyle = .long
                   dateFormatter.timeStyle = .none
                   
        
        self.updateRecord(mydata: locaton, title:titleTxtField.text!, gender: genderTxtField.text!, latitude: Double(latitudeTxtField.text!)!, longitude: Double(longitudeTxtField.text!)!, birthDate: dateFormatter.date(from: birthDateTxt.text!)!, country: countryTxtField.text!, image: 2)
//                          title: tileTxt.text!, subTitle: Int(subtitleTxt.text!)!, latitude: Double(latTxt.text!)!, longitude: Double(longTxt.text!)!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
        
    var locaton = MyData()
    
    
    //image
    func show(image: UIImage) {
        imageViewPick.image = image
        imageViewPick.isHidden = false
        imageViewPick.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
    }
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takePhotoWithCamera()
        })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        image1 = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let theImage = image1 {
            show(image: theImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        picker.delegate = self
          picker.dataSource = self
          genderTxtField.inputView = picker
        
        titleTxtField.text = locaton.name
        let dateFormatter = DateFormatter()
                         dateFormatter.dateStyle = .long
                         dateFormatter.timeStyle = .none
        birthDateTxt.text = dateFormatter.string(from:locaton.birthday!)
        countryTxtField.text = locaton.country?.description
        genderTxtField.text = locaton.gender?.description
         imageViewPick.image = locaton.photoImage
        longitudeTxtField.text = locaton.longitude.description
        latitudeTxtField.text = locaton.latitude.description
             countryTxtField.delegate = self
            countryTxtField.addTarget(self, action: #selector(showCountry), for: .touchDown)
           let tap = UITapGestureRecognizer(target: self, action: #selector(MyEditViewController.tappedMe))
                   imageViewPick.addGestureRecognizer(tap)
                   imageViewPick.isUserInteractionEnabled = true
               }
        
  
        @objc func tappedMe()
               {
                   print("Tapped on Image")
                pickPhoto()
               }
        
        @objc func showCountry()
                  {
                 performSegue(withIdentifier: "updateCountry", sender: nil)
                  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "updateCountry" {
           
              let controller = segue.destination
                  as! CountryViewController
              controller.delegate = self
          }
      }
    func showDatePicker(){
           //Formate Date
           datePicker.datePickerMode = .date
           
           //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
           
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
           
           birthDateTxt.inputAccessoryView = toolbar
           birthDateTxt.inputView = datePicker
        let toolbarNew = UIToolbar();
                           toolbarNew.sizeToFit()
                           let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker1));
                           let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
                           let cancelButton1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                           
                           toolbarNew.setItems([doneButton1,spaceButton1,cancelButton1], animated: false)
                        
                        genderTxtField.inputAccessoryView = toolbarNew
                            genderTxtField.inputView = picker
           
       }
       
       @objc func donedatePicker(){
           
           //          let formatter = DateFormatter()
           //          formatter.dateFormat = "dd/MM/yyyy"
           
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .long
           dateFormatter.timeStyle = .none
           
           birthDateTxt.text = dateFormatter.string(from: datePicker.date)
           self.view.endEditing(true)
        
       
             }
             @objc func donedatePicker1(){
                 

                // genderTxtField.text = picker. datePicker.date)
                 self.view.endEditing(true)
             }
       
       @objc func cancelDatePicker(){
           self.view.endEditing(true)
       }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
            //   managedContext = coreDataStack.managedContext
        
        
    }
    
    

          func updateRecord(mydata:MyData,title:String, gender:String,latitude: Double,longitude: Double, birthDate: Date, country: String, image: Int){
              
                    mydata.name = title
                        mydata.gender = gender
                    mydata.country = country
                    mydata.birthday = birthDate
                  mydata.userImage = image as NSNumber
                        mydata.latitude = latitude
                        mydata.longitude = longitude
            
            if let image = image1 {
                                             mydata.userImage = nil
                                             
                                             if !mydata.hasPhoto {
                                                 mydata.userImage = MyData.nextPhotoID() as NSNumber
                                             // index = mydata.userImage as! Int
                                             }
                                             
                                             if let data = image.jpegData(compressionQuality: 0.5) {
                                                 do {
                                                     try data.write(to: mydata.photoURL, options: .atomic)
                                                 } catch {
                                                     print("Error writing file: \(error)")
                                                 }
                                             }
                                         }
                                         do {
                                             try! MyViewController.managedContext.save()
                                             afterDelay(0.6) {
                                                 
                                                 //   self.navigationController?.popViewController(animated: true)
                                             }
                                         } catch {
                                             fatalCoreDataError(error)
                                         }
            try! MyViewController.managedContext.save()
          }
    
}
// Tableview Datasource and Delegate



