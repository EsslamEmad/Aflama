//
//  AddFashionTableViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 3/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit
import AVFoundation
import AVKit

class AddFashionTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate{

    var fashion = Fashion()
    var category: Category!
    
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var bodyTypeTextField: UITextField!
    @IBOutlet weak var skinColorTextField: UITextField!
    @IBOutlet weak var hairColorTextField: UITextField!
    @IBOutlet weak var hairTypeTextField: UITextField!
    @IBOutlet weak var eyesColorTextField: UITextField!
    @IBOutlet weak var dressSizeTextField: UITextField!
    @IBOutlet weak var bootsSizeTextField: UITextField!
    @IBOutlet weak var jeansHeightTextField: UITextField!
    @IBOutlet weak var jeansWidthTextField: UITextField!
    @IBOutlet weak var tshirtSizeTextField: UITextField!
    @IBOutlet weak var attachmentsView: UIView!
    @IBOutlet weak var attachmentsLabel: UILabel!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    @IBOutlet weak var addVideoImageView: UIImageView!
    @IBOutlet weak var addVideoLabel: UILabel!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    private let heightPicker = UIPickerView()
    private let weightPicker = UIPickerView()
    private let bodyTypePicker = UIPickerView()
    private let skinColorPicker = UIPickerView()
    private let hairColorPicker = UIPickerView()
    private let hairTypePicker = UIPickerView()
    private let eyesColorPicker = UIPickerView()
    private let dressSizePicker = UIPickerView()
    private let bootsSizePicker = UIPickerView()
    private let jeansHeightPicker = UIPickerView()
    private let jeansWidthPicker = UIPickerView()
    private let tshirtSizePicker = UIPickerView()
    private var inputAccessoryBar: UIToolbar!
    let heightArray = Array(100...210)
    let weightArray = Array(35...140)
    let bodyTypeArray = [NSLocalizedString("نحيف", comment: ""),NSLocalizedString("معتدل", comment: ""),NSLocalizedString("رياضي معتدل", comment: ""),NSLocalizedString("عضلي معتدل البنية", comment: ""),NSLocalizedString("عضلي كبير البنية", comment: ""),NSLocalizedString("متين", comment: "")]
    let skinColorArray = [NSLocalizedString("فاتحة اللون", comment: ""), NSLocalizedString("فاتحة بدرجة أقل", comment: ""), NSLocalizedString("قمحية", comment: ""), NSLocalizedString("حنطية", comment: ""), NSLocalizedString("برونزية", comment: ""), NSLocalizedString("سمراء", comment: "")]
    let hairColorArray = [NSLocalizedString("أشقر فاتح", comment: ""), NSLocalizedString("أشقر داكن", comment: ""), NSLocalizedString("أسود", comment: ""), NSLocalizedString("بني فاتح", comment: ""), NSLocalizedString("بني داكن", comment: ""), NSLocalizedString("بني أشقر", comment: ""), NSLocalizedString("أبيض", comment: ""), NSLocalizedString("برتقالي", comment: ""), NSLocalizedString("رمادي", comment: ""), NSLocalizedString("أحمر", comment: ""), NSLocalizedString("أخضر", comment: ""), NSLocalizedString("أزرق", comment: ""), NSLocalizedString("وردي", comment: ""), NSLocalizedString("بنفسجي", comment: "")]
    let hairTypeArray = [NSLocalizedString("أجعد", comment: ""), NSLocalizedString("أكثر تجعيدا", comment: ""), NSLocalizedString("ناعم", comment: ""), NSLocalizedString("عادي", comment: ""), NSLocalizedString("ملولو", comment: ""), NSLocalizedString("مموج", comment: "")]
    let eyesColorArray = [NSLocalizedString("أخضر", comment: ""), NSLocalizedString("أصفر", comment: ""), NSLocalizedString("بني", comment: ""), NSLocalizedString("أزرق", comment: ""), NSLocalizedString("رمادي", comment: ""), NSLocalizedString("أسود", comment: "")]
    let dressSizeArray = Array(30...70)
    let bootsSizeArray = Array(30...50)
    let jeansHeightArray = Array(15...40)
    let jeansWidthArray = Array(15...40)
    let tshirtSizeArray = ["XS", "S", "M", "L", "XL", "XXL", "XXXL"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        tableView.backgroundView = imageView
        containerView.clipsToBounds = true
        sendButton.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        sendButton.layer.cornerRadius = 10.0
        attachmentsLabel.text = category.scinario
        self.title = category.title
        initializeToolbar()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }

    
    @IBAction func didPressSend(_ sender: Any) {
        guard fashion.height != nil, fashion.weight != nil, fashion.bodyType != nil, fashion.skinColor != nil, fashion.hairColor != nil, fashion.hairType != nil, fashion.eyeColor != nil, fashion.abayaSize != nil, fashion.bootSize != nil, fashion.jeansWidth != nil, fashion.jeansLength != nil, fashion.tshirtSize != nil, ImagePicked, videoPicked else {
            self.showAlert(withMessage: NSLocalizedString("من فضلك أضف جميع البيانات المطلوبة", comment: ""))
            return
        }
        fashion.userID = Auth.auth.user!.id
        fashion.subCategory = category.id
        if let url = videoURL {
            let asset = AVAsset(url: url)
            
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            
            print(durationTime)
            guard durationTime < 31.0 else {
                self.showAlert(withMessage: NSLocalizedString("مدة الفيديو لا يمكن أن تتعدى الثلاثون ثانية", comment: ""))
                return
            }
        }
        videoUpload()
        //imagesUpload(index: 0)
        SVProgressHUD.show()
        sendButton.isEnabled = false
    }
    
