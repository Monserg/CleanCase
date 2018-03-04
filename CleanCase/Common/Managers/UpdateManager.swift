//
//  UpdateManager.swift
//  CleanCase
//
//  Created by msm72 on 23.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit

public enum CommandType: Int16 {
    case None = 0
    case AddDepartment
    case AddOrder
    case AddCollectionDates
    case UpdateOrder
    case UpdateStatus
    case AddClient
    case AddCollection
    case AddDelivery
    case UpdateCollection
    case UpdateDelivery
    case Notification
    case UpdateClient
    case ChangeCollection
    case ChangeDelivery
    case ChatMessage
    case GetMessageForLaundry
}

class UpdateManager {
    // MARK: - Custom Functions
    func getLastClientMessage(_ completion: @escaping (Bool) -> ()) {
        let params: [ String: Any ] = [ "0":    Int64(Laundry.codeID),
                                        "1":    Int64(PersonalData.current!.clientId),
                                        "2":    Token.current!.lastMessageID ]

        // API
        RestAPIManager().fetchRequest(withRequestType: RequestType.getNextMessage(params, false), andResponseType: ResponseAPIClientMessageResult.self, completionHandler: { responseAPI in
            if let result = responseAPI.model as? ResponseAPIClientMessageResult {
                let model = result.GetClientMessageResult
                Logger.log(message: "GetClientMessageResult model = \(model)", event: .Verbose)

                if model.RecordId != 0 {
                    // Save Last Client Message
                    Token.current!.lastMessageID = model.RecordId
                    Token.current!.save()
                    Logger.log(message: "CoreData 'Update Token Last Message ID' success: lastMessageID = \(model.RecordId)", event: .Severe)

                    // Clients commands
                    if model.ClientId == PersonalData.current!.clientId {
                        Logger.log(message: "Client command: \(model.Command)", event: .Severe)

                        if let dataXML = model.Data, !dataXML.isEmpty {
                            let dataInfo = dataXML.convertToValues()
                            
                            // CoreData
                            if let order = CoreDataManager.instance.readEntity(withName:                "Order",
                                                                               andPredicateParameters:  NSPredicate.init(format: "orderID == \(dataInfo.orderID)")) as? Order {
                                switch model.Command {
                                // UpdateOrder
                                case 4:
                                    order.orderStatus   =   dataInfo.status
                                    order.price         =   dataInfo.price
                                    
                                    order.getItems()
                                    
                                // UpdateStatus
                                case 5:
                                    order.orderStatus   =   dataInfo.status
                                    
                                default:
                                    break
                                }
                                
                                order.save()
                                completion(true)
                            }
                        }
                    }

                    // Common commands
                    else {
                        Logger.log(message: "Common command: \(model.Command)", event: .Severe)

                        switch model.Command {
                        // AddDepartment
                        case 1:
                            // API
                            RestAPIManager().fetchRequest(withRequestType: RequestType.getDepartmentsList([ "laundry_id": Laundry.codeID ], false), andResponseType: ResponseAPIDepartmentsResult.self, completionHandler: { responseAPI in
                                if let result = responseAPI.model as? ResponseAPIDepartmentsResult {
                                    // Delete all departments
                                    // Add new departments
                                    for model in result.GetDepartmentsResult {
                                        let predicate = NSPredicate.init(format: "departmentId == \(model.DepartmentId)")
                                        
                                        CoreDataManager.instance.updateEntity(withData: EntityUpdateTuple(name:       "Department",
                                                                                                          predicate:  predicate,
                                                                                                          model:      model))
                                    }
                                }
                            })
                            
                        default:
                            break
                        }
                        
                        Logger.log(message: "Update Manager return true", event: .Severe)
                        completion(true)
                    }
                }
                
                Logger.log(message: "Update Manager return false", event: .Severe)
                completion(false)
            }
        })
    }
    
    class func test() {
        // API
        RestAPIManager().fetchRequest(withRequestType: RequestType.getDepartmentsList([ "laundry_id": Laundry.codeID ], false), andResponseType: ResponseAPIDepartmentsResult.self, completionHandler: { responseAPI in
            if let result = responseAPI.model as? ResponseAPIDepartmentsResult {
                // Delete all departments
//                CoreDataManager.instance.deleteEntities(withName: "Department", andPredicateParameters: nil, completion: { success in
//                    if success {
                        // Add new departments
                        for model in result.GetDepartmentsResult {
                            let departmentEntity = CoreDataManager.instance.createEntity("Department") as! Department
                            departmentEntity.updateEntity(fromResponse: model)
                            
                            // Set DepartmentItems
                            if let items = model.Items, items.count > 0 {
                                for item in items {
                                    let departmentItemEntity = CoreDataManager.instance.createEntity("DepartmentItem") as! DepartmentItem
                                    
                                    departmentItemEntity.updateEntity(fromResponse: item)
                                    departmentEntity.addToItems(departmentItemEntity)
                                }
                            }
                            
                            departmentEntity.save()
                        }
//                    }
//                })
            }
        })
    }
}
