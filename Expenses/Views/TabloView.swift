//
//  TabloView.swift
//  Expenses
//
//  Created by Atakan Kömürcü on 8.10.2022.
//

import SwiftUI

struct TabloView: View {
    
    // TODO: Girilen tablonun adı çekilecek
    var tabloAd = "Şimdilik Boş"
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    var predicate = ""
    var giderRequest : FetchRequest<Gider>
    var giderler : FetchedResults<Gider>{giderRequest.wrappedValue}
    
    init(predicate:String){
            self.predicate = predicate
            self.giderRequest = FetchRequest(entity: Gider.entity(), sortDescriptors: [], predicate:
                NSPredicate(format: "%K == %@", #keyPath(Gider.tabloID),predicate))

        }
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var giders: FetchedResults<Gider>
    
    private func addGider() {
        let gider = Gider(context: managedObjContext)
        gider.name = "GiderDeneme"
        gider.tarih = Date()
        gider.tabloID = predicate
        PersistenceController.shared.save()
    }
    
    var body: some View {
        NavigationView {
            List{
                ForEach(giderler) {gider in
                    VStack{
                        HStack{
                            Text("\(gider.name ?? "unknown")")
                            Spacer()
                            Text("\(gider.tarih?.formatted(.dateTime) ?? Date().formatted(.dateTime))")
                        }
                        Text("\(gider.tabloID ?? "Unknown")")
                            .font(.caption)
                    }
                }
                .onDelete(perform: removeItem)
            }
        }
        .navigationTitle("\(tabloAd)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Ekle"){
            // TODO: Gider eklemek için açılacak olan sheet eklenecek
            addGider()
        })
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = giderler[index]
            PersistenceController.shared.delete(item)
        }
    }
}

struct TabloView_Previews: PreviewProvider {
    static var previews: some View {
        TabloView(predicate: "lh3123j12")
    }
}
