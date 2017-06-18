//
//  GitHubSearchRepositoriesAPI.swift
//  GitTool
//
//  Created by M_Sugawara on 2017/06/12.
//  Copyright © 2017年 M_Sugawara. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
#endif

import struct Foundation.URL
import struct Foundation.Data
import struct Foundation.URLRequest
import struct Foundation.NSRange
import class Foundation.HTTPURLResponse
import class Foundation.URLSession
import class Foundation.NSRegularExpression
import class Foundation.JSONSerialization
import class Foundation.NSString



/**
 Parsed GitHub repository
 */
struct Repository: CustomDebugStringConvertible {
    var name: String
    var url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

extension Repository {
    var debugDescription: String {
        return "\(name) | \(url)"
    }
}

/**
Service state.
*/
enum GitHubServiceError: Error {
    case offline
    case githubLimitReached
    case networkError
}


typealias SearchRepositoriesResponse = Result<(repositories: [Repository], nextURL: URL?), GitHubServiceError>

///**
// Raw response from GitHubAPI
// */
//enum SearchRepositoryResponse {
//    /**
//     New repositories just fetched
//     */
//    case repositories(repositories: [Repository], nextURL: URL?)
//    
//    /**
//     In case there was some problem fetching data from service, this will be returned.
//     It really doesn't matter if that is a failure in network layer, parsing error or something else.
//     In case data can't be read and parsed properly, something is wrong with server response.
//     */
//    case serviceOffline
//    
//    /**
//     This example uses unauthenticated GitHub API. That API does have throttling policy and you won't
//     be able to make more then 10requests per minute.
//     
//     That is actually an awesome scenario to demonstrate complex retries using alert views and combination of timers.
//     
//     Just search like mad, and everything will be handled right.
//     */
//    case limitExceeded
//}
//
///**
// This is the final result of loading.
// */
//struct RepositoriesState {
//    /**
//     List of persed repositories ready to be shown in the UI.
//     */
//    let repositories: [Repository]
//    
//    /**
//     Current network state.
//     */
//    let serviceState: ServiceState?
//    
//    /**
//     Limit exceeded
//     */
//    let limitExceeded: Bool
//    
//    static let empty = RepositoriesState(repositories: [], serviceState: nil, limitExceeded: false)
//}

class GitHubSearchRepositoriesAPI {
    
    // ******************************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised
    // !!! This is just a simple way to move services to one location so you can see Rx code
    // ******************************************************************************************************
    static let sharedAPI = GitHubSearchRepositoriesAPI(reachabilityService: try! DefaultReachabilityService())
    
    fileprivate let _reachabilityService: ReachabilityService
    
    private init(reachabilityService: ReachabilityService) {
        _reachabilityService = reachabilityService
    }
}

// MARK: Pagination
extension GitHubSearchRepositoriesAPI {
//    /**
//     public fascade for search
//     */
//    func search(_ query: String, loadNextPageTrigger: Observable<Void>) -> Observable<RepositoriesState> {
//        let escapedQuery = query.URLEscaped
//        let url = URL(string: "https://api.github.com/search/repositories?q=\(escapedQuery)")!
//        return recursivelySearch([], loadNextURL: url, loadNextPageTrigger: loadNextPageTrigger)
//            // Here we go again
//            .startWith(RepositoriesState.empty)
//    }
//    
//    private func recursivelySearch(_ loadedSoFar: [Repository], loadNextURL: URL, loadNextPageTrigger: Observable<Void>) -> Observable<RepositoriesState> {
//        return loadSearchURL(loadNextURL).flatMap { searchResponse -> Observable<RepositoriesState> in
//            switch searchResponse {
//                /**
//                 If service is offline, that's ok, that means that this isn't the last thing we've heard from that API.
//                 It will retry until either battery drains, you become angry and close the app or evil machine comes back from the future, steals your device and Googles Sarah Conner's address.
//                 */
//            case .serviceOffline:
//                return Observable.just(RepositoriesState(repositories: loadedSoFar, serviceState: .offline, limitExceeded: false))
//                
//            case .limitExceeded:
//                return Observable.just(RepositoriesState(repositories: loadedSoFar, serviceState: .online, limitExceeded: true))
//                
//            case let .repositories(newPageRepositories, maybeNextURL):
//                
//                var loadedRepositories = loadedSoFar
//                loadedRepositories.append(contentsOf: newPageRepositories)
//                
//                let appendedRepositories = RepositoriesState(repositories: loadedRepositories, serviceState: .online, limitExceeded: false)
//                
//                // if next page can't be loaded just return wat was loaded, and stop.
//                guard let nextURL = maybeNextURL else {
//                    return Observable.just(appendedRepositories)
//                }
//                
//                return Observable.concat([
//                    // return loaded immediately
//                    Observable.just(appendedRepositories),
//                    // wait until next page can be loaded
//                    Observable.never().takeUntil(loadNextPageTrigger),
//                    // load next page
//                    self.recursivelySearch(loadedRepositories, loadNextURL: nextURL, loadNextPageTrigger: loadNextPageTrigger)
//                    ])
//            }
//        }
//    }
    
