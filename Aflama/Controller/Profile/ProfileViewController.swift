//
//  ProfileViewController.swift
//  Aflama
//
//  Created by Esslam Emad on 7/3/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import UIKit
import PromiseKit
import AVFoundation
import AVKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var worksButton: UIButton!
    @IBOutlet weak var appsButton: UIButton!
    @IBOutlet weak var infoHL: UIView!
    @IBOutlet weak var worksHL: UIView!
    @IBOutlet weak var appsHL: UIView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var worksCollectionView: UICollectionView!
    @IBOutlet weak var appsTableView: UITableView!
    @IBOutlet weak var selectLevelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: Auth.auth.user?.photo ?? ""){
            profilePicture.kf.setImage(with: url)
            profilePicture.kf.indicatorType = .activity
            profilePicture.layer.cornerRadius = 40.0
            profilePicture.clipsToBounds = true
        }
        selectLevelButton.layer.cornerRadius = 5.0
        selectLevelButton.clipsToBounds = true
        nameLabel.text = Auth.auth.user?.name
        infoTableView.delegate = self
        infoTableView.dataSource = self
        worksCollectionView.delegate = self
        worksCollectionView.dataSource = self
        appsTableView.delegate = self
        appsTableView.dataSource = self
        didPressInfo(nil)
        infoTableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView = UIImageView(image: UIImage(named: "group_70"))
        imageView.contentMode = .scaleAspectFill
        infoTableView.backgroundView = imageView
        worksCollectionView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView1 = UIImageView(image: UIImage(named: "group_70"))
        imageView1.contentMode = .scaleAspectFill
        worksCollectionView.backgroundView = imageView1
        appsTableView.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
        let imageView2 = UIImageView(image: UIImage(named: "group_70"))
        imageView2.contentMode = .scaleAspectFill
        appsTableView.backgroundView = imageView2
        firstly{
            return API.CallApi(APIRequests.getuserWorks(userID: Auth.auth.user!.id))
            }.done {
                let w = try! JSONDecoder().decode(Works.self, from: $0)
                if let p = w.photos{ self.works.photos = p}
                if let v = w.videos{ self.works.videos = v}
                if let s = w.sounds{ self.works.sounds = s}
                self.worksCollectionView.reloadData()
            }.catch {
                print($0.localizedDescription)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func didPressInfo(_ sender: Any?) {
        infoButton.setTitleColor(UIColor(red: 32/255, green: 87/255, blue: 112/255, alpha: 1), for: .normal)
        infoHL.alpha = 1
        worksButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        worksHL.alpha = 0
        appsButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        appsHL.alpha = 0
        infoTableView.alpha = 1
        worksCollectionView.alpha = 0
        appsTableView.alpha = 0
    }
    
    @IBAction func didPressWorks(_ sender: Any) {
        worksButton.setTitleColor(UIColor(red: 32/255, green: 87/255, blue: 112/255, alpha: 1), for: .normal)
        worksHL.alpha = 1
        infoButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        infoHL.alpha = 0
        appsButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        appsHL.alpha = 0
        infoTableView.alpha = 0
        worksCollectionView.alpha = 1
        appsTableView.alpha = 0
    }
    @IBAction func didPressApps(_ sender: Any) {
        appsButton.setTitleColor(UIColor(red: 32/255, green: 87/255, blue: 112/255, alpha: 1), for: .normal)
        appsHL.alpha = 1
        worksButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        worksHL.alpha = 0
        infoButton.setTitleColor(UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1), for: .normal)
        infoHL.alpha = 0
        infoTableView.alpha = 0
        worksCollectionView.alpha = 0
        appsTableView.alpha = 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == infoTableView{
            return 9
        }else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == infoTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! InfoTableViewCell
            switch indexPath.row{
            case 0:
                cell.keyLabel.text = NSLocalizedString("البريد الإلكتروني", comment: "")
                cell.valueLabel.text = Auth.auth.user?.email
            case 1:
                cell.keyLabel.text = NSLocalizedString("رقم الجوال", comment: "")
                cell.valueLabel.text = Auth.auth.user?.phone
            case 2:
                cell.keyLabel.text = NSLocalizedString("الجنس", comment: "")
                cell.valueLabel.text = Auth.auth.user?.gender == 1 ? NSLocalizedString("ذكر", comment: "") : NSLocalizedString("أنثى", comment: "")
            case 3:
                cell.keyLabel.text = NSLocalizedString("العمر", comment: "")
                cell.valueLabel.text = String(Auth.auth.user?.age ?? 0)
            case 4:
                cell.keyLabel.text = NSLocalizedString("القدرة على السفر", comment: "")
                cell.valueLabel.text = Auth.auth.user?.travel == 1 ? NSLocalizedString("نعم", comment: "") : NSLocalizedString("لا", comment: "")
            case 5:
                cell.keyLabel.text = NSLocalizedString("الجنسية", comment: "")
                cell.valueLabel.text = Auth.auth.user?.nationality
            case 6:
                cell.keyLabel.text = NSLocalizedString("الدولة", comment: "")
                cell.valueLabel.text = Auth.auth.user?.country
            case 7:
                cell.keyLabel.text = NSLocalizedString("المدينة", comment: "")
                cell.valueLabel.text = Auth.auth.user?.city
            case 8:
                cell.keyLabel.text = NSLocalizedString("نبذة", comment: "")
                cell.valueLabel.text = Auth.auth.user?.about
            default: break
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var works = Works()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return works.videos?.count ?? 0 + (works.photos?.count ?? 0) + (works.sounds?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WorkCollectionViewCell
        if indexPath.row < works.videos?.count ?? 0{
            cell.type = 1
            cell.url = works.videos![indexPath.row]
            cell.photo.image = UIImage(named: "play-button-3")
            cell.photo.contentMode = .center
        } else if indexPath.row < works.videos?.count ?? 0 + (works.photos?.count ?? 0) {
            if let url = URL(string: works.photos![indexPath.row - (works.videos?.count ?? 0)]){
                cell.photo.kf.setImage(with: url)
                cell.photo.kf.indicatorType = .activity
            }
            cell.type = 2
            cell.url = works.photos![indexPath.row - (works.videos?.count ?? 0)]
        }else {
            cell.type = 3
            cell.url = works.sounds![indexPath.row - ((works.videos?.count ?? 0) + (works.photos?.count ?? 0))]
            cell.photo.image = UIImage(named: "play-button-3")
            cell.photo.contentMode = .center
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! WorkCollectionViewCell
        switch cell.type{
        case 1:
            if let videoURL = URL(string: cell.url){
                let player = AVPlayer(url: videoURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        case 2:
            break
        case 3:
            if(isPlaying)
            {
                Pause()
            }
            else
            {
                if let url = URL(string: cell.url)
                {
                    audioFilename = url
                    playingCell = cell
                    Play()
                }
                else
                {
                    self.showAlert(withMessage: NSLocalizedString("لم يتم العثور على الملف الصوتي", comment: ""))
                }
            }
        default: return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 , height: view.frame.size.width / 3)
    }
    
    var player = AVQueuePlayer()
    var isPlaying = false
    var audioFilename: URL!
    var playingCell: WorkCollectionViewCell!
    func Play()
    {
       
            player.removeAllItems()
            player.insert(AVPlayerItem(url: audioFilename), after: nil)
            player.play()
            playingCell.photo.image = UIImage(named: "round-pause-button")
            isPlaying = true
        
        
    }
    
    
    
    func Pause(){
        player.pause()
        playingCell.photo.image = UIImage(named: "play-button-3")
        isPlaying = false
    }
    
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Pause()
    }
}
