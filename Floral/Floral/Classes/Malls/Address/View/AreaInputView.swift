//
//  AreaInputView.swift
//  Floral
//
//  Created by 孙林 on 16/6/5.
//  Copyright © 2016年 ALin. All rights reserved.
//

import UIKit

class AreaInputView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    /// 当前的当前位置
    weak var locationFiled : UITextField?
    {
        didSet{
            locationFiled?.text = "北京,通州"
        }
    }
    
    // 当前选中的省份的index
    private var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(statePicker)
        
        statePicker.snp_makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return allDatas.count ?? 0
        }
        return allDatas[index].cities!.count ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            let count  = allDatas.count ?? 0
            if count > 0 {
                return allDatas[row].state
            }
        }
        
        let cities = allDatas[index].cities
        return cities![row].city
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 { // 刷新省
            index = row
            // 刷新二级城市
            pickerView.reloadComponent(1)
            // 滚动到第一个城市
            pickerView.selectRow(0, inComponent: 1, animated: true)
            let area = allDatas[row]
            let areaCity = area.cities![0].city
            locationFiled?.text = area.state! + "," + areaCity!
        }else{
            let area = allDatas[index]
            let areaCities = area.cities![row]
            locationFiled?.text = area.state! + "," + areaCities.city!
        }
        
    }
    
    
    
    //MARK: - 懒加载
    /// 所有数据
    private lazy var allDatas : [Area] = {
        let areas = Area.loadAllArea()
        return areas
    }()
    
    
    /// 联动选择器
    private lazy var statePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
}
