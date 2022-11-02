//
//  ContentView.swift
//  Expenses
//
//  Created by Atakan Kömürcü on 6.10.2022.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Enviromental Variables
    @Environment(\.managedObjectContext) var managedObjContext
    
    @FetchRequest(entity: Tablo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Tablo.name, ascending: true)]) var tablolar: FetchedResults<Tablo>
    
    // MARK: Variables
    @State private var presentAlert = false
    @State private var tabloAd = ""
    
    
    var body: some View {
        NavigationView {
            List{
                ForEach(tablolar,id: \.self){tablo in
                    NavigationLink(destination: TabloView(Tablopredicate: tablo.id!)) {
                        VStack(alignment: .leading, spacing: 10){
                            Text("\(tablo.name ?? "Unknown")")
                            Text("\(tablo.tarih!.formatted(date: .numeric, time: .standard))")
                                .font(.caption)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Fav\(String(tablo.isFavorite))") {
                                tablo.isFavorite.toggle()
                                PersistenceController.shared.save()
                            }
                            .tint(.orange)
                        }
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationTitle("Tablolar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Ekle"){
                presentAlert.toggle()
            })
            .alert("Tablo Oluşturma", isPresented: $presentAlert, actions: {
                TextField("Tablo ismi", text: $tabloAd)
                
                Button("Ekle", action: {
                    addTablo(name: tabloAd)
                    tabloAd = ""
                })
                Button("Cancel", role: .cancel, action: {})
            })
            
            
        }

    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = tablolar[index]
            PersistenceController.shared.delete(item)
        }
    }
    
    func addTablo(name: String){
        let tablo = Tablo(context: managedObjContext)
        tablo.id = UUID().uuidString
        tablo.name = tabloAd
        tablo.tarih = Date()
        PersistenceController.shared.save()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

