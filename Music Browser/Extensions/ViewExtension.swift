//
//  ViewExtension.swift
//  Music Browser
//
//  Created by Angelina on 02.05.22.
//

import SwiftUI

extension View {

    @ViewBuilder func isRemoved(_ remove: Bool) -> some View {
        if remove {
        } else {
            self
        }
    }
}
