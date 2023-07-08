//
//  BaseNetworking.swift
//  ToDoListProject
//
//  Created by Ангелина Решетникова on 06.07.2023.
//

import Foundation

class RequestProcessor: NetworkingService {
    static func makeUrl(id: String? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "beta.mrdekk.ru"
        components.path = "/todobackend/list"
        if let elementId = id {
            components.path = "/todobackend/list/\(elementId)"
        }
        guard let url = components.url else {
            throw RequestProcessorError.wrongUrl(components)
        }
        return url
    }
    
    static func performMyAwesomeRequest(
        urlSession: URLSession = .shared,
        url: URL,
        completion: @escaping (Result<(Int32, [TodoItem]), Error>) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("Bearer unnagging", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(
                        .failure(error)
                    )
                    FileCache.isDirty = true
                    return
                }
                
                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    print("Ошибка при парсинге")
                    return
                }
                guard let collectionOfToDoItemsJson = json["list"] as? [[String: Any]] else {
                    print("Ошибка! в файле нет ToDoItem")
                    return
                }
                
                guard let revisionJson = json["revision"] as? Int32 else {
                    print("Ошибка! в файле нет revision")
                    return
                }
                var collectionToDoitem = [TodoItem]()
                for item in collectionOfToDoItemsJson {
                    let optionalToDoItem = TodoItem.parse(json: item)
                    if let toDoItem = optionalToDoItem {
                        collectionToDoitem.append(toDoItem)
                    }
                }
                
                completion(
                    .success((revisionJson, collectionToDoitem))
                )
            }.resume()
    }
    
    static func performMyAwesomeRequest1(
        urlSession: URLSession = .shared,
        url: URL,
        method: HttpMethod,
        body: Data? = nil,
        completion: @escaping (Result<(Int32, TodoItem), Error>) -> Void) {
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 60.0)
        request.httpMethod = method.rawValue
        request.setValue("Bearer unnagging", forHTTPHeaderField: "Authorization")
        request.setValue(String(revision), forHTTPHeaderField: "X-Last-Known-Revision")
        if method != .delete {
            request.httpBody = body
        }
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    FileCache.isDirty = true
                    return
                }
                
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                else { return }
                
                guard
                      let itemjson = json["element"] as? [String: Any],
                      let revisionJson = json["revision"] as? Int32,
                      let item = TodoItem.parse(json: itemjson)
                else { return }
                completion(
                    .success(
                        (revisionJson, item)
                    )
                )
            }.resume()
    }
    
    static func reloadList(
            urlSession: URLSession = .shared,
            url: URL,
            body: Data? = nil,
            completion: @escaping (Result<(Int32, [TodoItem]), Error>) -> Void) {
            var request = URLRequest(url: url,
                                     cachePolicy: .useProtocolCachePolicy,
                                     timeoutInterval: 60.0)
            request.httpMethod = HttpMethod.patch.rawValue
            request.setValue("Bearer unnagging", forHTTPHeaderField: "Authorization")
            request.setValue(String(RequestProcessor.revision), forHTTPHeaderField: "X-Last-Known-Revision")
                request.httpBody = body
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        FileCache.isDirty = true
                        return
                    }
                    
                    guard let data = data,
                          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    else { return }
                    
                    guard
                          let itemsjson = json["list"] as? [[String: Any]],
                          let revisionJson = json["revision"] as? Int32
                    else { return }
                    
                    var collectionToDoitem = [TodoItem]()
                    for item in itemsjson {
                        let optionalToDoItem = TodoItem.parse(json: item)
                        if let toDoItem = optionalToDoItem {
                            collectionToDoitem.append(toDoItem)
                        }
                    }
                    completion(
                        .success(
                            (revisionJson, collectionToDoitem)
                        )
                    )
                }.resume()

        }
    
    
    static var revision: Int32 = 0
    private static let httpStatusCodeSucsess = 200..<300
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum RequestProcessorError: Error {
    case unexpectedResponse(URLResponse)
    case wrongUrl(URLComponents)
    case failedResponce(HTTPURLResponse)
}
