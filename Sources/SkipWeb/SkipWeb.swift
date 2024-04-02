// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SwiftUI
import OSLog

let logger: Logger = Logger(subsystem: "SkipWeb", category: "WebView")

let homePage = "https://en.wikipedia.org/wiki/Special:Random" // "https://wikipedia.org"
let homeURL = URL(string: homePage)!

/// A store for persisting `WebBrowser` state such as history, favorites, and preferences.
public protocol WebBrowserStore {
    func saveItems(type: PageInfo.PageType, items: [PageInfo]) throws
    func loadItems(type: PageInfo.PageType, ids: Set<PageInfo.ID>) throws -> [PageInfo]
    func removeItems(type: PageInfo.PageType, ids: Set<PageInfo.ID>) throws
}

/// Information about a web page, for storing in the history or favorites list
public struct PageInfo : Identifiable {
    public typealias ID = Int64

    /// Whether the page is a favorite bookmark or history item
    public enum PageType {
        case history
        case favorite
    }

    /// The ID of this history item if it is persistent; 0 indicates that it is new
    public var id: ID
    public var url: URL
    public var title: String?
    public var date: Date

    public init(id: ID = Int64(0), url: URL, title: String? = nil, date: Date = Date.now) {
        self.id = id
        self.url = url
        self.title = title
        self.date = date
    }
}


#if !SKIP
extension URL {
    public func normalizedHost(stripWWWSubdomainOnly: Bool = false) -> String? {
        // Use components.host instead of self.host since the former correctly preserves
        // brackets for IPv6 hosts, whereas the latter strips them.
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), var host = components.host, host != "" else {
            return nil
        }

        let textToReplace = stripWWWSubdomainOnly ? "^(www)\\." : "^(www|mobile|m)\\."

        #if !SKIP
        if let range = host.range(of: textToReplace, options: .regularExpression) {
            host.replaceSubrange(range, with: "")
        }
        #endif

        return host
    }

    /// Returns the base domain from a given hostname. The base domain name is defined as the public domain suffix with the base private domain attached to the front. For example, for the URL www.bbc.co.uk, the base domain would be bbc.co.uk. The base domain includes the public suffix (co.uk) + one level down (bbc).
    public var baseDomain: String? {
        //guard !isIPv6, let host = host else { return nil }
        guard let host = host else { return nil }

        // If this is just a hostname and not a FQDN, use the entire hostname.
        if !host.contains(".") {
            return host
        }
        return nil

    }

    public var domainURL: URL {
        if let normalized = self.normalizedHost() {
            // Use URLComponents instead of URL since the former correctly preserves
            // brackets for IPv6 hosts, whereas the latter escapes them.
            var components = URLComponents()
            components.scheme = self.scheme
            #if !SKIP // TODO: This API is not yet available in Skip
            components.port = self.port
            #endif
            components.host = normalized
            return components.url ?? self
        }

        return self
    }
}
#endif


