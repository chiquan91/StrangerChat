//
//  RequestManager.swift
//  Rize
//
//  Created by Hoang Chi Quan on 11/15/16.
//  Copyright © 2016 Vmodev. All rights reserved.
//

import UIKit

class RequestManager {
    
    // MARK: - App config
    
    final class func getAppConfig(in viewController: UIViewController?, completionHandler: ((_ complete: Bool) -> Void)?) {
        let request = ServerRequest(method: .get,
                                    path: "api/appconfig/getAppConfig",
                                    responseType: GetAppConfigResponse.self)
        ServiceManager.execute(request,
                               in: viewController,
                               completionHandle: { response in
                                if let getConfigResponse = response as? GetAppConfigResponse {
                                    getConfigResponse.save()
                                    completionHandler?(true)
                                } else {
                                    completionHandler?(false)
                                }
        }, animate: true)
    }

    // MARK: - Update device token
    
    final class func update(deviceToken token: String, completionHandle: ((_ completed: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "osType": "ios" as AnyObject,
                "deviceToken": token as AnyObject
            ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/seekers/updateDeviceToken",
                                        header: header,
                                        parameters: params,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request, completionHandle: { (response) in
                //
            }, showErrorMessage: false, animate: false)
        }
    }

    // MARK: - getAccessTokenTw
    
    final class func getAccessTokenTw(with name: String, in viewController: UIViewController?, completionHandle: ((_ token : String?) -> Void)?) {
        let params: [String: AnyObject] = ["userId": name as AnyObject]
        let request = ServerRequest(method: .post,
                                    encoding: Alamofire.JSONEncoding.default,
                                    path: "appconfig/getAccessTokenTw",
                                    parameters: params,
                                    responseType: ServerResponse.self)
        ServiceManager.execute(request, in: viewController, completionHandle: { response in
            let token = (response?.responseData as? [String: AnyObject])?["token"] as? String
            completionHandle?(token)
        }, animate: true)
    }

}

// MARK: - Profile
extension RequestManager {
    
    // MARK: - Login
    final class func login(username name: String?, password: String?, in viewController: UIViewController?, completionHandle: ((_ complete: Bool) -> Void)?) {
        var params: [String: String?] = [:]
        params["username"] = name
        params["password"] = password
        params["deviceToken"] = DataAccess.deviceToken()
        params["osType"] = "ios"
        
        let request = ServerRequest(method: .post,
                                    encoding: Alamofire.JSONEncoding.default,
                                    path: "api/seekers/authenticate",
                                    parameters: params as [String : AnyObject]?,
                                    responseType: LoginResponse.self)
        ServiceManager.execute(request, in: viewController, completionHandle: { response in
            if let res = response as? LoginResponse {
                res.save()
                completionHandle?(true)
            } else {
                completionHandle?(false)
            }
        }, animate: true)
    }
    
    // MARK: - Register
    