    func videoUpload(){
        sendButton.setTitle(NSLocalizedString("جاري رفع الفيديو", comment: ""), for: .normal)
        print(videoURL!)
        firstly{
            return API.CallApi(APIRequests.upload(image: nil, file: nil, video: videoURL!))
            }.done {
                let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                self.fashion.video = resp.image
                self.imagesUpload(index: 0)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
                self.sendButton.setTitle(NSLocalizedString("إرسال", comment: ""), for: .normal)
        }
    }
    
    func imagesUpload(index: Int){
        guard index != images.count else {
            formUpload()
            return
        }
        sendButton.setTitle(NSLocalizedString("جاري رفع الصورة \(index + 1) من \(images.count)", comment: ""), for: .normal)
        firstly{
            return API.CallApi(APIRequests.upload(image: images[index], file: nil, video: nil))
            }.done {
                let resp = try! JSONDecoder().decode(UploadResponse.self, from: $0)
                self.fashion.photos.append(resp.image)
                self.imagesUpload(index: index + 1)
            }.catch {
                self.showAlert(withMessage: $0.localizedDescription)
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
                self.sendButton.setTitle(NSLocalizedString("إرسال", comment: ""), for: .normal)
        }
    }
    
    func formUpload(){
        sendButton.setTitle(NSLocalizedString("جاري إرسال الإستمارة", comment: ""), for: .normal)
        firstly{
            return API.CallApi(self.category.parent == 1 ? APIRequests.addActing(acting: fashion) : APIRequests.addFashion(fashion: fashion))
            }.done { resp in
                self.showAlert(error: false, withMessage: NSLocalizedString("تم إرسال الإستمارة بنجاح", comment: ""), completion: {(UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                self.performMainSegue()
                
            }.catch{
                self.showAlert(withMessage: $0.localizedDescription)
            }.finally {
                SVProgressHUD.dismiss()
                self.sendButton.isEnabled = true
                self.sendButton.setTitle(NSLocalizedString("إرسال", comment: ""), for: .normal)
        }
    }

func performMainSegue(animated: Bool = true){
    guard let window = UIApplication.shared.keyWindow else { return }
    guard let rootViewController = window.rootViewController else { return }
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
    vc.view.frame = rootViewController.view.frame
    vc.view.layoutIfNeeded()
    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
        window.rootViewController = vc
    })
}

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = category.scinario
        let neededSize = label.sizeThatFits(CGSize(width: self.view.frame.width - 80, height: CGFloat.greatestFiniteMagnitude))
        return neededSize.height + 1067
    }
    
