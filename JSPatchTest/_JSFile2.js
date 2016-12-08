require('SecondViewController')
defineClass('JSPatchController', {
            viewDidLoad: function() {
//            self.ORIGviewDidLoad()
            self.setTitle("测试JS1")
            },
            pushJSViewController: function(sender) {
            var storyboard = require('UIStoryboard').storyboardWithName_bundle("Main", null)
            var secondVC = storyboard.instantiateViewControllerWithIdentifier("SecondViewController")
            self.navigationController().pushViewController_animated(secondVC, YES)
            }
            }
)

defineClass('SecondViewController', {
            viewDidLoad: function() {
            self.ORIGviewDidLoad()
            var label = self.myLabel()
            label.setText("这是在JS2中修改的文字")
            self.setTitle("JS2推出的页面")
            }
            })
