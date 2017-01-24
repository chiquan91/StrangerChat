//
//  ServiceManager.swift
//  CHIP
//
//  Created by Hoang Chi Quan on 5/17/16.
//  Copyright © 2016 vmodev.com. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator

// MARK: - ServerRequest

class ServerRequest {
    init (isDownload: Bool = false, saveToURL: URL = URL.init(fileURLWithPath: ""), method: Alamofire.HTTPMethod, encoding: ParameterEncoding = Alamofire.URLEncoding.default, path: String, header: [String: String]? = nil, parameters: [String: AnyObject]? = nil, datas: [(Data, String, String)]? = nil, responseType: ServerResponse.Type) {
        self.method = method
        self.encoding = encoding
        self.path = path
        self.urlString = ServiceManager.baseURL + path
        self.params = parameters
        self.datas = datas
        self.responseType = responseType.self
        self.header = header
        self.isDownload = isDownload
        self.fileURL = saveToURL
    }
    var method: Alamofire.HTTPMethod
    var encoding: ParameterEncoding
    var path: String
    var urlString: String
    var params: [String: AnyObject]?
    var datas: [(Data, String, String)]?
    var responseType: ServerResponse.Type
    var header: [String: String]?
    var isDownload: Bool
    var fileURL: URL
}

// MARK: - ServerResponse
class ServerResponse {
    required init(responseData: AnyObject) {
        self.responseData = responseData
    }
    var responseData: AnyObject
    var statusCode: Int? {
        get {
            if let dict = responseData as? [String: AnyObject] {
                return (dict["status"] as? NSNumber)?.intValue
            }
            return nil
        }
    }
    var message: String? {
        get {
            if let dict = responseData as? [String: AnyObject], let errorMessage = dict["ErrorMessage"] as? String {
                return errorMessage
            }
            return nil
        }
    }
    var data: AnyObject? {
        get {
            if let dict = responseData as? [String: AnyObject] {
                return dict["data"]
            }
            return nil
        }
    }
    var errorCode: Int? {
        get {
            if let dict = responseData as? [String: AnyObject] {
                return (dict["errorCode"] as? NSNumber)?.intValue
            }
            return nil
        }
    }
    var link: String? {
        get {
            if let dict = responseData as? [String: AnyObject] {
                return dict["link"] as? String
            }
            return nil
        }
    }
    
}

// MARK: - ServiceManager


class ServiceManager: NSObject {
    override init() {
        NetworkActivityIndicatorManager.shared.isEnabled = true
    }
    static let baseURL = Constant.serverUrlBase_prod
    static let shared = ServiceManager()
    
    class func execute(_ request: ServerRequest, in viewController: UIViewController? = nil, completionHandle:@escaping ((_ response: ServerResponse?) -> Void), failureHandle:((_ code: Int?) -> Void)? = nil, showErrorMessage: Bool = true, animate: Bool, createRequestSuccess:((Request) -> Void)? = nil) {
        ServiceManager.shared.execute(request, in: viewController, completionHandle: completionHandle, failureHandle: failureHandle, animate: animate, showErrorMessage: showErrorMessage, createRequestSuccess: createRequestSuccess)
    }
    
