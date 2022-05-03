//
//  APISessionDataPublisher.swift
//  Music Browser
//
//  Created by Angelina on 03.05.22.
//

import Foundation

protocol APIDataTaskPublisher {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

final class APISessionDataPublisher: APIDataTaskPublisher {

    var session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        session.dataTaskPublisher(for: request)
    }
}
