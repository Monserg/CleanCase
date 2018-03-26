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
    func getLastClientMessage(_ completion: @escaping (Bool, Int16?) -> ()) {
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
                            
                            // CoreData: use Order commands
                            if let order = CoreDataManager.instance.readEntity(withName:                "Order",
                                                                               andPredicateParameters:  NSPredicate.init(format: "orderID == \(dataInfo.orderID)")) as? Order {
                                switch model.Command {
                                // UpdateOrder
                                case 4:
                                    order.price         =   dataInfo.price
                                    
                                    order.getItems()
                                    
                                // UpdateStatus
                                case 5:
                                    order.orderStatus   =   dataInfo.status
                                    
                                // ChangeCollection
                                case 13:
                                    if let collectionTerms = dataInfo.collection {
                                        order.collectionTo      =   collectionTerms
                                        order.collectionFrom    =   collectionTerms
                                    }
                                    
                                default:
                                    break
                                }
                                
                                order.save()
                                completion(true, dataInfo.status)
                            }
                            
                            // Message
                            else if model.Command == 11 {
                                Logger.log(message: "Add new chat message", event: .Severe)
                                
                                if let dataXML = model.Data, !dataXML.isEmpty {
                                    // CoreData
                                    let messageEntity = CoreDataManager.instance.createEntity("Message") as! Message
                                    messageEntity.updateEntity(withType: model.LaundryId, andText: dataXML)
                                    NotificationCenter.default.post(name: Notification.Name("CompleteReceiveNewMessage"), object: nil)
                                }
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
                                    CoreDataManager.instance.deleteEntities(withName: "Department", andPredicateParameters: nil, completion: { success in
                                        if success {
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
                                            
                                            // Post Custom User Notification
                                            NotificationCenter.default.post(name: Notification.Name("AddDepartmentCommonCommand"), object: nil)
                                        }
                                    })
                                }
                            })
                            
                        default:
                            break
                        }
                        
                        Logger.log(message: "Update Manager return true", event: .Severe)
                        completion(true, nil)
                    }
                }
                
                Logger.log(message: "Update Manager return false", event: .Severe)
                completion(false, nil)
            }
        })
    }
}
