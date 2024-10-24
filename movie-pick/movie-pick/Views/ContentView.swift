import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.mainColor1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        
        TabView(selection: $selectedTab) { // TabView'de selection parametresi kullanılıyor
            NavigationView {
                MovieView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 0 {
                        Image("movieSelectedIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Movies")
                    } else {
                        Image("MovieIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(0)
            
            NavigationView {
                MovieView()
            }
            .tabItem {
                VStack {
                    if selectedTab == 1 {
                        Image("showSelectedIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Shows")
                    } else {
                        Image("showIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("")
                    }
                }
            }
            .tag(1)
        }
        .background(Color.mainColor1)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
