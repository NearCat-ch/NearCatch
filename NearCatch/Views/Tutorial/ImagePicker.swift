import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var imageToImport: UIImage?
    @Binding var isPresented: Bool
    @Binding var imageWasImported: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: configuration)
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: ImagePicker.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            if results.count != 1 {
                return
            }
            
            if let image = results.first {
                
                print("Aqui")
                
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
                        
                        if let image = image {
                            print("Importou imagem")
                            self.parent.imageToImport = image as? UIImage
                            self.parent.imageWasImported.toggle()
                        }
                    }
                }
            }
            
            self.parent.isPresented.toggle()
        }
    }
}


//
//struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var image: UIImage?
//
//    // UIViewControllerRepresentable 프로토콜 준수
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//
//
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
//        //꼭 정의해줘야하는 메서드. 선택한 미디어 정보들에 대한 메서드임. result에 내가 선택한 asset들이 들어가있음.
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
