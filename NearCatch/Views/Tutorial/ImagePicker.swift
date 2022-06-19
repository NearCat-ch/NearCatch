import PhotosUI
import SwiftUI

struct ImagePicker: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40), spacing: 2),
        GridItem(.flexible(minimum: 40), spacing: 2),
        GridItem(.flexible(minimum: 40), spacing: 2),
    ]
    
    @Binding var profileImage: UIImage?
    @State var disabled = true
    @State var grid : [Img] = []
    @State var startNoImageView: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                // 만약 선택된 사진들이 있다면?
                if !self.grid.isEmpty{
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }){
                            Text("취소")
                        }.padding()
                        Spacer()
                    }
                    
                    // 앨범에서 선택한 사진들이 들어갈 스크롤 뷰
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: threeColumnGrid, alignment: .leading, spacing: 2) {
                            ForEach(0..<self.grid.count, id: \.self) { i in
                                Rectangle()
                                    .fill(.black)
                                    .aspectRatio(1, contentMode: .fit)
                                    .overlay{
                                        Image(uiImage: grid[i].image)
                                            .resizable()
                                            .scaledToFill()
                                    }
                                    .clipped()
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        self.profileImage = grid[i].image
                                        presentationMode.wrappedValue.dismiss()
                                    }
                            }
                        }
                    }
                }
                else {
                    // 설정이 deny 되었을때
                    if self.disabled{
                        ImagePermissionCheckView()
                    }
                    // 권한 accept 했다면?
                    else {
                        // 선택된 사진이 한장도 없을때!
                        if self.grid.count == 0{
                            if startNoImageView{
                                NoImageInfoView()
                            }
                            else{
                                VStack{}
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.4){
                                            self.startNoImageView = true
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .onAppear{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.getAllImages()
                    self.disabled = false
                }
                else {
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.resizeMode = .exact
            
            var iteration : [Img] = []
            for i in stride(from: 0, to: req.count, by: 1) {
                if i < req.count {
                    // 원본 화질로 하면, 보기는 좋지만 로딩되는 시간때문에 체크가 풀린다.
                    PHCachingImageManager.default().requestImage(for: req[i], targetSize: .init(), contentMode: .default, options: options) { (image,_) in
                        let data = Img(image: image!, selected: false, asset: req[i])
                        iteration.append(data)
                    }
                }
                DispatchQueue.main.async {
                    self.grid = iteration
                }
            }
        }
    }
}

struct ImageSelectButton<Content: View>: View {
    
    @State private var isPresentedAllImage = false
    @State private var isPresentedImage = false
    @State private var isPresentedPermissionCheck = false
    @Binding var image: UIImage?
    
    let content: () -> Content
    
    init(image: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self._image = image
        self.content = content
    }
    
    var body: some View {
        Button {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                switch status {
                case .authorized:
                    isPresentedAllImage.toggle()
                case .limited:
                    isPresentedImage.toggle()
                default:
                    isPresentedPermissionCheck.toggle()
                }
            }
        } label: {
            content()
        }
        
        .sheet(isPresented: $isPresentedAllImage) {
            AllImagePicker(profileImage: $image)
        }
        
        .sheet(isPresented: $isPresentedPermissionCheck) {
            ImagePermissionCheckView()
        }
        .sheet(isPresented: $isPresentedImage) {
            ImagePicker(profileImage: $image)
        }
    }
}

struct AllImagePicker: UIViewControllerRepresentable {
    @Binding var profileImage: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: AllImagePicker
        
        init(_ parent: AllImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.profileImage = image as? UIImage
                }
            }
        }
    }
}

struct ImagePermissionCheckView: View {
    
    @State var loadingState : Bool = true
    
    var body: some View {
        VStack{
            Text("권한을 허용하지 않으면 프로필 이미지를 등록할 수 없어요!")
                .font(.custom("온글잎 의연체", size: 20))
            Text("Setting에서 권한 설정을 변경해주세요")
                .font(.custom("온글잎 의연체", size: 30))
            
            ImagePermissionInfoView()
                .frame(height: UIScreen.main.bounds.height * 2 / 4)
            Button {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.PrimaryColor)
                        .frame(maxWidth: .infinity).frame(height: 50)
                    
                    Text("설정 바로가기")
                        .foregroundColor(.black)
                        .font(.custom("온글잎 의연체", size: 28))
                }
            }
            .padding(.top,30)
            .padding(.leading,20)
            .padding(.trailing,20)
        }
    }
}
