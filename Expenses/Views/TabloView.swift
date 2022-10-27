//
//  TabloView.swift
//  Expenses
//
//  Created by Atakan Kömürcü on 8.10.2022.
//

import SwiftUI

struct TabloView: View {
    
    @State private var giderAd = ""
    @State private var giderDeger = 0
    @State private var presentGiderEkle: Bool = false
    
    @State private var giderToplam = 0
    
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
    
    private func toplamGider() {
        giderToplam = 0
        giderler.forEach { gider in
            giderToplam += Int(gider.deger)
        }
    }
    
    private func addGider() {
        let gider = Gider(context: managedObjContext)
        gider.name = giderAd
        gider.tarih = Date()
        gider.deger = Int32(giderDeger)
        gider.tabloID = predicate
        PersistenceController.shared.save()
    }
    
    var body: some View {
        NavigationView {
            VStack{
                Text("$ \(giderToplam)")
                    .padding(.top, 20)
                List{
                    ForEach(giderler) {gider in
                            HStack(){
                                VStack(alignment: .leading){
                                    Text("\(gider.name ?? "unknown")")
                                        .padding(.bottom, 10)
                                    Text("\(gider.tarih?.formatted(.dateTime) ?? Date().formatted(.dateTime))")
                                        .font(.caption)
                                }
                                Spacer()
                                Text("$ \(String(gider.deger.formatted(.number)))")
                            }
                    }
                    .onDelete(perform: removeItem)
                }
            }
        }
        .navigationTitle("\(tabloAd)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Ekle"){
            // TODO: Gider eklemek için açılacak olan sheet eklenecek
            presentGiderEkle.toggle()
        })
        .onAppear {
            toplamGider()
        }
        .sheet(isPresented: $presentGiderEkle) {
            Form{
                Section(header: Text("İsim")) {
                    TextField("Gider İsmi", text: $giderAd)
                }

                Section(header: Text("Değer")) {
                    TextField("Değer", value: $giderDeger, format: .number)
                }
                
                Button("Kaydet"){
                    addGider()
                    giderAd = ""
                    giderDeger = 0
                    toplamGider()
                    presentGiderEkle.toggle()
                }
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        toplamGider()
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
