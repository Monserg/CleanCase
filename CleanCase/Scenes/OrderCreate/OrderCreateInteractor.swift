//
//  OrderCreateInteractor.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Business Logic protocols
protocol OrderCreateBusinessLogic {
    func saveSelectedDate(byRow row: Int)
    func saveSelectedTime(byRow row: Int)
    func saveOrder(fromJSON json: [String: Any])
    func updateDepartment(selectedState isSelected: Bool, byRow row: Int)
    func addOrder(withRequestModel requestModel: OrderCreateModels.Order.RequestModel)
    func fetchDates(withRequestModel requestModel: OrderCreateModels.Dates.RequestModel)
    func fetchDepartments(withRequestModel requestModel: OrderCreateModels.Departments.RequestModel)
}

protocol OrderCreateDataStore {
    var orderID: String? { get set }
    var dateEntitiesFiltered: [DeliveryDate]! { get set }
    var dates: [PickerViewSupport]! { get set }
    var times: [PickerViewSupport]! { get set }
    var departments: [OrderCreateModels.Departments.RequestModel.DisplayedDepartment]! { get set }
    var selectedDateRow: Int { get set }
    var selectedTimeRow: Int { get set }
    var textFieldsTexts: [ (placeholder: String, errorText: String) ] { get set }
}

class OrderCreateInteractor: ShareInteractor, OrderCreateBusinessLogic, OrderCreateDataStore {
    // MARK: - Properties
    var presenter: OrderCreatePresentationLogic?
    
    // OrderCreateDataStore protocol implementation
    var orderID: String?
    var selectedDateRow: Int = 0
    var selectedTimeRow: Int = 0

    var textFieldsTexts: [ (placeholder: String, errorText: String) ] = [
        (placeholder: "Enter Address".localized(), errorText: "Please, enter address...".localized()),
        (placeholder: "Select Collection Date".localized(), errorText: "Please, select collection date...".localized()),
        (placeholder: "Select Collection Time".localized(), errorText: "Please, select collection time...".localized())
    ]

    var dateEntitiesFiltered: [DeliveryDate]!
    var dates: [PickerViewSupport]! = [PickerViewSupport]()
    var times: [PickerViewSupport]!
    var departments: [OrderCreateModels.Departments.RequestModel.DisplayedDepartment]! = [OrderCreateModels.Departments.RequestModel.DisplayedDepartment]()

    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .Severe)
    }
    

    // MARK: - Business logic implementation
    func saveSelectedDate(byRow row: Int) {
        self.selectedDateRow = row
        self.times = (dates[row] as! OrderCreateModels.Dates.RequestModel.DateForPickerView).times
    }
    
    func saveSelectedTime(byRow row: Int) {
        self.selectedTimeRow = row
    }

    func saveOrder(fromJSON json: [String: Any]) {
        // Add new Order to CoreData
        if let order = self.appDependency.coreDataManager.createEntity("Order") as? Order {
            order.updateEntity(fromJSON: json)
            Logger.log(message: "CoreData 'Save Order' success: Order data = \(json)", event: .Verbose)
        }
    }
    
    func updateDepartment(selectedState isSelected: Bool, byRow row: Int) {
        departments[row].isSelected = isSelected
    }
    
    func addOrder(withRequestModel requestModel: OrderCreateModels.Order.RequestModel) {
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .addOrder(requestModel.bodyParams, true), andResponseType: ResponseAPIAddOrderResult.self, completionHandler: { [unowned self] responseAPI in
            if let result = responseAPI.model as? ResponseAPIAddOrderResult {
                self.orderID = result.AddOrderResult
                Logger.log(message: "CoreData 'Add Order' success: Order ID = \(self.orderID!)", event: .Verbose)
            }
            
            let responseModel = OrderCreateModels.Order.ResponseModel(error: (self.orderID == nil) ? NSError.init(domain: "BAD_REQUEST_400", code: 400, userInfo: nil) : nil)
            self.presenter?.presentAddOrder(fromResponseModel: responseModel)
        })
    }
    
    func fetchDates(withRequestModel requestModel: OrderCreateModels.Dates.RequestModel) {
        // CoreData: Fetch data
        for i in 1...8 {
            let date = (i == 1) ? Date().globalTime() : Date().globalTime().addingTimeInterval(TimeInterval((i - 1) * 24 * 60 * 60))
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)
            
            if dateComponents.weekday! != 7 {
                if let dateEntities = appDependency.coreDataManager.readEntities(withName: "CollectionDate",
                                                                                 withPredicateParameters: NSPredicate.init(format: "weekDay == \(dateComponents.weekday!)"),
                                                                                 andSortDescriptor: nil) as? [CollectionDate], dateEntities.count > 0 {
                    // Times
                    let dateEntity  =   dateEntities.first!
                    var dateTimes   =   [PickerViewSupport]()
                    let weekDate    =   String.createDateString(fromComponents: dateComponents, withDateFormat: "dd/MM/yyyy")
                    let bodyDate    =   String.createDateString(fromComponents: dateComponents, withDateFormat: "yyyy-MM-dd")

                    // Check times for current date
                    for (index, dateEntity) in dateEntities.enumerated() {
                        if (i == 1 && dateEntity.fromDate.convertToFloat() >= (Float(dateComponents.hour! + 1) + Float(dateComponents.minute!) / 100)) || i != 1 {
                            dateTimes.append(OrderCreateModels.Dates.RequestModel.TimeForPickerView(id:             Int16(index),
                                                                                                    title:          "\(dateEntity.fromDate.getTime())-\(dateEntity.toDate.getTime())",
                                                                                                    bodyDate:       bodyDate,
                                                                                                    bodyTimeFrom:   dateEntity.fromDate.getTime(),
                                                                                                    bodyTimeTo:     dateEntity.toDate.getTime()))
                        }
                    }
                    
                    if dateTimes.count > 0 {
                        self.dates.append(OrderCreateModels.Dates.RequestModel.DateForPickerView(id:      dateEntity.weekDay,
                                                                                                 title:   "\(dateEntity.name!) " + weekDate,
                                                                                                 times:   dateTimes))
                    }
                }
            }
        }
        
        let responseModel = OrderCreateModels.Dates.ResponseModel()
        presenter?.presentDates(fromResponseModel: responseModel)
    }
    
    func fetchDepartments(withRequestModel requestModel: OrderCreateModels.Departments.RequestModel) {
        // CoreData: Fetch data
        if let departmentsEntities = appDependency.coreDataManager.readEntities(withName: "Department",
                                                                         withPredicateParameters: nil, //NSPredicate.init(format: "laundryId == \(Laundry.codeID)"),
                                                                         andSortDescriptor: nil) as? [Department], departmentsEntities.count > 0 {
            for department in departmentsEntities {
                self.departments.append(OrderCreateModels.Departments.RequestModel.DisplayedDepartment(id:          department.departmentId,
                                                                                                       name:        department.departmentName,
                                                                                                       isSelected:  false))
            }
        }
        
        let responseModel = OrderCreateModels.Departments.ResponseModel()
        presenter?.presentDepartments(fromResponseModel: responseModel)
    }
}
