//
//  MultiFormDataModel.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation

/// A model for creating a multipart request body.
///
/// It is initialised with an array of multipart request body part models – **MultipartFormItem**, and can be encoded to Data.
///
public struct MultipartFormDataModel {
    // MARK: - Private Properties
    private let formItems: [MultipartFormItem]
    
    // MARK: - Internal Properties
    let boundary = UUID().uuidString
    
    // MARK: - Init
    public init(items formItems: [MultipartFormItem]) {
        self.formItems = formItems
    }
    
    // MARK: - Public Methods
    /// Turns all parts of the request body into one coherent request body.
    public func encode() -> Data {
        guard !formItems.isEmpty else { return Data() }
        
        let data = NSMutableData()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for item in formItems {
            data.append(boundaryPrefix)
            data.append(item.convert())
        }

        data.append("--\(boundary)--\r\n")
        
        return data as Data
    }
}

/// Model for body part multipart request.
///
/// Contains:
/// - **name** – the key by which the data can be written to the server.
/// - **fileName** – name of the file, which can be transferred to the server.
/// - **mimeType** – file type. It is an optional variable.
/// - **data** – data to be added as part of the request body.
///
public struct MultipartFormItem {
    // MARK: - Static Properties
    static private let crlf = "\r\n"
    
    // MARK: - Public Properties
    /// The key by which the data can be written to the server.
    public var name: String
    
    /// Name of the file, which can be transferred to the server.
    public var fileName: String
    
    /// File type. It is an optional variable.
    public var mimeType: String?
    
    /// Data to be added as part of the request body.
    public var data: Data
    
    // MARK: - Init
    public init(name: String, fileName: String,
                mimeType: String? = nil, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
    
    // MARK: - Fileprivate Methods
    fileprivate func convert() -> Data {
        let formItemData = NSMutableData()
        
        formItemData.append("Content-Disposition: form-data; name=\"\(name)\"")
        formItemData.append("; filename=\"\(fileName)\"")
        
        if let mimeType = mimeType {
            formItemData.append(MultipartFormItem.crlf)
            formItemData.append("Content-Type: \(mimeType)")
        }
        
        formItemData.append(MultipartFormItem.crlf)
        formItemData.append(MultipartFormItem.crlf)
        formItemData.append(data)
        formItemData.append(MultipartFormItem.crlf)
        
        return formItemData as Data
    }
}

// MARK: - NSMutableData + Append String
private extension NSMutableData {
    func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
