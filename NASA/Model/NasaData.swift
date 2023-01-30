//
//  NasaData.swift
//  NASA
//
//  Created by Nuntapat Hirunnattee on 23/1/2566 BE.
//

import Foundation

struct NasaData: Codable{
    let copyright: String?
    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let service_version: String
    let title: String
    let url: String
}
