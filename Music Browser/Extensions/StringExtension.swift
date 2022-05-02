//
//  StringExtension.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import Foundation

extension String {

    var preparedSearchString: String {
        let deletingStrings = ["«", "»", "’", "`", "±", "§", "^", "*", "!", "?", ",", "$", "&", "+", "=", "-", "№", "<", ">", "#", "\\", "/", ":", ";", "~", "[", "]", "{", "}", "(", ")", "%", "@", "…", "+", "...", "."]
        var searchQuery = self
        deletingStrings.forEach { deletingString in
            searchQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return searchQuery
    }
}