    public func loadSearchURL(_ searchURL: URL) -> Observable<SearchRepositoriesResponse> {
        return URLSession.shared
            .rx.response(request: URLRequest(url: searchURL))
            .retry(3)
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .map { httpResponse, data -> SearchRepositoriesResponse in
                if httpResponse.statusCode == 403 {
                    return .failure(.githubLimitReached)
                }
                let jsonRoot = try GitHubSearchRepositoriesAPI.parseJSON(httpResponse, data: data)
                
                guard let json = jsonRoot as? [String: AnyObject] else {
                    throw exampleError("Casting to dictionary failed")
                }
                
                let repositories = try Repository.parse(json)
                
                let nextURL = try GitHubSearchRepositoriesAPI.parseNextURL(httpResponse)
                
                return .success(repositories: repositories, nextURL: nextURL)
            }
            .retryOnBecomesReachable(.failure(.offline), reachabilityService: _reachabilityService)
    }
}

// MARK: Parsing the response

extension GitHubSearchRepositoriesAPI {
    
    private static let parseLinksPattern = "\\s*,?\\s*<([^\\>]*)>\\s*;\\s*rel=\"([^\"]*)\""
    private static let linksRegex = try! NSRegularExpression(pattern: parseLinksPattern, options: [.allowCommentsAndWhitespace])
    
    fileprivate static func parseLinks(_ links: String) throws -> [String: String] {
        let length = (links as NSString).length
        let matches = GitHubSearchRepositoriesAPI.linksRegex.matches(in: links, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: length))
        
        var result: [String: String] = [:]
        
        for m in matches {
            let matches = (1 ..< m.numberOfRanges).map({ (rangeIndex) -> String in
                let range = m.rangeAt(rangeIndex)
                let startIndex = links.characters.index(links.startIndex, offsetBy: range.location)
                let endIndex = links.characters.index(links.startIndex, offsetBy: range.location + range.length)
                let stringRange = startIndex ..< endIndex
                return links.substring(with: stringRange)
            })
            
            if matches.count != 2 {
                throw exampleError("Error parsing links")
            }
            
            result[matches[1]] = matches[0]
        }
        return result
    }
    
    fileprivate static func parseNextURL(_ httpResponse: HTTPURLResponse) throws -> URL? {
        guard let serializedLinks = httpResponse.allHeaderFields["Link"] as? String else {
            return nil
        }
        
        let links = try GitHubSearchRepositoriesAPI.parseLinks(serializedLinks)
        
        guard let nextPageURL = links["next"] else {
            return nil
        }
        
        guard let nextUrl = URL(string: nextPageURL) else {
            throw exampleError("Error parsing next url `\(nextPageURL)`")
        }
        
        return nextUrl
    }
    
    fileprivate static func parseJSON(_ httpResponse: HTTPURLResponse, data: Data) throws -> AnyObject {
        if !(200 ..< 300 ~= httpResponse.statusCode) {
            throw exampleError("Call failed")
        }
        
        return try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
    }
}

extension Repository {
    fileprivate static func parse(_ json: [String: AnyObject]) throws -> [Repository] {
        guard let items = json["items"] as? [[String: AnyObject]] else {
            throw exampleError("Can't find items")
        }
        
        return try items.map { item in
            guard let name = item["name"] as? String,
                let url = item["url"] as? String else {
                    throw exampleError("Can't parse repository")
            }
            return Repository(name: name, url: try URL(string: url).unwrap())
        }
    }
}
