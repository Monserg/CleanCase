//
//  DeliveryTermsShowInteractor.swift
//  CleanCase
//
//  Created by msm72 on 08.02.2018.
//  Copyright (c) 2018 msm72. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Business Logic protocols
protocol DeliveryTermsShowBusinessLogic {
    func saveSelectedDate(byRow row: Int)
    func saveSelectedTime(byRow row: Int)
    func fetchDates(withRequestModel requestModel: DeliveryTermsShowModels.Dates.RequestModel)
    func confirmDeliveryTerms(withRequestModel requestModel: DeliveryTermsShowModels.Item.RequestModel)
}

protocol DeliveryTermsShowDataStore {
    var dateEntitiesFiltered: [DeliveryDate]! { get set }
    var dates: [PickerViewSupport]! { get set }
    var times: [PickerViewSupport]! { get set }
    var selectedDateRow: Int { get set }
    var selectedTimeRow: Int { get set }
    var textFieldsTexts: [ (placeholder: String, errorText: String) ] { get set }
}

class DeliveryTermsShowInteractor: ShareInteractor, DeliveryTermsShowBusinessLogic, DeliveryTermsShowDataStore {
    // MARK: - Properties
    var presenter: DeliveryTermsShowPresentationLogic?

    
    // DeliveryTermsShowDataStore protocol implementation
    var selectedDateRow: Int = 0
    var selectedTimeRow: Int = 0
    
    var textFieldsTexts: [ (placeholder: String, errorText: String) ] = [
        (placeholder: "Select Delivery Date".localized(), errorText: "Please, select delivery date...".localized()),
        (placeholder: "Select Delivery Time".localized(), errorText: "Please, select delivery time...".localized())
    ]

    var dateEntitiesFiltered: [DeliveryDate]!
    var dates: [PickerViewSupport]! = [PickerViewSupport]()
    var times: [PickerViewSupport]!

    
    // MARK: - Business logic implementation
    func saveSelectedDate(byRow row: Int) {
        self.selectedDateRow = row
        self.times = (dates[row] as! DeliveryTermsShowModels.Dates.RequestModel.DateForPickerView).times
    }

    func saveSelectedTime(byRow row: Int) {
        self.selectedTimeRow = row
    }

    func fetchDates(withRequestModel requestModel: DeliveryTermsShowModels.Dates.RequestModel) {
        // CoreData: Fetch data
        for i in 1...7 {
            let date = (i == 1) ? Date() : Date().addingTimeInterval(TimeInterval(i * 24 * 60 * 60))
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: date)

            if dateComponents.weekday! != 7 {
                if let dateEntities = appDependency.coreDataManager.readEntities(withName: "DeliveryDate",
                                                                                 withPredicateParameters: NSPredicate.init(format: "weekDay == \(dateComponents.weekday!)"),
                                                                                 andSortDescriptor: nil) as? [DeliveryDate] {
                    // Times
                    let dateEntity = dateEntities.first!
                    var dateTimes = [PickerViewSupport]()
                    let weekDate = String.createDateString(fromComponents: dateComponents)

                    // Check times for current date
                    for (index, dateEntity) in dateEntities.enumerated() {
                        if (i == 1 && dateEntity.fromDate.convertToFloat() >= (Float(dateComponents.hour! + 1) + Float(dateComponents.minute!) / 100)) || i != 1 {
                            dateTimes.append(DeliveryTermsShowModels.Dates.RequestModel.TimeForPickerView(id:          Int16(index),
                                                                                                          title:       "\(dateEntity.fromDate.getTime())-\(dateEntity.toDate.getTime())",
                                                                                                          bodyDate:    weekDate,
                                                                                                          bodyTime:    dateEntity.fromDate.getTime()))
                        }
                    }
                    
                    if dateTimes.count > 0 {
                        self.dates.append(DeliveryTermsShowModels.Dates.RequestModel.DateForPickerView(id:      dateEntity.weekDay,
                                                                                                       title:   "\(dateEntity.name!) " + weekDate,
                                                                                                       times:   dateTimes))
                    }
                }
            }
        }

        let responseModel = DeliveryTermsShowModels.Dates.ResponseModel()
        presenter?.presentData(fromResponseModel: responseModel)
    }
    
    func confirmDeliveryTerms(withRequestModel requestModel: DeliveryTermsShowModels.Item.RequestModel) {
        // Prepare request body parameters
        let selectedDate    =   (times[selectedTimeRow] as! DeliveryTermsShowModels.Dates.RequestModel.TimeForPickerView).bodyDate
        let selectedTime    =   (times[selectedTimeRow] as! DeliveryTermsShowModels.Dates.RequestModel.TimeForPickerView).bodyTime
        let comment         =   (requestModel.comment == "Enter comment".localized()) ? "" : requestModel.comment
        
        let bodyParams: [String: Any] = [ "orderId": "326", "delivery": "\(selectedDate) \(selectedTime)", "remarks": comment ?? "" ]
        
        // API: Fetch request data
        self.appDependency.restAPIManager.fetchRequest(withRequestType: .setDelivery(bodyParams, true), andResponseType: ResponseAPIDeliveryDatesResult.self, completionHandler: { [unowned self] response in
            let responseModel = DeliveryTermsShowModels.Item.ResponseModel(error: response.error)
            self.presenter?.presentConfirmDeliveryTerms(fromResponseModel: responseModel)
        })
    }
}
