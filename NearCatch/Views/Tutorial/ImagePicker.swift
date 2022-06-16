import PhotosUI
import SwiftUI

struct ImagePicker: View {
    
    private let threeColumnGrid = [
        GridItem(.flexible(minimum: 40), spacing: 2),
        GridItem(.flexible(minimum: 40), spacing: 2),
        GridItem(.flexible(minimum: 40), spacing: 2),
    ]
    
    @Binding var profileImage: UIImage?
    @Binding var show: Bool
    @State var tempImage: Img?
    @State var disabled = true
    @State var grid : [Img] = []
    @State var startNoImageView: Bool = false
    @State var loadingState : Bool = true
    //    @State var selectedid =
    
    var body: some View {
        ZStack {
            VStack {
                // 만약 선택된 사진들이 있다면?
                if !self.grid.isEmpty{
                    HStack{
                        Button(action: {
                            self.show.toggle()
                        }){
                            Text("취소")
                        }.padding()
                        Spacer()
                        Button(action: {
                            // 사진 집어넣기 로직 필요
                            if self.tempImage != nil {
                                self.profileImage = tempImage!.image
                            }
                            self.show.toggle()
                        }) {
                            Text("등록")
                                .fontWeight(.heavy)
                        }.padding()
                        
                    }
                    // 앨범에서 선택한 사진들이 들어갈 스크롤 뷰
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        //                        VStack{
                        
                        // 수정중
                        LazyVGrid(columns: threeColumnGrid, alignment: .leading, spacing: 2) {
                            ForEach(0..<self.grid.count, id: \.self) { i in
                                //                        HStack{
                                ImageView(data: $grid[i], tempImage: $tempImage, grid: $grid)
                                //                                .frame(height: 200)
                                
                                //                        }
                            }
                        }
                        
                        
                        
                        //                        }
                    }
                }
                else {
                    // 설정이 deny 되었을때
                    if self.disabled{
                        VStack{
                            Text("권한을 허용하지 않으면 프로필 이미지를 등록할 수 없어요!")
                                .font(.custom("온글잎 의연체", size: 20))
                            Text("Setting에서 권한 설정을 변경해주세요")
                                .font(.custom("온글잎 의연체", size: 30))
                            
                            ImagePermissionInfoView()
                            //                            .scaledToFit()
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
                        }.onAppear{
                            if self.loadingState == true {
                                self.loadingState = false
                            }
                            
                        }
                        
                        
                    }
                    // 권한 accept 했다면?
                    else {
                        // 선택된 사진이 한장도 없을때!
                        if self.grid.count == 0{
                            if startNoImageView{
                                VStack{
                                    Text("선택된 사진이 없습니다.")
                                        .font(.custom("온글잎 의연체", size: 30))
                                    Text("사진을 추가해 주세요!")
                                        .font(.custom("온글잎 의연체", size: 20))
                                    NoImageInfoView()
                                    //                            .scaledToFit()
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
                            else{
                                VStack{}
                                    .onAppear{
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                            print("asdsadasd")
                                            self.startNoImageView = true
                                        }
                                    }
                            }
                            
                        }
                    }
                    
                }
            }
            
            if self.loadingState {
                ImageLoadingView()
            }
            
        }
        
        .onAppear{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.getAllImages()
                    self.disabled = false
                }
                else {
                    print("디나이")
                    self.disabled = true
                }
            }
        }
    }
    
    func getAllImages(){
        if self.loadingState == false{
            self.loadingState = true
        }
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            var iteration : [Img] = []
            for i in stride(from: 0, to: req.count, by: 1) {
                
                if i < req.count {
                    // 원본 화질로 하면, 보기는 좋지만 로딩되는 시간때문에 체크가 풀린다.
                    //                    PHCachingImageManager.default().requestImage(for: req[i], targetSize: .init(), contentMode: .default, options: options) { (image,_) in
                    PHCachingImageManager.default().requestImage(for: req[i], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image,_) in
                        let data = Img(image: image!, selected: false, asset: req[i])
                        iteration.append(data)
                    }
                    
                }
                print(iteration.count)
                self.grid = iteration
            }
            self.loadingState = false
        }
    }
}

