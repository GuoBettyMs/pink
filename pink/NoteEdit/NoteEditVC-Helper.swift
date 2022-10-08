//
//  NoteEditVC-Helper.swift
//  pink
//
//  Created by isdt on 2022/9/28.
//
/*
    辅助函数
    发布笔记编辑页面的( 故事版事件 - 存草稿到本地 && 故事版事件 -  发布笔记) 执行事件之前对文本字数的判断
    发布笔记编辑页面的 故事版事件 - 限制标题字符并实时显示剩余可输字符
 */

extension NoteEditVC{
    
    // MARK: 故事版事件 - 判断图片、字数是否符合要求
    func isValidateNote() -> Bool{
        
        guard !photos.isEmpty else {
            showTextHUD("至少需要传一张图片哦")
            return false
        }
        
        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else {
            showTextHUD("正文最多输入\(kMaxNoteTextCount)字哦")
            return false
        }
        return true
    }

    // MARK: 故事版事件 - 判断是否符合图片、字符限制要求
    func handleTFEditChanged(){
    
        //当前有高亮文本时(拼音键盘)return,防止拼音尚未输完整,却因超字数而无法编辑
        guard titleTextField.markedTextRange == nil else { return }

        //用户输入完字符后进行判断,若大于最大字符数,则截取前面的文本(if里面第一行)
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount{

            // prefix截取前 kMaxNoteTitleCount 位字符
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))

            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字哦")

            //用户粘贴文本后的光标位置,默认会跑到粘贴文本的前面,此处改成末尾
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        
        //实时显示剩余可输字符
        titleCountL.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
        
    }
}