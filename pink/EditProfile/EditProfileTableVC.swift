//
//  EditProfileTableVC.swift
//  pink
//
//  Created by gbt on 2022/11/15.
//
/*
    个人页面的‘编辑资料’-编辑页面
 */
import LeanCloud

class EditProfileTableVC: UITableViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var nickNameL: UILabel!
    @IBOutlet weak var genderL: UILabel!
    @IBOutlet weak var birthL: UILabel!
    @IBOutlet weak var introL: UILabel!
    
    var user: LCUser!       //自定义用户属性,用来接收云端的user
    var delegate: EditProfileTableVCDelegate?//自定义-'编辑资料'->个人页面的反向传值协议
    
    var avatar: UIImage?{
        didSet{
            //loadObject(ofClass 是闭包函数,UI需要在主线程执行
            DispatchQueue.main.async {
                self.avatarImgView.image = self.avatar    //传值到‘个人简介’主页
            }
        }
    }
    var nickName = ""{
        didSet{
            nickNameL.text = nickName
        }
    }
    var intro = ""{
        didSet{
            introL.text = intro.isEmpty ? "未填写" : intro
        }
    }

    /*  未添加setUI()前的自定义
     var gender: Bool?{ //gender 初始值可能为空,因此要使用if let gender = gender 判断
         didSet{
             guard let gender = gender else {return}
             genderL.text = gender ? "男" : "女"
         }
     }
     
     var birth: Date?{  //birth 初始值为2020-04-10
         didSet{
             birthL.text = birth!.format(with: "yyyy-MM-dd")
         }
     }
     
     */

    var gender = false{ 
        didSet{
            genderL.text = gender ? "男" : "女"
        }
    }

    var birth: Date?{   //birth 初始值从云端获取,可能为空
        didSet{
            if let birth = birth{
                birthL.text = birth.format(with: "yyyy-MM-dd")
            }else{
                birthL.text = "未填写"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        //用代码创建view,并设textfield的inputView属性,以自定义原本的软键盘view
//        tableView.addSubview(textfield)
//        textfield.inputView = genderPickerView  //显示genderPickerView
        
    }

    // MARK: 返回后,‘编辑资料’数值传到个人页面
    @IBAction func back(_ sender: Any) {
        //可用5个flag变量判断用户是否修改过,若其中一个改过才调用updateUser--此处省略
        //若传的值比较多,可考虑传一个自定义的对象,然后在MeVC那里从这个对象的属性里获取这些值
        delegate?.updateUser(avatar, nickName, gender, birth, intro)
        dismiss(animated: true)
    }
    
    //注释掉的代码为:用代码创建view,并设textfield的inputView属性,以自定义原本的软键盘view
//    lazy var textfield: UITextField = {
//        let textfield = UITextField(frame: .zero)
//        return textfield
//    }()
//
//    lazy var genderPickerView: UIStackView = {
//        let cancelBtn = UIButton()
//        setToolbarItems(cancelBtn, title: "取消", color: .secondaryLabel)
//        let doneBtn = UIButton()
//        setToolbarItems(doneBtn, title: "完成", color: mainColor)
//
//        //水平stackView: cancelBtn + doneBtn
//        let toolBarView = UIStackView(arrangedSubviews: [cancelBtn, doneBtn])
//        toolBarView.distribution = .equalSpacing
//
//        let pickerView = UIPickerView()
//        pickerView.dataSource = self
//        pickerView.delegate = self
//
//        //垂直stackView: toolBarView + pickerView
//        let genderPickerView = UIStackView(arrangedSubviews: [toolBarView, pickerView])
//        genderPickerView.frame.size.height = 150
//        genderPickerView.axis = .vertical
//        genderPickerView.spacing = 8
//        genderPickerView.backgroundColor = .secondarySystemBackground
//
//        return genderPickerView
//    }()
//
//    //自定义工具栏button
//    private func setToolbarItems(_ btn: UIButton, title: String, color: UIColor) {
//        btn.setTitle(title, for: .normal)
//        btn.titleLabel?.font = .systemFont(ofSize: 14)
//        btn.setTitleColor(color, for: .normal)
//        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
//    }

}

//// MARK: 遵守UIPickerViewDataSource、UIPickerViewDelegate
//extension EditProfileTableVC: UIPickerViewDataSource, UIPickerViewDelegate{
//    //显示几列
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//    //每列显示几行
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        2
//    }
//    //每行显示什么内容
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        ["男","女"][row]
//    }
//}
