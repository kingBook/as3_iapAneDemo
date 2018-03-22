::需要先将FLEX_SDK路径D:\flex_sdk_4.6\bin添加到Path系统环境变量,或设置FLEX_SDK_HOME路径，才可以运行

::方法一
adt -package -target ane flashane.ane extension.xml -swc aneswc.swc -platform iPhone-ARM library.swf ioslib.a -platformoptions platformoptions.xml

::方法二
::set FLEX_SDK_HOME=D:\flex_sdk_4.6\bin
::"%FLEX_SDK_HOME%\adt" -package -target ane flashane.ane extension.xml -swc aneswc.swc -platform iPhone-ARM library.swf ioslib.a -platformoptions platformoptions.xml
