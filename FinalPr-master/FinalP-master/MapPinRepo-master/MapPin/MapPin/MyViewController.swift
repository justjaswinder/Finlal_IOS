//
//  MyViewController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class MyViewController: UIViewController,MKMapViewDelegate,UISearchBarDelegate{
    
    
    var isEmpty = false
    @IBOutlet weak var listView: UIView!
    var selectPinView: MKAnnotation!
   static var managedContext: NSManagedObjectContext!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
   
    var dataSingle = MyData()
    var pTitle = ""
    var pSubTitle = 0
    var pLatitude = 0.0
    var pLongitude = 0.0
    var locationDataArray = [MyData]()
    
    var filterArray = [MyData]()
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var serachBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tableView.delegate = self
           tableView.dataSource = self
           serachBar.delegate = self
   //        filterArray = locationDataArray
//        if(filterArray.count > 0){
//            isEmpty = false
//        }else{
//            isEmpty = true
//            var newEle = Location()
//            filterArray.append(newEle)
//        }
        
    }
    
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            //MAP
            // Do something
            
            mapView.isHidden = false
            listView.isHidden = true
           // tableView.isHidden = false
          //  hideStackView.isHidden = true
//            if filterArray.count == 0{
//                alertBox(msg: "No Data Found")
//                return
//            }
            print("iOS");
            setPins()
            break
            
        default:
            //List
    
            mapView.isHidden = true
                      listView.isHidden = false
                fetchUpdateTable()
            print("iO");
            break
        }
        
    }
    
    // Button Actions
    @IBAction func editBtnPressed(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyEditViewController") as? MyEditViewController {
            
//            viewController.latitude = pLatitude
//            viewController.longitude = pLongitude
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterArray = searchText.isEmpty ? locationDataArray : locationDataArray.filter({ (personString: MyData) -> Bool in
            
            return personString.name?.range(of: searchText, options:  .caseInsensitive) != nil
        })
        
     
                if(filterArray.count > 0){
                    isEmpty = false
                }else{
                    isEmpty = true
     
              }
        tableView.reloadData()
    }
    
    func setPins() {
        
        var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        print("latitude" + "\(locValue.latitude)")
        print("latitude" + "\(locValue.longitude)")
        
        
        var pinPoint = [MKPointAnnotation]()
        
        locationDataArray = fetchRecords()
           mapView.removeAnnotations(mapView.annotations)
        
        if(locationDataArray.count>0){
//        for i in 0..<locationDataArray.count{
//            let annotation = MKPointAnnotation()
//
        locValue.latitude = locationDataArray[locationDataArray.count-1].latitude
            locValue.longitude = locationDataArray[locationDataArray.count-1].longitude
//
//            annotation.coordinate = locValue
//            mapView.isZoomEnabled = false
//
//
//
//            annotation.title = locationDataArray[i].name
//            annotation.subtitle = locationDataArray[i].name//.description
//
//            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
//
//            pinPoint.append(annotation)
//            //  mapView.addAnnotation(annotation)
        }
        mapView.addAnnotations(locationDataArray)//pinPoint)
        
        let loca = CLLocationCoordinate2DMake(locValue.latitude,
                                              locValue.longitude)
        let coordinateRegion = MKCoordinateRegion(center: loca,
                                                  latitudinalMeters: 4000000, longitudinalMeters: 4000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func fetchUpdateTable(){
           locationDataArray = fetchRecords()
           filterArray = locationDataArray
     if(filterArray.count > 0){
                     isEmpty = false
                 }else{
                     isEmpty = true
      
               }
           tableView.reloadData()
  
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //     mapDelegate()
        
    
        
        let nibNo = UINib.init(nibName: "NoDataTableViewCell", bundle: nil)
            self.tableView.register(nibNo, forCellReuseIdentifier: "noDataCell")
        let nib = UINib.init(nibName: "CustomTableViewCell", bundle: nil)
         self.tableView.register(nib, forCellReuseIdentifier: "myCell")
//
       // tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "myCell")
               fetchUpdateTable()
        setPins()
    }
    
    
    // Map Functions To get the location for the user
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard annotation is MyData else {
//              return nil
//
//
//            }
        selectPinView = annotation
      
        let identifier = "Location"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))

            
            let rightButton = UIButton(type: .infoDark)
            rightButton.tag = annotation.hash
            rightButton.addTarget(self, action: #selector(annoBtnPressed), for: .touchDown)
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
               //  let button = pinView.rightCalloutAccessoryView  as! UIButton
         
//            for i in 0..<self.locationDataArray.count{
//                if(self.locationDataArray[i].name ==  pinView.annotation?.subtitle ){
//                                    //   self.dataSingle = self.locationDataArray[i]
//                    button.tag = i
//                                       break
//                                   }}
            
//            if let index = filterArray.firstIndex(of: annotation as! MyData) {
//                                button.tag = index
//                             }
            
                  //if let annotationView = annotationView {
//            pinView.annotation = annotation
                               let button = pinView.rightCalloutAccessoryView as! UIButton
            if let index = locationDataArray.firstIndex(of: annotation as! MyData) {
                                    button.tag = index
                               }
//                             }
            
            let leftButton = UIButton(type: .close)
            leftButton.tag = annotation.hash
            leftButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchDown)
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.leftCalloutAccessoryView = leftButton
            
        
//                 if let annotationView = annotationView {
//                   annotationView.annotation = annotation
//                   let button = annotationView.rightCalloutAccessoryView as! UIButton
//                    if let index = locationDataArray.firstIndex(of: annotation as! MyData) {
//                        button.tag = 22;//index
//                   }
//                 }
//
            return pinView
        }
        else {
            return nil
        }
    }
    
    @objc func annoBtnPressed(_ sender: UIButton){
        self.view.layoutIfNeeded()
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyUpdatePinController") as? MyUpdatePinController {
                   
                   
//                   for i in 0..<self.locationDataArray.count{
//                    if(self.locationDataArray[i].name ==  selectPinView?.subtitle ){
//                           self.dataSingle = self.locationDataArray[i]
//                           break
//                       }}
//
            let button = sender as! UIButton
            print("JASS \(button.tag)")
            let dataF = filterArray[button.tag]
          
                   viewController.locaton = dataF//self.dataSingle
                   
                   
                   if let navigator1 = self.navigationController {
                       navigator1.pushViewController(viewController, animated: true)
                   }
  
        }}
    @objc func deleteBtnPressed(){
        self.view.layoutIfNeeded()
        for i in 0..<self.locationDataArray.count{
            if(self.locationDataArray[i].name ==  selectPinView?.subtitle ){
                           self.deleteRecord(mydata: self.locationDataArray[i])
                           
                           self.setPins()
                           break
                       }
                   }
     
    }
 
    func insertRecord(title:String, gender:String,latitude: Double,longitude: Double, birthDate: Date, country: String, image: Int){
        let mydata = MyData(context: MyViewController.managedContext)
    
           mydata.name = title
              mydata.gender = gender
          mydata.country = country
          mydata.birthday = birthDate
        mydata.userImage = image as NSNumber
              mydata.latitude = latitude
              mydata.longitude = longitude
                 
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

          func deleteRecord( mydata : MyData){
            MyViewController.managedContext.delete(mydata)
            try! MyViewController.managedContext.save()
          }
          
          func updateRecord(location:MyData,
                            //title:String,subTitle:Int,latitude: Double,longitude: Double){
              title:String, gender:String,latitude: Double,longitude: Double, birthDate: Date, country: String, image: Int){
              
                  location.name = title
                  location.gender = gender
              location.country = country
              location.birthday = birthDate
            location.userImage = image as NSNumber
                  location.latitude = latitude
                  location.longitude = longitude
            try! MyViewController.managedContext.save()
          }
    
    @objc func refresh() {
       // Code to refresh table view
        if(filterArray.count > 0){
                        isEmpty = false
                    }else{
                        isEmpty = true
         
                  }
        self.tableView.reloadData()
      //  self.refreshControl.endRefreshing()
    }

}

extension MyViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        if(isEmpty){
                  return 1
        }else{
          
        return filterArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyUpdatePinController") as? MyUpdatePinController {
                   
            let person = filterArray[indexPath.row]
                   viewController.locaton = person
                   
                   
                   if let navigator1 = self.navigationController {
                       navigator1.pushViewController(viewController, animated: true)
                   }
        }}
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //   var      cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomTableViewCell
        if(isEmpty){
            
      let   cellno = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as? NoDataTableViewCell
      //  cellno?.textLabel?.text = "gvghghfgh"
           return cellno!
      
       }else{
           let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? CustomTableViewCell
        let person = filterArray[indexPath.row]

        cell?.nameTxt?.text = person.name!
        cell?.genderTxt?.text = person.gender
            cell?.imgv.image = person.photoImage
            cell?.countryTxt?.text = person.country
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
            cell?.birthTxt?.text = dateFormatter.string(from: person.birthday!)
             cell?.latText?.text = String(person.latitude)
        cell?.longTxt?.text = String(person.longitude)//


       return cell!
    }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let location = filterArray[indexPath.row]
            deleteRecord(mydata: location)
            fetchUpdateTable()
        }
    }
  
  

}

// Map Delegate functons




