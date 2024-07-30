//
//  RequestBuilder.swift
//  TestTask_Headway
//  Created by user on 27.07.2024.
//

import Foundation

public typealias QueryItems = [String: String]
public typealias HTTPHeaderFields = [String: String]

/// The Request Builder contains variables that are used to build the request step by step.
///
/// It is convenient to use with Enums, which will describe each individual request as a separate enum case.
///
/// **Request Builder includes:**
/// - **path** – the path that will be added to the base URL when creating a request.
/// - **query** – query items as keys and values which will be added to the request. If request shouldn't contain them, it should return nil.
/// - **body** – data to be added to the body of the request. If the request should not contain a body - return nil.
/// - **method** – HTTP Method which will be added to the reques.
/// - **baseURL** – a base URL that can be added to your request. Serves as an exception to the rule. In most cases the base URL will be taken from the Networking Provider.
/// Specify this variable only when the base URL of a particular request differs from the base URL injected by Networking Provider.
/// You can ignore this variable when creating an object. By default it returns nil.
/// - **headerFields** – header fields that can be added to the request.
/// Used only if you want to specify additional header fields in addition to those specified in the Plugin array.
/// You can ignore this variable when creating an object. By default it returns nil.
/// - **multipartBody** – variable that can return MultipartFormDataModel. Used to create multipart form requests.
/// If the variable does not return nil, the body created by the MultipartFormDataModel will be added to the request. Do not use this and body variable at the same time.
/// You can ignore this variable when creating an object. By default it returns nil.

public protocol APIRequestBuilder {
    /// The path that will be added to the base URL when creating a request.
    var path: String { get }
    
    /// Query items as keys and values which will be added to the request. If request shouldn't contain them, it should return nil.
    var query: QueryItems? { get }
    
    /// Data to be added to the body of the request. If the request should not contain a body - return nil.
    var body: Data? { get }
    
    /// HTTP Method which will be added to the reques.
    var method: HTTPMethod { get }
    
    /// A base URL that can be added to your request. Serves as an exception to the rule. In most cases the base URL will be taken from the Networking Provider.
    /// Specify this variable only when the base URL of a particular request differs from the base URL injected by Networking Provider.
    /// You can ignore this variable when creating an object. By default it returns nil.
    var baseURL: URL? { get }
    
    /// Header fields that can be added to the request.
    /// Used only if you want to specify additional header fields in addition to those specified in the Plugin array.
    /// You can ignore this variable when creating an object. By default it returns nil.
    var headerFields: HTTPHeaderFields? { get }
    
    var requestEncoding: RequestEncoding? { get }
    
    var authRequired: Bool? { get }
    
    var token: String? { get }
    
    /// Variable that can return MultipartFormDataModel. Used to create multipart form requests.
    /// If the variable does not return nil, the body created by the MultipartFormDataModel will be added to the request.
    /// Do not use this and body variable in a RequestBuilder at the same time.
    /// You can ignore this variable when creating an object. By default it returns nil.
    var multipartBody: MultipartFormDataModel? { get }
}

// MARK: - Protocol Extension
extension APIRequestBuilder {
    public var baseURL: URL? { nil }
    public var headerFields: HTTPHeaderFields? { nil }
    public var multipartBody: MultipartFormDataModel? { nil }
    
    /// Creates a URLRequest based on the specified variables within the RequestBuilder, and the parameters passed: Base URL and Plugin array.
    ///
    /// When creating a URLRequest, the method checks if the RequestBuilder has baseURL and headerFields, and if not, takes them from the parameters.
    /// Also, the method checks if the RequestBuilder has a multipartBody variable.
    /// If it is, it substitutes it in the body of the request, if not, it substitutes the body variable in the body.
    func makeRequest(baseURL: URL, plugins: [Plugin]) -> URLRequest {
        var request = makeRequestWithoutBody(baseURL: baseURL)
        
        guard let multipartBody = multipartBody,
              method != .get else {
                  
            request.httpBody = body
            
            if requestEncoding != nil {
                request.addValue(requestEncoding?.headerString ?? "application/json", forHTTPHeaderField: "Accept")
                request.addValue(requestEncoding?.headerString ?? "application/json", forHTTPHeaderField: "Content-Type")
            }
            
            if authRequired != nil && authRequired == true {
                if token != nil {
                    request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
                }
            }
            
            plugins.forEach { $0.modifyRequest(&request) }
            LogManager.log(request)
            
            return request
        }
        
        let body = multipartBody.encode()
        let length = (body as NSData).length
        
        setMultipartHeaders(
            toRequest: &request,
            contentLength: length,
            boundary: multipartBody.boundary
        )
        
        request.httpBody = body
        
        if requestEncoding != nil {
            request.addValue(requestEncoding?.headerString ?? "application/json", forHTTPHeaderField: "Accept")
            request.addValue(requestEncoding?.headerString ?? "application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if authRequired != nil && authRequired == true {
            if token != nil {
                request.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
            }
        }
        
        plugins.forEach { $0.modifyRequest(&request) }
        LogManager.log(request)
        
        return request
    }
}

// MARK: - Private Methods
private extension APIRequestBuilder {
    func makeRequestWithoutBody(baseURL: URL) -> URLRequest {
        let baseURL = self.baseURL ?? baseURL
        let url = getURL(baseURL: baseURL)
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headerFields?.forEach {
            request.addValue(
                $0.value,
                forHTTPHeaderField: $0.key
            )
        }
        
        return request
    }
    
    func setMultipartHeaders(toRequest request: inout URLRequest,
                             contentLength: Int,
                             boundary: String) {
        
        request.setValue(
            "multipart/form-data; boundary=" + boundary,
            forHTTPHeaderField: "Content-Type"
        )
        
        request.setValue(
            String(contentLength),
            forHTTPHeaderField: "Content-Length"
        )
    }
    
    func getURL(baseURL: URL) -> URL {
        let url = baseURL.appendingPathComponent(path)
        
        guard let query = query else { return url }
        guard var components = URLComponents(string: url.absoluteString) else {
            fatalError(
                FatalError
                    .pathIncorrect(path)
                    .description
            )
        }
        
        components.queryItems = convert(query)
        
        guard let url = components.url else {
            fatalError(
                FatalError
                    .pathOrQueryIncorrect(path, query)
                    .description
            )
        }
                             
        return url
    }
    
    func convert(_ items: QueryItems?) -> [URLQueryItem]? {
        items?.map {
            URLQueryItem(
                name: $0.key,
                value: $0.value
            )
        }
    }
}