//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var isShown: Bool
//    @Binding var image: Image?
//
//    // UIViewControllerRepresentable 프로토콜 준수
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
//        // 피커 생성.
//        let picker = UIImagePickerController()
//        // coordinator 정의 후 picker의 delegate를 설정.
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    // UIViewControllerRepresentable 프로토콜 준수
//    func updateUIViewController(_ uiViewController: UIImagePickerController,
//                                context: UIViewControllerRepresentableContext<ImagePicker>) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(isShown: $isShown, image: $image)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//
//        let isShown: Binding<Bool>
//        let image: Binding<Image?>
//
//        init(isShown: Binding<Bool>, image: Binding<Image?>) {
//            self.isShown = isShown
//            self.image = image
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController,
//                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//            self.image.wrappedValue = Image(uiImage: uiImage)
//            self.isShown.wrappedValue = false
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            isShown.wrappedValue = false
//        }
//
//    }
//
//
//
//
//
//}




//
//struct ImagePicker: UIViewControllerRepresentable {
//
//    @Binding var imageToImport: UIImage?
//    @Binding var isPresented: Bool
//    @Binding var imageWasImported: Bool
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
//
//        var configuration = PHPickerConfiguration()
//        configuration.selectionLimit = 1
//        configuration.filter = .images
//        let imagePicker = PHPickerViewController(configuration: configuration)
//        imagePicker.delegate = context.coordinator
//        return imagePicker
//    }
//
//    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {}
//
//    func makeCoordinator() -> ImagePicker.Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//
//        var parent: ImagePicker
//
//        init(parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//
//            picker.dismiss(animated: true)
//
//            if results.count != 1 {
//                return
//            }
//            print("여기인?")
//            if let image = results.first {
//
//                print("이히히 여기")
//
//                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    image.itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
//
//                        if let image = image {
//                            print("Import images")
//                            self.parent.imageToImport = image as? UIImage
//                            self.parent.imageWasImported.toggle()
//                        }
//                    }
//                }
//            }
//
//            self.parent.isPresented.toggle()
//        }
//    }
//}






////
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//
//    // UIViewControllerRepresentable 프로토콜 준수
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//
//        // configuration 설정하여, 하고싶은 것 제어
//        var config = PHPickerConfiguration()
//        // 선택할 수 있는 최대 asset 수 설정. 기본값이 1이다. 여러개 지정하고 싶다면 0으로 설정한다.
//        config.selectionLimit = 1
//        // 표시 타입을 제한하는 filter. 기본값은 nil. nil로 설정하면 모든 asset 타입 표시. images, videos, livePhotos, any 사용 가능.
//        config.filter = .images
//        // 만든 configuration으로 picker 만들기.
//        let picker = PHPickerViewController(configuration: config)
//        // coordinator 정의 후 picker의 delegate를 설정.
//        picker.delegate = context.coordinator
//        return picker
//
//
//    }
//
//    // UIViewControllerRepresentable 프로토콜 준수
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
//
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: ImagePicker
//
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        //꼭 정의해줘야하는 메서드. 선택한 미디어 정보들에 대한 메서드임. result에 내가 선택한 asset들이 들어가있음. 우리는 1개만 넣을거니까 한개 들어가 있을것.
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            // picker를 dismiss 시켜줌.
//            picker.dismiss(animated: true)
//            // item provider를 가져옴. item provider는 선택된 asset의 representation임.
//            guard let provider = results.first?.itemProvider else { return }
//
//            // provider가 내가 지정한 타입을 로드할 수 있는지 체크 후, 로드할 수 있으면 로드함.
//            if provider.canLoadObject(ofClass: UIImage.self) {
//                // loadObject는 completionHandler. NSItemProviderReading과 error를 반환함.
//                provider.loadObject(ofClass: UIImage.self) { image, _ in
//                    // NSItemProviderReading 타입이 반환되기 때문에, UIImage로 캐스팅해서 넣어줘야함.
//                    // itemProvider는 background async이기 때문에 UI관련된 업데이트를 하고싶으면 꼭 main에서 돌려줘야함.
//                    DispatchQueue.main.async {
//                        self.parent.image = image as? UIImage
//                    }
//
//                }
//            }
//        }
//    }
//}
