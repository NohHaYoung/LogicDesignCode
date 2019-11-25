# Lab 10

## 실습 내용

### **적외선 컨트롤러(IR Controller)**
#### **Submodule 1 - ir_rx** : 4가지 state(IDLE - ref. , LEADCODE - , DATACODE, COMPLEMENT)정의

#### **Submodule 2 - fnd_dec** : 0~15에 해당하는 segment 출력값 정의

#### **Submodule 3 - led_disp** : DATA 조합

#### **Top Module** :  IR Controller로 부터 DATA를 받아 7-segment에 해당하는 DATA를 출력


## 결과

### **Top Module 의 DUT/TestBench Code 및 Waveform 검증**
![wave form](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/waveform.PNG?raw=true)


### **FPGA 동작 사진**
`POWER Button data : FD00FF`
![PowerButton Data : FD00FF](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%281%29.jpg?raw=true)

`#3 data : FD48B7`
![#3 data : FD48B7](https://github.com/NohHaYoung/LogicDesignCode/blob/master/practice9/figs/FPGA%282%29.jpg?raw=true)

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTMyNjI2NjM4MCwxMzUxNjY2NzUyXX0=
-->