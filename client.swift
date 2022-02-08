
import SwiftUI
import PlaygroundSupport
import Foundation

struct HomePage: View{
    let title: String
    let tag: String 
    @StateObject var dataModel = SampleDataModel()
    
    var body:some View{
        List{
            ScrollView{
                LazyVGrid(columns: Array(repeating: GridItem(), count: 1)){
                    ForEach(dataModel.fetchedImages.filter{
                        (a)-> Bool in return a.tag == tag
                    }){
                        image in 
                        NavigationLink{
                            VStack(alignment: .leading, spacing:16){
//                                Text(image.title)
//                                    .font(.title2)
//                                    .bold()
//                                    .padding()
                                Text(image.message)
                                    .font(.body)
                                    .padding()
                                Spacer()
                            }
                            .navigationTitle(image.title)
                            
                        }label: {
                            GeometryReader{
                                proxy in
                                let size = proxy.size
                                
                                AsyncImage(url: URL(string: image.image)){
                                    image in image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:size.width,height:size.height)
                                        .cornerRadius(15)
                                }placeholder: {
                                    ProgressView()
                                }
                                .frame(width:size.width,height:size.height)
                            }
                            .frame(width:450,height:150)
                            //.resizable()
                            .aspectRatio(contentMode:.fill)
                            .overlay(
                                HStack{
                                    Spacer()
                                    Text(image.title)
                                        .font(.system(.headline))
                                    Spacer()
                                }
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.5))
                                ,alignment:.bottom
                            )
                        }
                        .cornerRadius(15)
                        .shadow(radius:10)
                    }
                    .padding(.all)
                }
            }.navigationTitle(title)
        }
        .task {
            do{
                dataModel.fetchedImages = try await dataModel.fetchImage()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

class SampleDataModel:ObservableObject{
    @Published var fetchedImages:[ImageModel] = []
    func fetchImage() async throws ->[ImageModel]{
        guard let url = URL(string:"http://syjsu.cn/history/data.json?=1") else{throw ImageError.failed}
        let (data,_) = try await URLSession.shared.data(from:url)
        let json = try JSONDecoder().decode([ImageModel].self, from: data)
        return json
    }
}

enum ImageError:Error{
    case failed
}

struct ImageModel: Identifiable, Codable{
    var id: Int
    var tag: String
    var image: String
    var title:String
    var message:String
}

struct Sidebar: View {
    var body: some View {
        List{
            NavigationLink(
                destination: HomePage(
                    title:"亚洲历史",
                    tag:"aisa"
                )
            ) {
                Text("亚洲历史").font(.headline)
            }
            NavigationLink(
                destination: HomePage(
                    title:"欧洲历史",
                    tag:"euro"
                )
            ) {
                Text("欧洲历史").font(.headline)
            }
        }.listStyle(SidebarListStyle())
    }
}


struct ContentView:View{
    var body: some View{
        ZStack{
            NavigationView {
                Sidebar()
                HomePage(
                    title:"亚洲历史",
                    tag:"aisa"
                )
            }
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