    private func execute(_ request: ServerRequest, in viewController: UIViewController? = nil, completionHandle:@escaping ((_ response: ServerResponse?) -> Void), failureHandle:((_ code: Int?) -> Void)? = nil, animate: Bool, showErrorMessage: Bool = true, createRequestSuccess:((Request) -> Void)? = nil) {
        func failure(_ statusCode: Int = -1, errorCode: Int? = nil, message: String? = nil) {
            if animate {
                viewController?.stopAnimating()
            }
            if showErrorMessage {
                UIApplication.shared.keyWindow?.makeToast(message ?? "Something went wrong.")
            }
            failureHandle?(errorCode)
        }
        viewController?.view.endEditing(true)
        print("==============================================")
        print("API: ", request.urlString)
        print("Parameters: ", request.params ?? "")
        if !Reachability.isConnectedToNetwork() {
            UIApplication.shared.keyWindow?.makeToast("No internet connection.", duration: 2, position: ToastPosition.bottom, title: nil, image: nil, style: nil, completion: { (_) in
                completionHandle(nil)
            })
            return
        }
        if animate {
            viewController?.startAnimating()
        }
        if request.isDownload {
            let req = Alamofire.download(request.urlString,
                                         method: request.method,
                                         parameters: request.params,
                                         encoding: request.encoding,
                                         headers: request.header,
                                         to: { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
                                            return (request.fileURL, .createIntermediateDirectories)
            }).responseData(completionHandler: { (downloadResponse) in
                viewController?.stopAnimating()
                if let index = viewController?.requests.index(where: { $0.request == downloadResponse.request }) {
                    viewController?.requests.remove(at: index)
                }
                switch downloadResponse.result {
                case .success(let data):
                    print("==============================================")
                    print("API: ", request.urlString)
                    if let statusCode = downloadResponse.response?.statusCode {
                        do {
                            let responseObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                            print("Response: ",responseObject)
                            let response = request.responseType.init(responseData: responseObject as AnyObject)
                            if statusCode / 100 == 2 {
                                completionHandle(response)
                            } else {
                                completionHandle(nil)
                                failure(errorCode: response.errorCode, message: response.message)
                            }
                            return
                        } catch {
                            failure()
                        }
                        completionHandle(nil)
                    } else {
                        failure()
                    }
                    
                case .failure:
                    completionHandle(nil)
                    failure()
                }
            })
            createRequestSuccess?(req)
            viewController?.requests.append(req)
        } else if let datas = request.datas {
            do {
                let url = try URLRequest(url: request.urlString, method: request.method, headers: request.header)
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    for (data, key, mimeType) in datas {
                        multipartFormData.append(data, withName: key, fileName: "image.jpeg", mimeType: mimeType)
                    }
                    if let parameters = request.params {
                        for (key, value) in parameters {
                            if let array = value as? [String] {
                                array.forEach({ (string) in
                                    if let data = string.data(using: String.Encoding.utf8) {
                                        multipartFormData.append(data, withName: key)
                                    }
                                })
                            } else if let data = "\(value)".data(using: String.Encoding.utf8) {
                                multipartFormData.append(data, withName: key)
                            }
                        }
                    }
                }, with: url, encodingCompletion: { (encodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        let req = upload.response(completionHandler: { (uploadResponse) in
                            viewController?.stopAnimating()
                            if let index = viewController?.requests.index(where: { $0.request == uploadResponse.request }) {
                                viewController?.requests.remove(at: index)
                            }
                            print("==============================================")
                            print("API: ", request.urlString)
                            if let statusCode = uploadResponse.response?.statusCode {
                                if uploadResponse.error == nil {
                                    if let data = uploadResponse.data {
                                        do {
                                            let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                            print("Response: ",responseObject)
                                            let response = request.responseType.init(responseData: responseObject as AnyObject)
                                            if statusCode / 100 == 2 {
                                                completionHandle(response)
                                            } else {
                                                completionHandle(nil)
                                                failure(errorCode: response.errorCode, message: response.message)
                                            }
                                            return
                                        } catch {
                                            failure()
                                        }
                                    }
                                    completionHandle(nil)
                                } else {
                                    failure()
                                }
                            } else {
                                failure()
                            }
                        })
                        createRequestSuccess?(req)
                        viewController?.requests.append(req)
                    case .failure:
                        completionHandle(nil)
                        failure()
                    }
                })
            } catch {}
        } else {
            let req = Alamofire.request(request.urlString, method: request.method, parameters: request.params, encoding: request.encoding, headers: request.header)
            req.response(completionHandler: { [weak viewController] (res) in
                viewController?.stopAnimating()
                viewController?.cancelRequest(request: req)
                print("==============================================")
                print("API: ", request.urlString)
                if let statusCode = res.response?.statusCode {
                    if res.error == nil {
                        if let data = res.data {
                            do {
                                let responseObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                print("Response: ",responseObject)
                                let response = request.responseType.init(responseData: responseObject as AnyObject)
                                if statusCode / 100 == 2 {
                                    completionHandle(response)
                                } else {
                                    completionHandle(nil)
                                    failure(errorCode: response.errorCode, message: response.message)
                                }
                                return
                            } catch {
                                failure()
                            }
                        }
                        completionHandle(nil)
                    } else {
                        failure()
                    }
                } else {
                    completionHandle(nil)
                    failure()
                }
            })
            createRequestSuccess?(req)
            viewController?.requests.append(req)
        }
    }
}
