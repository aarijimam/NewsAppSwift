//
//  NewsService.swift
//  NewsApp
//
//  Created by Aarij Imam on 25/05/2024.
//

import Foundation
import Combine


//protocol for news api
protocol NewsService{
    //anypublisher subscribea and listen to object
    //first definition is success and second is error
    //Any publisher is very similar to result? -difference is with anypublisher you are subscribing to what it is listening
    func request(from endpoint: ArticleAPI) -> AnyPublisher<ArticleResponse,APIError>

}

//Implementation of newsservice
//Using struct to make it lightweight
struct NewsServiceImpl: NewsService{
    func request(from endpoint: ArticleAPI) -> AnyPublisher<ArticleResponse,APIError>{
        //create json decoder and set datedecodingstrategy because api gives date in string
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        print(endpoint.urlRequest)
        //used to send APICall in iosDevelopment
        return URLSession
            //access the singleton that urlsession offers
            .shared
            //with new combine framework listens to results of the service (listening to urlrequest in news endpoint)
            .dataTaskPublisher(for: endpoint.urlRequest)
            //receive on main thread (listen on main thread) (Api should be called on background thread not on main by default urlsession does this. You want to receive it on main after call
            .receive(on: DispatchQueue.main)
            //map error to unknown error in apierror enum
            .mapError{ _ in APIError.unknown}
            //flatten everything to data an response (flatmap returns publisher)
            .flatMap{data, response -> AnyPublisher<ArticleResponse,APIError> in
                //fail if no response
                guard let response = response as? HTTPURLResponse else{
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                //check if response code is decodable
                if (200...299).contains(response.statusCode){
                    return Just(data)
                        //decode using our decoder
                        .decode(type: ArticleResponse.self, decoder: jsonDecoder)
                        //error if decoding fail
                        .mapError{ _ in APIError.decodingError}
                        .eraseToAnyPublisher()
                }else{
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            //convert that we send back to a generic publisher
            .eraseToAnyPublisher()

    }
}
