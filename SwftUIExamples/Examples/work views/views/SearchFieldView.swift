import SwiftUI

public struct SearchFieldView: View {
    @Binding private var text : String
    private let tintColor: Color
    
    public init(searchText: Binding<String>, tintColor: Color = .gray) {
        _text = searchText
        self.tintColor = tintColor
    }
    
    public var body: some View {
        HStack(spacing: 10){
            ZStack{
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18,height: 18)
                    .foregroundStyle(tintColor.opacity(0.5))
            }
            TextField("", text: $text,prompt: Text(LocalizedStringResource(stringLiteral: "Search")))
                .frame(maxWidth: .infinity,alignment: .leading)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .ignoresSafeArea(.keyboard)

            
            if !text.isEmpty{
                Button {
                    withAnimation {
                        text = ""
                    }
                } label: {
                    Image(systemName: "xmark")
                        .opacity(0.5)
                }
                .foregroundStyle(tintColor)
                .animation(.easeInOut, value: text)
            }
        }
        .padding(10)
        .frame(height: 45)
        .frame(maxWidth: .infinity,alignment: .leading)
        .modifier(RoundedBorders(opacity: 0.5, color: tintColor))
        .ignoresSafeArea(.keyboard)

    }
}


#Preview {
    @Previewable @State var search : String = ""
    SearchFieldView(searchText: $search)
}


//public struct SearchFieldView: View {
//    @Environment(\.theme) var theme
//    @Binding private var text : String
//    
//    public init(searchText : Binding<String>){
//        _text = searchText
//    }
//    
//    public var body: some View {
//        HStack(spacing: 10){
//            ZStack{
//                Image(systemName: "magnifyingglass")
//                    .resizable()
//                    .frame(width: 18,height: 18)
//                    .foregroundStyle(theme.textColor.opacity(0.5))
//            }
//            TextField("", text: $text,prompt: Text(LocalizedStringResource(stringLiteral: "Search")))
//                .frame(maxWidth: .infinity,alignment: .leading)
//                .autocorrectionDisabled()
//                .submitLabel(.search)
//                .ignoresSafeArea(.keyboard)
//
//            
//            if !text.isEmpty{
//                Button {
//                    withAnimation {
//                        text = ""
//                    }
//                } label: {
//                    Image(systemName: "xmark")
//                        .opacity(0.5)
//                }
//                .foregroundStyle(theme.textColor)
//                .animation(.easeInOut, value: text)
//            }
//        }
//        .padding(10)
//        .frame(height: 45)
//        .frame(maxWidth: .infinity,alignment: .leading)
//        .modifier(RoundedBorders(opacity: 0.5, color: theme.textColor))
//        .ignoresSafeArea(.keyboard)
//
//    }
//}
//
//
//#Preview {
//    @Previewable @State var search : String = ""
//    SearchFieldView(searchText: $search)
//}
