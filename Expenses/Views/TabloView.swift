//
//  TabloView.swift
//  Expenses
//
//  Created by Atakan Kömürcü on 8.10.2022.
//

import SwiftUI

struct TabloView: View {
    
    @Environment(\.managedObjectContext) var managedObjContext
    var tabloAd = ""
    
    var body: some View {
        Text("\(tabloAd)")
    }
}

struct TabloView_Previews: PreviewProvider {
    static var previews: some View {
        TabloView()
    }
}
