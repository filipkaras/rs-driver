//
//  URLSession+Cache.swift
//  RS Driver
//
//  Created by Filip Karas on 25/03/2023.
//

import Foundation
import Combine

extension URLSession {
    
    func dataTaskPublisher(for url: URL, cachedResponseOnError: Bool) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {

        return self.dataTaskPublisher(for: url)
            .tryCatch { [weak self] (error) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Never> in
                guard cachedResponseOnError,
                    let urlCache = self?.configuration.urlCache,
                    let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url))
                else {
                    throw error
                }

                // we have implemented caching to dataTaskPublisher
                // when the netword call fails we will return cache (if available)
                return Just(URLSession.DataTaskPublisher.Output(
                    data: cachedResponse.data,
                    response: cachedResponse.response
                )).eraseToAnyPublisher()
                
        }.eraseToAnyPublisher()
    }
}
