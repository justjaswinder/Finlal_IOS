//
//  MyEditViewController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class MyEditViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ItemControllerDelegate ,UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    
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
    
    
    var image1: UIImage?
 
   let picker = UIPickerView()
    
    @IBAction func doneBtnPressed(_ sender: Any) {
             
     self.navigationController?.popToRootViewController(animated: true)
        
    }
    var refreshControl = UIRefreshControl()


    
    var mydata = MyData()
    
    var pTitle = ""
  //  var pSubTitle = 0
    var pLatitude = 0.0
    var pLongitude = 0.0
       
    var locationArray = [MyData]()
    var pinsArray = [MyData]()
    
    @IBOutlet weak var birthDateTxt: UITextField!
    
    @IBOutlet weak var imageViewPick: UIImageView!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var genderTxtField: UITextField!
    @IBOutlet weak var latitudeTxtField: UITextField!
    @IBOutlet weak var longitudeTxtField: UITextField!
    
 //   @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var donebarbtn: UIBarButtonItem!
    
      var datePicker = UIDatePicker()
    
    @IBAction func submitBtnPress(_ sender: Any) {
        self.donebarbtn.isEnabled = true

        
         self.fetchAndUpdateTable()
        
        if(titleTxtField.text == "" || genderTxtField.text == "" || latitudeTxtField.text == "" || longitudeTxtField.text == ""){
             
             let alert = UIAlertController(title: "Field is Empty", message: "Please Enter Info", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
             return
         }else{
             
             let dateFormatter = DateFormatter()
             dateFormatter.dateStyle = .long
             dateFormatter.timeStyle = .none
             
             

            
            self.insertRecord(title: titleTxtField.text!, gender: genderTxtField.text!,latitude: Double(latitudeTxtField.text!)!, longitude: Double(longitudeTxtField.text!)!, birthDate: dateFormatter.date(from: birthDateTxt.text!)!, country: countryTxtField.text!, image: 2)
       
            
            
        
        }
        
        
     
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCountry" {
           // isFrom = true
            let controller = segue.destination
                as! CountryViewController
            controller.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
               showDatePicker()
      picker.delegate = self
        picker.dataSource = self
        genderTxtField.inputView = picker
        
        countryTxtField.delegate = self
        countryTxtField.addTarget(self, action: #selector(showCountry), for: .touchDown)
        
        pinsArray = locationArray
        self.donebarbtn.isEnabled = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(MyEditViewController.tappedMe))
               imageViewPick.addGestureRecognizer(tap)
               imageViewPick.isUserInteractionEnabled = true
           }
    
    @objc func showCountry()
              {
             performSegue(withIdentifier: "showCountry", sender: nil)
              }
    @objc func tappedMe()
           {
               print("Tapped on Image")
            pickPhoto()
           }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

     //   managedContext = coreDataStack.managedContext
//    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
//        tableView.addSubview(refreshControl)
        fetchAndUpdateTable()

          
    }

    @objc func refresh() {
       // Code to refresh table view
       // self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func fetchAndUpdateTable(){
           locationArray = fetchRecords()
           pinsArray = locationArray

         //  tableView.reloadData()
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
    @objc func donedatePicker1(){
        

       // genderTxtField.text = picker. datePicker.date)
        self.view.endEditing(true)
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
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
 

    
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
}
// Tableview Datasource and Delegate

extension MyEditViewController{
    func insertRecord(title:String, gender:String,latitude: Double,longitude: Double, birthDate: Date, country: String, image: Int){
       // title:String, subTitle:Int,latitude: Double,longitude: Double){
        let mydata = MyData(context: MyViewController.managedContext)

                 mydata.name = title
              mydata.birthday = birthDate
                 mydata.latitude = latitude
                 mydata.longitude = longitude
               mydata.gender = gender
               mydata.country = country
        
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

       func fetchRecords() -> [MyData]{
          var arrLocation = [MyData]()
          let fetchRequest = NSFetchRequest<MyData>(entityName: "MyData")

              do{
                arrLocation = try MyViewController.managedContext.fetch(fetchRequest)
              }catch{
                  print(error)
              }
              return arrLocation
          }

          func deleteRecord( location : MyData){
            MyViewController.managedContext.delete(location)
            try! MyViewController.managedContext.save()
          }

          func updateRecord(location:MyData,title:String, gender:String,latitude: Double,longitude: Double, birthDate: Date, country: String, image: Int){
                            //itle:String,subTitle:Int,latitude: Double,longitude: Double){


                  location.name = title
                 // location.subtitle = Int32(subTitle)
                  location.latitude = latitude
                  location.longitude = longitude
            try! MyViewController.managedContext.save()
          }





}

