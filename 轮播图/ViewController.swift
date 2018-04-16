//
//  ViewController.swift
//  轮播图
//
//  Created by wxw on 2018/4/13.
//  Copyright © 2018年 wxw. All rights reserved.
//

import UIKit

//全局变量
let ScreenWidth  = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
let imgArr = ["4","1","2","3","4","1"]//["dd","a","b","c","d","aa"] //count > 2
var mTimer = Timer()
var currentPageIndex = 2


class ViewController: UIViewController ,UIScrollViewDelegate{

    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView
        let rect = CGRect(x: 0, y: 40 + 20, width: ScreenWidth, height: 200)
        scrollView = createScrollView(rect:rect)
        view.addSubview(scrollView)
        crollToBeginStatus()
        
        //pageControl
        let rect2 = CGRect(x: 0, y: rect.maxY - 20, width: ScreenWidth, height: 20)
        pageControl = createPageControl(rect: rect2)
        view.addSubview(pageControl)
        
        //timer
        mTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { (timer) in
            self.crollToPageIndex(index: currentPageIndex)
            currentPageIndex += 1
        })
        
    }
    
//func for scroll
    //动画事件 滚动事件,收尾页处理
    func crollToPageIndex(index:Int){//偏移到第几张
        
        UIView.animate(withDuration: 1.0) {
            self.scrollToThisPage(index: index)
        }
        
        if index >= imgArr.count - 1 {
            crollToBeginStatus()
            currentPageIndex = 1
        }
        else if index == 0 {
            crollToEndStatus()
            currentPageIndex = imgArr.count - 2
        }
        
    }
    //跳到第几页
    func scrollToThisPage(index: Int){//跳到第几页
        scrollView.contentOffset = CGPoint(x:CGFloat(index) * scrollView.frame.width , y: 0)
    }
    //跳到"假前面一张"
    func crollToBeginStatus() {
        scrollToThisPage(index: 1)
    }
    //跳到"假最后一张"
    func crollToEndStatus() {
        scrollToThisPage(index: imgArr.count - 2)
    }
    //处理 pageControl.currentPage , 传入真实的index
    func handlePageControlCurrentPage(index:Int) {
        
        pageControl.currentPage = index - 1
        
        /* 貌似不需要这个,因为 scrollViewDidScroll 会重新计算偏移量 ,
         if index == imgArr.count - 1 {
         pageControl.currentPage = 0
         }
         if index == 0 {
         pageControl.currentPage = imgArr.count - 2
         }
         */
        
    }
    
    //获取当前是处于真正的第几张
    func getScrollViewCurrentIndex(scroll:UIScrollView) -> Int {
        let index = scroll.contentOffset.x / scroll.frame.width
        return Int(index + 0.5)
    }
    

    
//控件
    //UIScrollView
    func createScrollView(rect:CGRect) -> UIScrollView {
        let scrollV = UIScrollView(frame: rect)
        scrollV.contentSize = CGSize(width: rect.width * CGFloat(imgArr.count), height: rect.height)
        scrollV.backgroundColor = UIColor.lightGray
        scrollV.bounces = false
        scrollV.isPagingEnabled = true
        scrollV.delegate = self
        
        var index = 0
        for i in imgArr {
            
            let image = UIImage.init(named: i + ".jpg")
            let imgV = UIImageView.init(image: image)
            imgV.frame = CGRect(x: rect.width * CGFloat(index), y: 0, width: rect.width, height: rect.height)
            scrollV.addSubview(imgV)
            
            let label = UILabel()
            label.frame = CGRect(x: rect.width * CGFloat(index), y: 0, width: rect.width, height: rect.height)
            label.text = i
            label.textColor = UIColor.blue//UIColor.white
            label.textAlignment = .center
            label.backgroundColor = UIColor.clear //UIColor.init(white: 0.7, alpha: 0.7)
            label.font = UIFont.systemFont(ofSize: 44)
            scrollV.addSubview(label)
            index += 1
        }

        return scrollV
    }
    
    //UIPageControl
    func createPageControl(rect:CGRect)->UIPageControl{
        let pageC = UIPageControl(frame: rect)
        pageC.currentPage = 0
        pageC.currentPageIndicatorTintColor = UIColor.white
        pageC.numberOfPages = imgArr.count - 2
        pageC.pageIndicatorTintColor = UIColor.darkGray
        pageC.backgroundColor = UIColor.clear
        return pageC
        
    }

//代理
    //UIScrollView delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {//开始拽 暂停计时器
        mTimer.fireDate = Date.distantFuture
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {//减速结束 重启计时器
        let index = getScrollViewCurrentIndex(scroll: scrollView)
        currentPageIndex = index+1
        mTimer.fireDate = Date.distantPast
        print(index,"jian--su--end")
        crollToPageIndex(index: index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {//在动则调用 及其频繁 ,可以处理跟随变动者pageControl
        let index = getScrollViewCurrentIndex(scroll: scrollView)
        handlePageControlCurrentPage(index: index)
        print("dataArrIndex===",index)
    }
    

//关闭计时器
    override func viewWillDisappear(_ animated: Bool) {
        mTimer.invalidate()
        super.viewWillDisappear(animated)
    }
  
//其他
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//扩展
extension UIColor {
    //返回随机颜色
    class var randomColor: UIColor {
        get {
            let red = CGFloat(arc4random()%256)/255.0
            let green = CGFloat(arc4random()%256)/255.0
            let blue = CGFloat(arc4random()%256)/255.0
            return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
    }
}

