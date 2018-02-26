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
                print("TEST: get model from API = \(model)")

                if model.RecordId != Token.current!.lastMessageID && model.RecordId != 0 {
                    if model.ClientId == PersonalData.current!.clientId {
                        // Save Last Client Message
                        Token.current!.lastMessageID = model.RecordId
                        Token.current!.save()
                        
                        if let dataXML = model.Data, !dataXML.isEmpty {
                            let dataInfo = dataXML.convertToValues()
                            
                            // CoreData
                            if let order = CoreDataManager.instance.readEntity(withName: "Order",
                                                                               andPredicateParameters: NSPredicate.init(format: "orderID == \(dataInfo.orderID)")) as? Order {
                                switch model.Command {
                                // AddDepartment
                                case 1:
                                   print("XXX")
                                    // Delete all departments
                                    // CoreDataManager.instance.deleteEntities(withName: "Department", andPredicateParameters: NSPredicate.init(format: "id == 55"))

                                // UpdateOrder
                                case 4:
                                    order.orderStatus   =   dataInfo.status
                                    order.price         =   dataInfo.price
                                    
                                    order.getItems()
                                    
                                // UpdateStatus
                                case 5:
                                    order.orderStatus = dataInfo.status
                                    
                                default:
                                    break
                                }
                                
                                order.save()
                                completion(true)
                            }
                        }
                    }
                }
            }
            
            completion(false)
        })
    }
}