    final class func register(profile: RegisterModel, in viewController: UIViewController?, completionHandle: ((_ complete: Bool) -> Void)?) {
        if let params = profile.toDictionary() as? [String: AnyObject] {
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/seekers/register",
                                        parameters: params,
                                        responseType: LoginResponse.self)
            if let image = profile.avatar, let data = UIImageJPEGRepresentation(image, 1.0) {
                request.datas = [(data, "avatar", "image/jpeg")]
            }
            ServiceManager.execute(request, in: viewController, completionHandle: { response in
                if let res = response as? LoginResponse {
                    res.save()
                    completionHandle?(true)
                } else {
                    completionHandle?(false)
                }
            }, animate: false)
        } else {
            completionHandle?(false)
        }
    }
    
    // MARK: -  LogOut
    final class func logOut( in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/seekers/logout",
                                        header: header,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?(response != nil)
            }, animate: true)
        }
    }
    
    // MARK: - Upload video
    
    final class func upload(video file: Data, duration: Int64, questionNo: Int, in viewController: UIViewController?, completionHandle: ((_ video: Video?) -> Void)?) {
        var params: [String: AnyObject] = [:]
        params["name"] = "rize.mp4" as AnyObject?
        params["duration"] = duration as AnyObject?
        params["questionNo"] = questionNo as AnyObject?
        let request = ServerRequest(method: .post,
                                    encoding: Alamofire.URLEncoding.default,
                                    path: "api/video/upload",
                                    parameters: params,
                                    responseType: UploadVideoResponse.self)
        request.datas = [(file, "video", "video/mp4")]
        ServiceManager.execute(request, in: viewController, completionHandle: { response in
            if let uploadVideoResponse = response as? UploadVideoResponse {
                completionHandle?(uploadVideoResponse.video())
            } else {
                completionHandle?(nil)
            }
        }, animate: true)
    }
    
    // MARK: - Get Profile
    
    final class func getProfile(in viewController: UIViewController?, completionHandle: ((_ complete: Bool) -> Void)?) {
        
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/seekers/current",
                                        header: header,
                                        responseType: LoginResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { response in
                if let res = response as? LoginResponse {
                    res.save(with: accessToken)
                    completionHandle?(true)
                } else {
                    completionHandle?(false)
                }
            }, animate: true)
        }
    }
    
    
    // MARK: - Update Profile
    
    final class func upDateProfile(profile: RegisterModel, idUser: String, in viewController: UIViewController, animate: Bool = false, completionHandle: ((_ complete: Bool) -> Void)?) {
        if let params = profile.toDictionary() as? [String: AnyObject] {
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/seekers/update/" + idUser,
                                        parameters: params,
                                        responseType: UpdateProfileResponse.self)
            if let image = profile.avatar, let data = UIImageJPEGRepresentation(image, 1.0) {
                request.datas = [(data, "avatar", "image/jpeg")]
            }
            if let accessToken = DataAccess.accessToken() {
                let header = ["Authorization": "Bearer \(accessToken)"]
                request.header = header
            }
            
            ServiceManager.execute(request, in: viewController, completionHandle: { response in
                if let res = response as? UpdateProfileResponse {
                    res.save()
                    completionHandle?(true)
                } else {
                    completionHandle?(false)
                }
            }, animate: animate)
        } else {
            completionHandle?(false)
        }
    }
    
    // MARK: - Setting Profile
    
    final class func settingProfile(profile: RegisterModel, idUser: String, in viewController: UIViewController, completionHandle: ((_ complete: Bool) -> Void)?) {
        if let params = profile.toDictionary() as? [String: AnyObject] {
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/seekers/update/" + idUser,
                                        parameters: params,
                                        responseType: SettingResponse.self)
            if let image = profile.avatar, let data = UIImageJPEGRepresentation(image, 1.0) {
                request.datas = [(data, "avatar", "image/jpeg")]
            }
            if let accessToken = DataAccess.accessToken() {
                let header = ["Authorization": "Bearer \(accessToken)"]
                request.header = header
            }
            
            ServiceManager.execute(request, in: viewController, completionHandle: { response in
                if let res = response as? SettingResponse {
                    res.save()
                    completionHandle?(true)
                } else {
                    completionHandle?(false)
                }
            }, animate: false)
        } else {
            completionHandle?(false)
        }
    }
}

// MARK: - Jobs
extension RequestManager {
    // MARK: - Get Jobs
    
    final class func getJobs(in viewController: UIViewController?, completionHandle: ((_ jobs : [Job]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        path: "api/jobs/getAllJobs",
                                        header: header,
                                        responseType: GetJobsResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?((response as? GetJobsResponse)?.jobs())
            }, animate: true)
        } else {
            print("No Access Token")
        }
    }
    
    // MARK: - Get Job Info
    
    final class func getJobInfo(id string: String, in viewController: UIViewController?, completionHandle: ((_ job : Job?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        path: "api/jobs/getJobDetails/\(string)",
                header: header,
                responseType: GetJobInfoResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?((response as? GetJobInfoResponse)?.info())
            }, animate: true)
        } else {
            print("No Access Token")
        }
    }
    
    
    // MARK: - Interest Job
    
    final class func interest(job id: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        path: "api/jobs/interested/\(id)",
                header: header,
                responseType: ServerResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?(response != nil)
            }, showErrorMessage: false, animate: false)
        } else {
            print("No Access Token")
        }
    }
    
    // MARK: - Get Job Offers
    
    final class func getJobOffers(in viewController: UIViewController?, completionHandle: ((_ offer : [JobOffers]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        path: "api/jobs/getAllJobOffer",
                                        header: header,
                                        responseType: GetJobOffersResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?((response as? GetJobOffersResponse)?.offers())
            }, animate: true)
        } else {
            print("No Access Token")
        }
    }
    
    // MARK: - Get ActiveJob
    
    final class func getlistActiveJobs(in viewController: UIViewController?, completionHandle: ((_ activejob : [JobOffers]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        path: "api/jobs/getActiveJobs",
                                        header: header,
                                        responseType: GetListActiveJobs.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?((response as? GetListActiveJobs)?.activeJob())
            }, animate: true)
        } else {
            print("No Access Token")
        }
    }
    
    // MARK: - acceptOffer
    
    final class func acceptOffer(job id: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/jobs/acceptOffer/" + id,
                                        header: header,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request, in: viewController, completionHandle: { (response) in
                completionHandle?(response != nil)
            }, animate: true)
        } else {
            print("No Access Token")
        }
    }
}