    //Mark: add and play video
    let imagePickerController = UIImagePickerController()
    var videoURL: URL?
    @IBAction func addVideo(_ sender: Any) {
        guard !videoPicked else {
            if let videoURL = videoURL{
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
            return
        }
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.movie"]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Mark: Pickers
    
    
    
    private func initializePickers() {
        print(1)
        heightPicker.delegate = self
        heightPicker.dataSource = self
        heightTextField.inputView = heightPicker
        heightTextField.inputAccessoryView = inputAccessoryBar
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightTextField.inputView = weightPicker
        weightTextField.inputAccessoryView = inputAccessoryBar
        bodyTypePicker.delegate = self
        bodyTypePicker.dataSource = self
        bodyTypeTextField.inputView = bodyTypePicker
        bodyTypeTextField.inputAccessoryView = inputAccessoryBar
        skinColorPicker.delegate = self
        skinColorPicker.dataSource = self
        skinColorTextField.inputView = skinColorPicker
        skinColorTextField.inputAccessoryView = inputAccessoryBar
        hairColorPicker.delegate = self
        hairColorPicker.dataSource = self
        hairColorTextField.inputView = hairColorPicker
        hairColorTextField.inputAccessoryView = inputAccessoryBar
        hairTypePicker.delegate = self
        hairTypePicker.dataSource = self
        hairTypeTextField.inputView = hairTypePicker
        hairTypeTextField.inputAccessoryView = inputAccessoryBar
        eyesColorPicker.delegate = self
        eyesColorPicker.dataSource = self
        eyesColorTextField.inputView = eyesColorPicker
        eyesColorTextField.inputAccessoryView = inputAccessoryBar
        dressSizePicker.delegate = self
        dressSizePicker.dataSource = self
        dressSizeTextField.inputView = dressSizePicker
        dressSizeTextField.inputAccessoryView = inputAccessoryBar
        bootsSizePicker.delegate = self
        bootsSizePicker.dataSource = self
        bootsSizeTextField.inputView = bootsSizePicker
        bootsSizeTextField.inputAccessoryView = inputAccessoryBar
        jeansHeightPicker.delegate = self
        jeansHeightPicker.dataSource = self
        jeansHeightTextField.inputView = jeansHeightPicker
        jeansHeightTextField.inputAccessoryView = inputAccessoryBar
        jeansWidthPicker.delegate = self
        jeansWidthPicker.dataSource = self
        jeansWidthTextField.inputView = jeansWidthPicker
        jeansWidthTextField.inputAccessoryView = inputAccessoryBar
        tshirtSizePicker.delegate = self
        tshirtSizePicker.dataSource = self
        tshirtSizeTextField.inputView = tshirtSizePicker
        tshirtSizeTextField.inputAccessoryView = inputAccessoryBar
    }
    
    private func initializeToolbar() {
        inputAccessoryBar = UIToolbar(frame: CGRect(x: 0, y:0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(title: NSLocalizedString("تم", comment: ""), style: .done, target: self, action: #selector(dismissPicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        inputAccessoryBar.items = [flexibleSpace, doneButton]
        initializePickers()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print(3)
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case heightPicker:
            return heightArray.count
        case weightPicker:
            return weightArray.count
        case bodyTypePicker:
            return bodyTypeArray.count
        case skinColorPicker:
            return skinColorArray.count
        case hairColorPicker:
            return hairColorArray.count
        case hairTypePicker:
            return hairTypeArray.count
        case eyesColorPicker:
            return eyesColorArray.count
        case dressSizePicker:
            return dressSizeArray.count
        case bootsSizePicker:
            return bootsSizeArray.count
        case jeansHeightPicker:
            return jeansHeightArray.count
        case jeansWidthPicker:
            return jeansWidthArray.count
        case tshirtSizePicker:
            return tshirtSizeArray.count
        default:
            return 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case heightPicker:
            return String(heightArray[row])
        case weightPicker:
            return String(weightArray[row])
        case bodyTypePicker:
            return bodyTypeArray[row]
        case skinColorPicker:
            return skinColorArray[row]
        case hairColorPicker:
            return hairColorArray[row]
        case hairTypePicker:
            return hairTypeArray[row]
        case eyesColorPicker:
            return eyesColorArray[row]
        case dressSizePicker:
            return String(dressSizeArray[row])
        case bootsSizePicker:
            return String(bootsSizeArray[row])
        case jeansHeightPicker:
            return String(jeansHeightArray[row])
        case jeansWidthPicker:
            return String(jeansWidthArray[row])
        case tshirtSizePicker:
            return tshirtSizeArray[row]
        default: return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case heightPicker:
            heightTextField.text = String(heightArray[row])
            fashion.height = Double(heightArray[row])
        case weightPicker:
            weightTextField.text = String(weightArray[row])
            fashion.weight = Double(weightArray[row])
        case bodyTypePicker:
            bodyTypeTextField.text = bodyTypeArray[row]
            fashion.bodyType = bodyTypeArray[row]
        case skinColorPicker:
            skinColorTextField.text = skinColorArray[row]
            fashion.skinColor = skinColorArray[row]
        case hairColorPicker:
            hairColorTextField.text = hairColorArray[row]
            fashion.hairColor = hairColorArray[row]
        case hairTypePicker:
            hairTypeTextField.text = hairTypeArray[row]
            fashion.hairType = hairTypeArray[row]
        case eyesColorPicker:
            eyesColorTextField.text = eyesColorArray[row]
            fashion.eyeColor = eyesColorArray[row]
        case dressSizePicker:
            dressSizeTextField.text = String(dressSizeArray[row])
            fashion.abayaSize = dressSizeArray[row]
        case bootsSizePicker:
            bootsSizeTextField.text = String(bootsSizeArray[row])
            fashion.bootSize = bootsSizeArray[row]
        case jeansHeightPicker:
            jeansHeightTextField.text = String(jeansHeightArray[row])
            fashion.jeansLength = jeansHeightArray[row]
        case jeansWidthPicker:
            jeansWidthTextField.text = String(jeansWidthArray[row])
            fashion.jeansWidth = jeansWidthArray[row]
        case tshirtSizePicker:
            tshirtSizeTextField.text = tshirtSizeArray[row]
            fashion.tshirtSize = row + 1
        default: return
        }
        
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    
    //Mark: Image and video Picker
    
    @IBAction func PickImage(recognizer: UITapGestureRecognizer) {
        print(2)
        guard images.count < 10 else {
            self.showAlert(withMessage: NSLocalizedString("لا يمكنك إضافة المزيد من الصور", comment: ""))
            return
        }
        
        let alert = UIAlertController(title: "", message: NSLocalizedString("اختر طريقة رفع الصورة.", comment: ""), preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: NSLocalizedString("الكاميرا", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .camera
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى الكاميرا الخاصة بك", comment: ""))
            }
        })
        let photoAction = UIAlertAction(title: NSLocalizedString("مكتبة الصور", comment: ""), style: .default, handler: {(UIAlertAction) -> Void in
            SVProgressHUD.show()
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: {() -> Void in SVProgressHUD.dismiss()})
            }
            else{
                SVProgressHUD.dismiss()
                self.showAlert(withMessage: NSLocalizedString("التطبيق لا يستطيع الوصول إلى مكتبة الصور الخاصة بك", comment: ""))
            }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("إلغاء", comment: ""), style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    var ImagePicked = false
    var videoPicked = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let infoimg = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let selectedImage = infoimg[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage{
            images.append(selectedImage)
            photosCollectionView.reloadData()
            ImagePicked = true
            print(4)
        } else if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL{
            print(5)
            videoURL = url
            videoPicked = true
            print(videoURL)
            let asset = AVURLAsset(url: videoURL!, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            if let cgImage = cgImage{
                let uiImage = UIImage(cgImage: cgImage)
                addVideoImageView.image = uiImage
                addVideoImageView.contentMode = .scaleAspectFill
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: CollectionView Protocols
    
    var images = [UIImage]()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(6)
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AttachementCollectionViewCell
        item.photo.image = images[indexPath.item]
        item.deleteButton.tag = indexPath.item
        item.deleteButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didPressDelete(_:)))
        item.deleteButton.addGestureRecognizer(gesture)
        return item
    }
    
    @objc func didPressDelete(_ gesture: UITapGestureRecognizer) {
        images.remove(at: gesture.view!.tag)
        photosCollectionView.reloadData()
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .numberPad && string != "" {
            let numberStr: String = string
            let formatter: NumberFormatter = NumberFormatter()
            formatter.locale = Locale(identifier: "EN")
            if let final = formatter.number(from: numberStr) {
                textField.text =  "\(textField.text ?? "")\(final)"
            }
            return false
        }
        return true
    }*/
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
