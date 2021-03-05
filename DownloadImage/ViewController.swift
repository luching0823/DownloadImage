//
//  ViewController.swift
//  DownloadImage
//
//  Created by 廖昱晴 on 2021/3/5.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var session: URLSession?
    let imageAddress = "https://images.pexels.com/photos/2486168/pexels-photo-2486168.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session = URLSession(configuration: .default) //產生預設設定的URLSession，並籲設在共時佇列下載
        if let url = URL(string: imageAddress) { //下載網址
//            let task = session?.dataTask(with: url, completionHandler: {(data, response, error) in //呼叫URLSession的dataTask方法，並回傳一個dataTask物件
//                if error != nil { //有錯誤
//                    print(error!.localizedDescription)
//                    return
//                }
//                if let loadedData = data {
//                    let loadedImage = UIImage(data: loadedData)
//                    DispatchQueue.main.async { //用主佇列main&非同步更新畫面
//                        self.imageView.image = loadedImage
//                    }
//                }
//            })
//            task?.resume() //呼叫dataTask方法後會開始下載，下載後呼叫completionHandler
            
            let newTask = session?.downloadTask(with: url, completionHandler: { (url, response, error) in
                if error != nil {
                    let errorCode = (error! as NSError).code
                    if errorCode == 1009 {
                        print("No Internet Connection")
                    } else {
                        print(error?.localizedDescription)
                    }
                    return
                }
                if let loadedUrl = url { //url為手機下載的位置
                    do {
                        let loadedImage = UIImage(data: try Data(contentsOf: loadedUrl)) //用Data下載
                        DispatchQueue.main.async { //用主佇列main&非同步更新畫面
                            self.imageView.image = loadedImage
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            
            newTask?.resume() //開始下載圖片
            
//            DispatchQueue.global().async { //用共時佇列&非同步執行。若用主佇列會等圖片下載完成才繼續執行程式
//                do {
//                    let imageData = try Data(contentsOf: url) //下載圖片
//                    let downloadImage = UIImage(data: imageData) //下載好的圖片
//                    DispatchQueue.main.async { //用主佇列(負責畫面顯示)更新畫面&非同步執行
//                        self.imageView.image = downloadImage
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
        }
        
    }


}

