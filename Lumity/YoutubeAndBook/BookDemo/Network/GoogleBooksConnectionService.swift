//
//  GoogleBooksConnectionService.swift
//  Lumity
//
//  Created by iMac on 08/11/22.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class GoogleBooksConnectionService {
    
    static let shared = GoogleBooksConnectionService()
    
    private init() {}
    
    public func loadVolumesWithName(name: String, completion: @escaping (Any?) -> Void) {
        guard let parameterString = name.normalizeForSearchParameter(string: name) else {
            completion(nil)
            return
        }
        
        Alamofire.request(GoogleBooksRequestConverible.volumes(parameterString)).responseObject { (response: DataResponse<VolumeListResponse>) in
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let value = response.result.value else {
                completion(nil)
                return
            }
            
            completion(value)
        }
    }
    
}
extension String {
    
    public func normalizeForSearchParameter(string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
}
