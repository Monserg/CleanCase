//
//  OrdersShowInteractor.swift
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
protocol OrdersShowBusinessLogic {
    func fetchOrders(withRequestModel requestModel: OrdersShowModels.OrderItem.RequestModel)
}

protocol OrdersShowDataStore {
    var orders: [OrdersShowModels.OrderItem.RequestModel.DisplayedOrder]! { get set }
}

class OrdersShowInteractor: ShareInteractor, OrdersShowBusinessLogic, OrdersShowDataStore {
    // MARK: - Properties
    var presenter: OrdersShowPresentationLogic?
    
    // OrdersShowDataStore protocol implementation
    var orders: [OrdersShowModels.OrderItem.RequestModel.DisplayedOrder]!
    
    
    // MARK: - Business logic implementation
    func fetchOrders(withRequestModel requestModel: OrdersShowModels.OrderItem.RequestModel) {
        if let ordersList = self.appDependency.coreDataManager.readEntities(withName: "Order",
                                                                            withPredicateParameters: nil,
                                                                            andSortDescriptor: NSSortDescriptor.init(key: "createdDate", ascending: true)) as? [Order],
            ordersList.count > 0 {
            self.orders = [OrdersShowModels.OrderItem.RequestModel.DisplayedOrder]()
            
            for orderEntity in ordersList {
                self.orders.append(OrdersShowModels.OrderItem.RequestModel.DisplayedOrder(createdDate:      orderEntity.createdDate,
                                                                                          status:           orderEntity.orderStatus,
                                                                                          orderID:          orderEntity.orderID,
                                                                                          price:            orderEntity.price,
                                                                                          collectionFrom:   orderEntity.collectionFrom,
                                                                                          collectionTo:     orderEntity.collectionTo,
                                                                                          deliveryFrom:     orderEntity.deliveryFrom,
                                                                                          deliveryTo:       orderEntity.deliveryTo))
            }
        }

        let responseModel = OrdersShowModels.OrderItem.ResponseModel()
        presenter?.presentOrders(fromResponseModel: responseModel)
    }
}
