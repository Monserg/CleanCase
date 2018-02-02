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
typealias RequestParametersType = (method: HTTPMethod, path: String, body: [String: Any]?, headers: [String: String]?, parameters: [String: Any]?)

enum RequestType {
    // GET
    case getCitiesList()
    case getCurrentAppWorkingVersion()


    // POST
    
    
    // MARK: - Custom functions
    func introduced() -> RequestParametersType {
        let headers = [ "Content-Type": "application/json", "Accept-Charset": "UTF-8" ]
        
        // Body & Parametes named such as in Postman
        switch self {
        // GET
        case .getCitiesList():      return (method:         .get,
                                            path:           "/GetCities",
                                            body:           nil,
                                            headers:        headers,
                                            parameters:     nil)

        case .getCurrentAppWorkingVersion():        return (method:         .get,
                                                            path:           "/GetVer",
                                                            body:           nil,
                                                            headers:        headers,
                                                            parameters:     nil)

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
            for param in params {
                let queryItem   =   URLQueryItem(name: param.key, value: param.value as? String)
                
                components.queryItems?.append(queryItem)
            }
        }
        
        // Body
        // TODO: - ADD REQUEST BODY PARAMETERS
        
        return components
    }
    
    func fetchRequest<T: Decodable>(withRequestType requestType: RequestType, andResponseType responseType: T.Type, completionHandler: @escaping (ResponseAPI) -> Void) {
        let requestParameters   =   requestType.introduced()
        let components          =   createURLComponents(withParameters: requestType.introduced())
        
        Alamofire.request(components.url!,
                          method: requestParameters.method,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON { response in
                            do {
                                let responseAPI = try JSONDecoder().decode(responseType, from: response.data!)
                                completionHandler((model: responseAPI, error: response.error))
                            } catch {
                                completionHandler((model: nil, error: error))
                            }
        }
    }
}
