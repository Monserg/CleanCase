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
    func getLastClientMessage() {
        let params: [ String: Any ] = [ "0":    Int64(Laundry.codeID),
                                        "1":    Int64(PersonalData.current!.clientId),
                                        "2":    Token.current!.lastMessageID ]

        // API
        RestAPIManager().fetchRequest(withRequestType: RequestType.getNextMessage(params, false), andResponseType: ResponseAPIClientMessageResult.self, completionHandler: { responseAPI in
            if let result = responseAPI.model as? ResponseAPIClientMessageResult {
                let model = result.GetClientMessageResult
                
                if model.RecordId != Token.current!.lastMessageID && model.RecordId != 0 {
                    if model.ClientId == PersonalData.current!.clientId {
                        Token.current!.lastMessageID = model.RecordId
                        Token.current!.save()
                        
                        if let dataXML = model.Data, !dataXML.isEmpty {
                            let dataInfo = dataXML.convertToValues()
                            
                            // CoreData
                            switch model.Command {
                            // Update Order Status
                            case 5:
                                if let order = CoreDataManager.instance.readEntity(withName: "Order",
                                                                                   andPredicateParameters: NSPredicate.init(format: "orderID == \(dataInfo.orderID)")) as? Order {
                                    order.orderStatus = dataInfo.status
                                    order.save()
                                }
                                
                            default:
                                break
                            }
                        }
                    }
                }
            }
        })
    }
}