// MARK: - Company
extension RequestManager {
    // MARK: - Get all companies
    final class func getCompanies(in viewController: UIViewController?, completionHandle: ((_ companies: [Company]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/companies/listOfCompanies",
                                        header: header,
                                        responseType: GetCompaniesResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getCompaniesResponse = response as? GetCompaniesResponse {
                                        completionHandle?(getCompaniesResponse.companies())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Get company info
    final class func get(companyByRecruiter recruiterId: String, in viewController: UIViewController?, completionHandle: ((_ company: Company?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/companies/getCompanyByRecruiterId/" + recruiterId,
                                        header: header,
                                        responseType: GetCompanyInfoResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getCompanyInfoResponse = response as? GetCompanyInfoResponse {
                                        completionHandle?(getCompanyInfoResponse.companyInfo())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Delete company
    final class func delete(company companyId: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        encoding: Alamofire.URLEncoding.default,
                                        path: "api/companies/deleteCompany" + companyId,
                                        header: header,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    completionHandle?(response != nil)
            }, animate: true)
        }
    }
}

// MARK: - Schedule
extension RequestManager {
    // MARK: - Get list schedules
    final class func getSchedules(in viewController: UIViewController?, completionHandle: ((_ schedules: [Schedule]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/schedules/getListSchedules",
                                        header: header,
                                        responseType: GetSchedulesResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getSchedulesResponse = response as? GetSchedulesResponse {
                                        completionHandle?(getSchedulesResponse.schedules())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Create schedule
    final class func createSchedule(recruiterId id: String, date dateString: String, in viewController: UIViewController?, completionHandle: ((_ schedule: Schedule?) -> Void)?) { // yyyy-MM-dd HH:mm
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "recruiterId": id as AnyObject,
                "dateString": dateString as AnyObject
            ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/schedules/createSchedule",
                                        header: header,
                                        parameters: params,
                                        responseType: CreateScheduleResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let createScheduleResponse = response as? CreateScheduleResponse {
                                        completionHandle?(createScheduleResponse.schedule())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Delete schedule
    final class func delete(schedule scheduleId: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) { // yyyy-MM-dd HH:mm
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "scheduleId": scheduleId as AnyObject,
                ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/schedules/deleteSchedule",
                                        header: header,
                                        parameters: params,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    completionHandle?(response != nil)
            }, animate: true)
        }
    }
    
    // MARK: - Update schedule
    final class func update(schedule scheduleId: String, date dateString: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) { // yyyy-MM-dd HH:mm
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "scheduleId": scheduleId as AnyObject,
                "dateString": dateString as AnyObject
            ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/schedules/updateSchedule",
                                        header: header,
                                        parameters: params,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    completionHandle?(response != nil)
            }, animate: true)
        }
    }
}

// MARK: - Chat
extension RequestManager {
    // MARK: - Get list conversation
    
    final class func getListConversation(in viewController: UIViewController?, completionHandle: ((_ conversations: [Conversation]) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/chats/getListConversation",
                                        header: header,
                                        responseType: GetListConversationResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getListConversationResponse = response as? GetListConversationResponse {
                                        completionHandle?(getListConversationResponse.conversations())
                                    } else {
                                        completionHandle?([])
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Get list message
    
    final class func getListMessage(for conversation: String, in viewController: UIViewController?, completionHandle: ((_ messages: [Message]) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = ["conversationId": conversation as AnyObject]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/chats/getListMessage",
                                        header: header,
                                        parameters: params,
                                        responseType: GetListMessageResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getListMessageResponse = response as? GetListMessageResponse {
                                        completionHandle?(getListMessageResponse.messages())
                                    } else {
                                        completionHandle?([])
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Send message
    
    final class func send(message text: String, for conversation: String?, to recruiter: String?, in viewController: UIViewController?, completionHandle: ((_ message: Message?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            var params: [String: AnyObject] = [
                "messageBody": text as AnyObject
            ]
            if let conversation = conversation {
                params["conversationId"] = conversation as AnyObject?
            } else if let recruiter = recruiter {
                params["recruiterId"] = recruiter as AnyObject?
            }
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/chats/sendMessage",
                                        header: header,
                                        parameters: params,
                                        responseType: SendMessageResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let sendMessageResponse = response as? SendMessageResponse {
                                        completionHandle?(sendMessageResponse.message())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: false)
        }
    }
}

// MARK: - Subscriptions
extension RequestManager {
    // MARK: - Get List WatchAds /
    final class func getListAds(in viewController: UIViewController?, completionHandle: ((_ schedules: [WatchAds]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/ads/getListAds",
                                        header: header,
                                        responseType: GetWatchAdsResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getWatchAdsResponse = response as? GetWatchAdsResponse {
                                        completionHandle?(getWatchAdsResponse.watchAds())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Get List Subscriptions
    final class func getListSubscriptions(in viewController: UIViewController?, completionHandle: ((_ schedules: [Subscription]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .get,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/subscriptions/getListSubscriptions",
                                        header: header,
                                        responseType: GetListSubScriptionResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getListSubScriptionResponse = response as? GetListSubScriptionResponse {
                                        completionHandle?(getListSubScriptionResponse.subscription())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Get List Training
    final class func getListTraining(in viewController: UIViewController?, completionHandle: ((_ schedules: [Training]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/training/getListCourses",
                                        header: header,
                                        responseType: GetTrainingResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getTrainingResponse = response as? GetTrainingResponse {
                                        completionHandle?(getTrainingResponse.training())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
   
    // MARK: - Get List EnrolledLessons
    final class func getListEnrolledLessons(in viewController: UIViewController?, completionHandle: ((_ schedules: [EnrolledLessons]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/training/getEnrolledLessons",
                                        header: header,
                                        responseType: GetEnrolledLessonsResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getEnrolledLessonsResponse = response as? GetEnrolledLessonsResponse {
                                        completionHandle?(getEnrolledLessonsResponse.enrolledLessons())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Lesson by Course
    final class func getLessonbyCourse(course courseId: String, in viewController: UIViewController?, completionHandle: ((_ success: [EnrolledLessons]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "courseId": courseId as AnyObject,
                ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/training/getLessonbyCourse",
                                        header: header,
                                        parameters: params,
                                        responseType: GetEnrolledLessonsResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getLessonbyCourseResponse = response as? GetEnrolledLessonsResponse {
                                        completionHandle?(getLessonbyCourseResponse.enrolledLessons())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - get Tasks By Lesson
    final class func getLessonbyCourse(lesson lessonId: String, in viewController: UIViewController?, completionHandle: ((_ success: [TasksByLesson]?) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "lessonId": lessonId as AnyObject,
                ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/training/getTasksByLesson",
                                        header: header,
                                        parameters: params,
                                        responseType: GetTaskByLessonsResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getTaskByLessonsResponse = response as? GetTaskByLessonsResponse {
                                        completionHandle?(getTaskByLessonsResponse.tasksByLesson())
                                    } else {
                                        completionHandle?(nil)
                                    }
            }, animate: true)
        }
    }

    // MARK: - enroll lessons
    final class func enrollLessons(lesson lessonId: String, in viewController: UIViewController?, completionHandle: ((_ success: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let params: [String: AnyObject] = [
                "lessonId": lessonId as AnyObject,
                ]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/training/enroll",
                                        header: header,
                                        parameters: params,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    completionHandle?(response != nil)
            }, animate: true)
        }
    }

}

// MARK: - Payment
extension RequestManager {
    // MARK: - Payment Detail
    final class func getPaymentDetails(in viewController: UIViewController?, completionHandle: ((_ isSuccess: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken() {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/payments/getDetails",
                                        header: header,
                                        responseType: GetPaymentDetailsResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if let getPaymentDetailsResponse = response as? GetPaymentDetailsResponse {
                                        getPaymentDetailsResponse.save()
                                        completionHandle?(true)
                                    } else {
                                        completionHandle?(false)
                                    }
            }, animate: true)
        }
    }
    
    // MARK: - Update payment method
    final class func update(payment method: Payment, in viewController: UIViewController?, completionHandle: ((_ isSuccess: Bool) -> Void)?) {
        if let accessToken = DataAccess.accessToken(), let params = method.parameters() as? [String: AnyObject] {
            let header = ["Authorization": "Bearer \(accessToken)"]
            let request = ServerRequest(method: .post,
                                        encoding: Alamofire.JSONEncoding.default,
                                        path: "api/payments/paySubmit",
                                        header: header,
                                        parameters: params,
                                        responseType: ServerResponse.self)
            ServiceManager.execute(request,
                                   in: viewController,
                                   completionHandle: { (response) in
                                    if response != nil {
                                        DataAccess.save(payment: method)
                                        completionHandle?(true)
                                    } else {
                                        completionHandle?(false)
                                    }
            }, animate: true)
        }
    }


}

