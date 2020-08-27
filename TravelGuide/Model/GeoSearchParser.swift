//
//  GeoSearchParser.swift
//  TravelGuide2
//
//  Created by Petri Tilli on 18.3.2020.
//  Copyright © 2020 Petri Tilli. All rights reserved.
//

import Foundation

//NSXMLParserDelegate needed for parsing the file and NSObject is needed by NSXMLParserDelegate
class GeoSearchParser: NSObject {

    private let timestampFormatter = ISO8601DateFormatter()

    override init() {
        super.init()

        timestampFormatter.formatOptions = [.withFullDate,
                                            .withTime,
                                            .withDashSeparatorInDate,
                                            .withColonSeparatorInTime]
    }
}

extension GeoSearchParser: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
    }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
    }
}

