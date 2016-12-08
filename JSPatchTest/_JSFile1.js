/*
 defineClass(classDeclaration, [properties,] instanceMethods, classMethods)
 
 @param classDeclaration: 字符串，类名/父类名和Protocol
 @param properties: 新增property，字符串数组，可省略
 @param instanceMethods: 要添加或覆盖的实例方法
 @param classMethods: 要添加或覆盖的类方法
*/

require('SecondViewController')
defineClass('JSPatchController', [/*新增的属性*/'updateLabel', 'updateBtn'], {//实例方法
            
            viewDidLoad: function() {
//            self.ORIGviewDidLoad()
            self.setTitle("测试JS1")
            self.view().addSubview(self.getUpdateLabel())
//            self.view().addSubview(self.getUpdateBtn())
            },
            
            //实现Label的getter方法
            getUpdateLabel: function() {
            var _updateLabel = self.updateLabel()
            if (!_updateLabel) {
                _updateLabel = require('UILabel').alloc().init()
                _updateLabel.setFrame({x:50, y:100, width:100, height:30})
                _updateLabel.setText("点击按钮更新JS代码--->")
                _updateLabel.setFont(require('UIFont').systemFontOfSize(15))
                _updateLabel.setTextColor(require('UIColor').redColor())
                _updateLabel.sizeToFit()
                self.setUpdateLabel(_updateLabel)
            }
            return _updateLabel
            },
            
            getUpdateBtn: function() {
            var _updateBtn = self.updateBtn()
            if (!_updateBtn) {
                _updateBtn = require('UIButton').buttonWithType(1)
                _updateBtn.setTitle_forState("更新JS", 0)
                _updateBtn.setFrame({x:0, y:0, width:100, height:30})
                _updateBtn.setBackgroundColor(require('UIColor').grayColor())
                _updateBtn.setTintColor(require('UIColor').whiteColor())
                _updateBtn.setCenter({x:300 ,y:110 })
            }
            return _updateBtn
            },

            pushJSViewController: function(sender) {
            var storyboard = require('UIStoryboard').storyboardWithName_bundle("Main", null)
            var secondVC = storyboard.instantiateViewControllerWithIdentifier("SecondViewController")
            self.navigationController().pushViewController_animated(secondVC, YES)
            }
            }, {//类方法

            })

defineClass('SecondViewController', {
            viewDidLoad: function() {
            self.ORIGviewDidLoad()
            var label = self.myLabel()
            label.setText("这是在JS1中修改的文字")
            self.setTitle("JS1推出的页面")
            }
            })
