//
//  MSMRestApiManager.swift
//  CleanCase
//
//  Created by msm72 on 02.02.2018.
//  Copyright © 2018 msm72. All rights reserved.
//

import UIKit
import Alamofire

typealias ResponseAPI = (model: Decodable?, error: Error?)
typealias RequestParametersType = (method: HTTPMethod, path: String, body: [String: Any]?, parameters: [String: Any]?)

enum RequestType {
    // GET
    case getCitiesList([String: Any]?, Bool)
    case getNextMessage([String: Any]?, Bool)
    case getLaundryInfo([String: Any]?, Bool)
    case getLastRecordID([String: Any]?, Bool)
    case getOrderItemsList([String: Any]?, Bool)
    case getDepartmentsList([String: Any]?, Bool)
    case getDeliveryDatesList([String: Any]?, Bool)
    case getCollectionDatesList([String: Any]?, Bool)
    case getCurrentAppWorkingVersion([String: Any]?, Bool)

    
    // POST
    case addOrder([String: Any]?, Bool)
    case addClient([String: Any]?, Bool)
    case sendMessage([String: Any]?, Bool)
    case setDelivery([String: Any]?, Bool)
    case updateOrderStatus([String: Any]?, Bool)

    
    // MARK: - Custom functions
    func introduced() -> RequestParametersType {
        // Body & Parametes named such as in Postman
        switch self {
        // GET
        case .getCitiesList(let params, let isBodyParams):      return (method:         .get,
                                                                        path:           "/GetCities",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getNextMessage(let params, let isBodyParams):     return (method:         .get,
                                                                        path:           "/GetClientMessage",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getLaundryInfo(let params, let isBodyParams):     return (method:         .get,
                                                                         path:           "/GetLaundryByCity/",
                                                                         body:           (isBodyParams ? params : nil),
                                                                         parameters:     (isBodyParams ? nil : params))
            
        case .getLastRecordID(let params, let isBodyParams):                    return (method:         .get,
                                                                                        path:           "/GetRecordId",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))

        case .getOrderItemsList(let params, let isBodyParams):                  return (method:         .get,
                                                                                        path:           "/GetItems/",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getDepartmentsList(let params, let isBodyParams):                 return (method:         .get,
                                                                                        path:           "/GetDepartments/",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getDeliveryDatesList(let params, let isBodyParams):               return (method:         .get,
                                                                                        path:           "/GetDeliveryDates/",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getCollectionDatesList(let params, let isBodyParams):             return (method:         .get,
                                                                                        path:           "/GetCollectionDates/",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .getCurrentAppWorkingVersion(let params, let isBodyParams):        return (method:         .get,
                                                                                        path:           "/GetVer",
                                                                                        body:           (isBodyParams ? params : nil),
                                                                                        parameters:     (isBodyParams ? nil : params))
            
        
        // POST
        case .addOrder(let params, let isBodyParams):           return (method:         .post,
                                                                        path:           "/AddOrder",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .addClient(let params, let isBodyParams):          return (method:         .post,
                                                                        path:           "/AddClient",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))
            
        case .sendMessage(let params, let isBodyParams):        return (method:         .post,
                                                                        path:           "/AddChatMessage",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))

        case .setDelivery(let params, let isBodyParams):        return (method:         .post,
                                                                        path:           "/SetDelivery",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))

        case .updateOrderStatus(let params, let isBodyParams):  return (method:         .post,
                                                                        path:           "/UpdateStatus",
                                                                        body:           (isBodyParams ? params : nil),
                                                                        parameters:     (isBodyParams ? nil : params))
        }
    }
}

final class RestAPIManager {
    // MARK: - Class Functions
    fileprivate func createURLComponents(withParameters parameters: RequestParametersType) -> NSURLComponents {
        let components          =   NSURLComponents()
        components.queryItems   =   [URLQueryItem]()
        components.scheme       =   "http"
        
        #if RELEASE
            components.host     =   "192.116.53.69"
        #else
            components.host     =   "192.116.53.69"
        #endif
        
        components.path         =   "/Facade"
        components.path!.append("/facade.svc")
        components.path!.append(parameters.path)

        // Parameters
        if let params = parameters.parameters, parameters.body == nil {
            if params.count == 1 {
                components.path!.append("\(params.values.first!)")
            }
            
            else {
                for i in 0..<params.count {
                    components.path!.append("/\(params["\(i)"] as! Int64)")
                }
            }
        }
        
        return components
    }
    
    func fetchRequest<T: Decodable>(withRequestType requestType: RequestType, andResponseType responseType: T.Type, completionHandler: @escaping (ResponseAPI) -> Void) {
        let headers             = [ "Content-Type": "application/json", "Accept-Charset": "UTF-8" ]
        let requestParameters   =   requestType.introduced()
        let components          =   createURLComponents(withParameters: requestType.introduced())
        
        if let body = requestParameters.body,
            responseType != ResponseAPIClientResult.self,
            responseType != ResponseAPIAddOrderResult.self,
            responseType != ResponseAPIUpdateStatusResult.self {
            Alamofire.request(components.url!,
                              method:       requestParameters.method,
                              parameters:   body,
                              encoding:     JSONEncoding.default,
                              headers:      headers).response(completionHandler: { response in
                                completionHandler((model: nil, error: response.error))
                              })
        }
        
        else {
            Alamofire.request(components.url!,
                              method:       requestParameters.method,
                              parameters:   requestParameters.body,
                              encoding:     JSONEncoding.default,
                              headers:      headers).responseJSON { response in
                                do {
                                    let responseAPI = try JSONDecoder().decode(responseType, from: response.data!)
                                    completionHandler((model: responseAPI, error: response.error))
                                } catch {
                                    completionHandler((model: nil, error: error))
                                }
            }
        }
    }
}
