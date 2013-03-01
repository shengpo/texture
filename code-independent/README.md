texture_independent
===================

這是texture獨立運行版本，只提供單螢幕呈現  
另有 [client-server](https://github.com/shengpo/texture/tree/master/code-clientserver) 版本，可應用於多螢幕呈現 (多螢幕排列方式彈性，符合client端畫面擷取規則即可)


--------------------

###執行說明：
- 此為獨立執行版本!
- 開啟程式後，會自動進入動畫模式
- 關於橫線及直線
	- 橫線的參考點(pivot點)預設為最左邊的點 (向右畫線)
	- 直線的參考點(pivot點)預設為最上面的點 (向下畫線)
- 進入設定模式時
	- 被選擇的線為藍色, 沒被選到的為黑線
	- 紅點為線的pivot點 (作為參考點)
	- 淺藍色線為向下(橫線)/向左(直線)的距離參考線
	- 淺紫色線為向上(橫線)/向右(直線)的距離參考線
- 離開設定模式後
	- 按小寫a，從新啟動動畫
	- 所有橫線皆以最左邊的點作為預設參考點(pivot點)儲存至設定檔中 (向右畫線)
	- 所有直線皆以最上面的點作為預設參考點(pivot點)儲存至設定檔中 (向下畫線)
- 目前共有 8種 animation模式, 按0~7數字鍵可以直接跳至該模式
 
 
###設定說明：
- 按小寫a	:	將所有的line都啟動animation mode
- 按小寫c	:	更換animation 
- 按s或S	:	開/關設定模式
- 按小寫v	:	在螢幕中央產生垂直線 (高度等同畫面高度)
- 按小寫h	:	在螢幕中央產生橫線 (長度等同畫面寬度)
- 按大寫V	:	依序選擇要設定的垂直線
- 按大寫H	:	依序選擇要設定的橫線
- 按上下左右鍵	:	移動目前正在設定的線(直線或橫線)
	- 目前皆以最左邊的點or做上面的點作為起始點
- 按 { 或 }	:	減少or增加目前所選定的線距離下面or左邊的線的距離 
- 按 [ 或 ]	:	減少or增加目前所選定的線距離上面or右邊的線的距離 
- 按小寫w	:	減少線的粗細(weight)
- 按大寫W	:	增加線的粗細(weight)
- 按小寫d	:	刪除正在編輯的線


###使用的library
- [SoundCipher library](http://explodingart.com/soundcipher) (version: Beta release 10)


###開發環境：
Processing 2.0b8

--------------------

##TODO
- [x] check code and upgrade code
- [x] add sound

