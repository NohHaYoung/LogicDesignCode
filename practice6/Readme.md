# Lab 10

## 실습 내용

### **적외선 컨트롤러(IR Controller) 동작 원리** 
#### 송신부(적외선 발광 다이오드), 수신부(포토다이오드)로 구성. 송신부(적외선 발광다이오드)에서 적외선을 발생시키고, 수신부에서 적외선을 받아 전기에너지로 바꾸어 전류를 생성함.

#### NEC 적외선 통신규약 : LeaderCode(프레임의 모드 선택), CostomCode(특정 회사 코드), DataCode(송신데이터)

## 각 모듈 설명
#### **Submodule 1 - ir_rx**
#### IDLE - Reference State
#### LEADCODE - Custom & Data Code : 
#### DATACODE - 32bit DATA
#### COMPLETE

#### **Submodule 2 - fnd_dec** : 0~15에 해당하는 segment 출력값 정의

#### **Submodule 3 - led_disp** : 7-segment display

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
eyJoaXN0b3J5IjpbLTkwMjE3MTk4OSw0MzU1NzczNTYsMTM1MT
Y2Njc1Ml19
-->