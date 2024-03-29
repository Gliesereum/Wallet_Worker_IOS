//
//  SingleOrderVC.swift
//  Karma
//
//  Created by macbook on 05/04/2019.
//  Copyright © 2019 Gliesereum. All rights reserved.
//

import UIKit
import Alamofire
import MaterialComponents

class SingleOrdersServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}
class SingleOrdersPackegeServiceCell: UITableViewCell{
    
    @IBOutlet weak var service: UILabel!
}

class SingleOrderVC: UIViewController, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    let constants = Constants()
    let utils = Utils()
    var pushRecordId = ""
    
    
   
    

    @IBOutlet weak var packetServiceTable: UITableView!
    @IBOutlet weak var serviceTable: UITableView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var carInfo: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var canselBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var viewPackege: UIView!
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var viewCansel: UIView!
    @IBOutlet weak var showRoate: MDCButton!
    @IBOutlet weak var autoLable: UILabel!
    @IBOutlet weak var autoView: UIView!
    @IBOutlet weak var worker: UILabel!
    
    var currentTable = UITableView()
    var record: ContentRB? = nil
    var cancelMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if record?.packageDto == nil || record?.packageDto?.services?.count == 0 {
//            viewPackege.visiblity(gone: true)
//        }
//        if record?.services == nil || record?.services?.count == 0 {
//            viewService.visiblity(gone: true)
//        }
//        getPushRecord(pushRecordId: (record?.id)!)
       NotificationCenter.default.addObserver(self, selector: #selector(getPushNatRecord), name: Notification.Name(rawValue: "reloadTheTable"), object: nil)
//        utils.checkPushNot(vc: self)
        if record != nil{
        utils.setBorder(view: headerView, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        packetServiceTable.rowHeight = UITableView.automaticDimension
      
        packetServiceTable.tableFooterView = UIView()
        packetServiceTable.layoutIfNeeded()
        packetServiceTable.invalidateIntrinsicContentSize()
//            packetServiceTable.bottomAnchor.constraint(equalTo:self.view.centerYAnchor, constant:-7).isActive=true
        
        serviceTable.rowHeight = UITableView.automaticDimension
           
            serviceTable.tableFooterView = UIView()
            serviceTable.layoutIfNeeded()
            serviceTable.invalidateIntrinsicContentSize()
//            serviceTable.bottomAnchor.constraint(equalTo:self.view.centerYAnchor, constant:-7).isActive=true
        print(packetServiceTable.contentSize.height )
        
        status.text = utils.checkStatus(status: (record?.statusProcess)!)
        date.text = utils.milisecondsToDateB(miliseconds: (record?.begin)!)
        time.text = utils.milisecondsToTime(miliseconds: (record?.begin)!, timeZone: (record?.business?.timeZone)!)
        price.text = String((record?.price)!) + " грн"
        duration.text = String(((record?.finish)! - (record?.begin)!)/60000) + " мин"
        name.text = record?.business?.name
        status.text = utils.checkStatus(status: (record?.statusProcess)!) 
        utils.setBorder(view: canselBtn, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1), borderWidth: 1, cornerRadius: 8)
        }
        if (self.utils.getSharedPref(key: "OBJECTID")) != nil{
        } else {
            checkNil()
            getWorkerInfo()
            chackTarget()
        }
        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func getPushNatRecord(){
        getPushRecord(pushRecordId: (record?.id)!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func showDirection(_ sender: Any) {
        
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        
        showDialog(.slideLeftRight)
        
    }
    func showDialog(_ animationPattern: LSAnimationPattern) {
        let dialogViewController = CancelOrderDialog(nibName: "CancelOrderDialog", bundle: nil)
        dialogViewController.delegate = self
        dialogViewController.id = record?.id
        presentDialogViewController(dialogViewController, animationPattern: animationPattern)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        currentTable = tableView
        if currentTable == packetServiceTable{
            guard record?.packageDto != nil else {
                return 0
            }
            print(record?.packageDto?.services!.count)
            return (record?.packageDto?.services!.count)!
        }else if currentTable == serviceTable{
            guard record?.services != nil else {
                return 0
            }
            print(record?.services!.count)
            return (record?.services!.count)!
        }else {
            return 0    }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        currentTable = tableView
        
        
        currentTable.rowHeight = UITableView.automaticDimension
        currentTable.tableFooterView = UIView()
        if currentTable == packetServiceTable{
            guard record?.packageDto != nil else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
                self.viewPackege.visiblity(gone: true)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersPackegeServiceCell", for: indexPath) as! SingleOrdersPackegeServiceCell
            
            utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
        let packegeService = record?.packageDto?.services?[indexPath.section]
            cell.service.text = packegeService?.name
            return cell
        } else if currentTable == serviceTable{
            guard record?.services != nil else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
                
                self.viewService.visiblity(gone: true)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
            let service = record?.services?[indexPath.section]
            
            utils.setBorder(view: cell, backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), borderColor: #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 0.8412617723), borderWidth: 1, cornerRadius: 4)
            cell.service.text = service?.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
            return cell
        }
    }
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
        
    }
    
    func getCarInfo(){
        showActivityIndicator()
        let carId = record?.targetID
        guard carId != nil else{
            self.hideActivityIndicator()
            return
        }
        let restUrl = constants.startUrl + "karma/v1/car/\(carId!)"
        var carInfo = ""
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            do{
                let carList = try JSONDecoder().decode(AllCarListElement.self, from: response.data!)
                carInfo = (carList.brand?.name)! + " " + (carList.model?.name)!
                
                self.carInfo.text = carInfo
             
            }
            catch{
                
            }
            
            self.hideActivityIndicator()
            
          
            
       
            
        }
    }
    
    func getWorkerInfo(){
        showActivityIndicator()
        let workerId = record?.workerID
        guard workerId != nil else{
            self.hideActivityIndicator()
            return
        }
        let restUrl = constants.startUrl + "karma/v1/worker/by-id?id=\(workerId!)"
        var carInfo = ""
        Alamofire.request(restUrl, method: .get, encoding: JSONEncoding.default, headers: ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]).responseJSON { response  in
            guard self.utils.checkResponse(response: response, vc: self) == true else{
                self.hideActivityIndicator()
                return
            }
            do{
                let worker = try JSONDecoder().decode(Worker.self, from: response.data!)
                let workerInfo = (worker.user?.firstName)! + " " + (worker.user?.lastName)!
                
                self.worker.text = workerInfo
                
            }
            catch{
                print(error)
            }
            
            self.hideActivityIndicator()
            
            
            
            
            
        }
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        currentTable = tableView
//
//        if currentTable == packetServiceTable{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersPackegeServiceCell", for: indexPath) as! SingleOrdersPackegeServiceCell
//            let packegeService = record?.packageDto?.services?[indexPath.row]
//            cell.service.text = packegeService?.name
//            return cell
//        } else if currentTable == serviceTable{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
//            let service = record?.services?[indexPath.row]
//            cell.service.text = service?.name
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "singleOrdersServiceCell", for: indexPath) as! SingleOrdersServiceCell
//        return cell
//        }
//    }
    func dismissDialog(chouse: Bool) {
        dismissDialogViewController(LSAnimationPattern.fadeInOut)
        if chouse == true {
//            getCarWashInfoComments()
           
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
//        utils.checkPushNot(vc: self)
        
        guard utils.getSharedPref(key: "accessToken") != nil else{
           
            
            self.utils.checkAutorization(vc: self)
//            self.utils.checkFilds(massage: "Авторизируйтесь", vc: self.view)
            hideActivityIndicator()
            return
        }
        
        
        if (self.utils.getSharedPref(key: "OBJECTID")) != nil{
            
            let pushRecordId = (self.utils.getSharedPref(key: "OBJECTID"))!
            getPushRecord(pushRecordId: pushRecordId)
        }
        if UserDefaults.standard.object(forKey: "SINGLEORDERVC") == nil{
            
            self.utils.setSaredPref(key: "SINGLEORDERVC", value: "true")
            self.showTutorial()
        }
        
        
    }
    
    func showTutorial() {
        let infoDesc = InfoDescriptor(for: "Здесь будет отображаться подробная информация о вашем заказе")
        var infoTask = PassthroughTask(with: [])
        infoTask.infoDescriptor = infoDesc
        
        
        let leftDesc = LabelDescriptor(for: "Чтобы проложить маршрут нажмите сюда")
        leftDesc.position = .bottom
        let leftHoleDesc = HoleViewDescriptor(view: showRoate, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc.labelDescriptor = leftDesc
        let rightLeftTask = PassthroughTask(with: [leftHoleDesc])
        
        
        let leftDesc1 = LabelDescriptor(for: "Чтобы отменить заказ нажмите сюда")
        leftDesc1.position = .bottom
        let leftHoleDesc1 = HoleViewDescriptor(view: canselBtn, type: .rect(cornerRadius: 5, margin: 10))
        leftHoleDesc1.labelDescriptor = leftDesc1
        let rightLeftTask1 = PassthroughTask(with: [leftHoleDesc1])
        
//        let buttonItemView = addCarItem.value(forKey: "view") as? UIView
//        let leftDesc2 = LabelDescriptor(for: "Чтобы добавить машину нажмите сюда")
//        leftDesc2.position = .left
//        let leftHoleDesc2 = HoleViewDescriptor(view: buttonItemView!, type: .circle)
//        leftHoleDesc2.labelDescriptor = leftDesc2
//        let rightLeftTask2 = PassthroughTask(with: [leftHoleDesc2])
//
        
        
        PassthroughManager.shared.display(tasks: [infoTask, rightLeftTask]) {
            isUserSkipDemo in
            
            print("isUserSkipDemo: \(isUserSkipDemo)")
        }
    }
    func checkNil(){
        if record?.packageDto == nil || record?.packageDto?.services?.count == 0{
            self.viewPackege.visiblity(gone: true)
            self.packageLabel.visiblity(gone: true)
            self.packetServiceTable.visiblity(gone: true)
        }
        if record?.services == nil || record?.services?.count == 0 {
            self.viewService.visiblity(gone: true)
            self.serviceLabel.visiblity(gone: true)
            self.serviceTable.visiblity(gone: true)
        }
        
        
        switch record?.statusProcess {
        case "CANCELED":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        case "IN_PROCESS":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        case "COMPLETED":
            self.canselBtn.visiblity(gone: true)
            self.viewCansel.visiblity(gone: true)
        default:
            break
        
        }
    }
    func getPushRecord(pushRecordId: String){
            showActivityIndicator()
            UserDefaults.standard.removeObject(forKey: "OBJECTID")
        let restUrl = constants.startUrl + "karma/v1/record/\(pushRecordId)"
            guard UserDefaults.standard.object(forKey: "accessToken") != nil else{
           
                self.utils.checkAutorization(vc: self)
                hideActivityIndicator()
                return
            }
            let headers = ["Authorization" : (self.utils.getSharedPref(key: "accessToken"))!, "Application-Id":self.constants.iosId]
            Alamofire.request(restUrl, method: .get, headers: headers).responseJSON { response  in
                
                guard self.utils.checkResponse(response: response, vc: self) == true else{
                    self.hideActivityIndicator()
                    return
                }
                
                do{
                    let carList = try JSONDecoder().decode(ContentRB.self, from: response.data!)
                    self.record = carList
                    self.packetServiceTable.reloadData()
                    self.packetServiceTable.invalidateIntrinsicContentSize()
                    self.serviceTable.reloadData()
                    
                    self.serviceTable.invalidateIntrinsicContentSize()
                    self.viewDidLoad()
                    
                    self.checkNil()
                    self.getWorkerInfo()
                    self.chackTarget()
                }
                catch{
                    print(error)
                }
                
                self.hideActivityIndicator()
                
                
            }
        }

    func chackTarget(){
        if record?.business?.businessCategory?.businessType != "CAR" {
            
            self.autoView.visiblity(gone: true)
        } else {
            getCarInfo()
        }
    }
    
}
