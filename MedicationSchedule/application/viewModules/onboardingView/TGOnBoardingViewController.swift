//
//  TGOnBoardingViewController.swift
//  MedicationSchedule
//
//  Created by Anh Tuan on 11/26/19.
//  Copyright © 2019 Anh Tuan. All rights reserved.
//

import UIKit

class TGOnBoardingViewController: UIViewController, UIScrollViewDelegate{
    //Outlet
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mPageControl: UIPageControl!
    
    @IBOutlet weak var mSkipButton: UIButton!
    //Variable
    var pages:[OnBoardingPageUIView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        self.initUI()
    }
    
    @IBAction func tapSkipButton(_ sender: Any) {
        print("tap skip button")
        let vc = TGHomeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func initUI() {
        pages = createOnBoardingPages()
        setupSlideScrollView(slides: pages)
        mScrollView.delegate = self
        mPageControl.numberOfPages = pages.count
        mPageControl.currentPage = 0
        view.bringSubviewToFront(mPageControl)
        mSkipButton.layer.cornerRadius = 8
    }
    /*
     * Create page of onboarding view
     */
    func createOnBoardingPages() -> [OnBoardingPageUIView] {
        let page1:OnBoardingPageUIView = Bundle.main.loadNibNamed("OnBoardingPageUIView", owner: self, options: nil)?.first as! OnBoardingPageUIView
        page1.mImageView.image = UIImage(named: "icon_intro01")
        page1.mLableContent.text = "Intro 1 - Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed \ndiam nonummy nibh euismod\nIncident \nut laoreet dolore magna \naliquam erat volutpat"
        page1.mLableTitle.text = "INTRO 1"
        let page2:OnBoardingPageUIView = Bundle.main.loadNibNamed("OnBoardingPageUIView", owner: self, options: nil)?.first as! OnBoardingPageUIView
        page2.mImageView.image = UIImage(named: "icon_intro02")
        page2.mLableTitle.text = "INTRO 2"
        page2.mLableContent.text = "Intro 2 - Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed \ndiam nonummy nibh euismod\nIncident \nut laoreet dolore magna \naliquam erat volutpat"
        
        let page3:OnBoardingPageUIView = Bundle.main.loadNibNamed("OnBoardingPageUIView", owner: self, options: nil)?.first as! OnBoardingPageUIView
        page3.mImageView.image = UIImage(named: "icon_intro03")
        page3.mLableTitle.text = "INTRO 3"
        page3.mLableContent.text = "Intro 3 - Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed \ndiam nonummy nibh euismod\nIncident \nut laoreet dolore magna \naliquam erat volutpat"
        return [page1, page2, page3]
    }
    
    func setupSlideScrollView(slides : [OnBoardingPageUIView]) {
        mScrollView.alwaysBounceVertical = false
        mScrollView.alwaysBounceHorizontal = false
        mScrollView.bounces = false
        mScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height - 100)
        
        mScrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height - 100)
            mScrollView.addSubview(slides[i])
        }
    }
    
    /*
     * Callback from scroll view
     * This function handle animation for image onBoarding view
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        mPageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        /*
         * scales imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.5) {
            pages[0].mImageView.transform = CGAffineTransform(scaleX: (0.5-percentOffset.x)/0.5, y: (0.5-percentOffset.x)/0.5)
            pages[1].mImageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.5, y: percentOffset.x/0.5)
            self.mSkipButton.setTitle("Skip", for: UIControl.State.normal)
        } else if(percentOffset.x > 0.5 && percentOffset.x <= 1) {
            pages[1].mImageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.5, y: (1-percentOffset.x)/0.5)
            pages[2].mImageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
            self.mSkipButton.setTitle("Start", for: UIControl.State.normal)
        }
    }
}
