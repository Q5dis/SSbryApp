# 쓰버리 (SSbry) - AI 기반 스마트 분리배출 가이드

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**분리배출에서 재생에너지까지, 에너지 순환의 여정**

[앱 다운로드](#-다운로드) • [AI 모델](https://github.com/Q5dis/SSbry.git) • [문서](#-주요-기능)

</div>

---

## 프로젝트 소개

### "왜 분리배출을 해야 하는가?"

일상적인 쓰레기 분류를 넘어, **개인의 작은 실천이 어떻게 재생에너지 생산으로 이어지고, 탄소중립 사회를 만드는지** 정량적 데이터로 연결하는 프로젝트입니다.

단순히 쓰레기를 분류하는 것이 아니라, 분리배출된 쓰레기가 **재생에너지원으로 직간접적으로 사용**된다는 것을 알리고, 올바른 분리배출 습관을 유도합니다.

### 프로젝트 목표

**기술 적용**
- 머신러닝 + 객체 이미지 처리 기술의 실생활 적용
- YOLOv8n 기반 커스텀 모델 개발

**문제 해결**
- 올바른 분리배출률 향상 목표
- 분리배출 방법에 대한 정보 접근성 개선

**사회적 가치**
- **에너지 자원화의 출발점**: 단순한 환경 보호를 넘어 에너지 순환 개념 전파
- **신재생에너지 인식 개선**: 쓰레기 → 자원 → 에너지 순환 체계 시각화
- **지속 가능한 에너지 사회 기여**: 재활용 과정에서 신재생에너지 생산 가능성 제시

---

## 주요 기능

### AI 기반 쓰레기 분류
- **갤러리 사진 업로드** 자동 인식 (YOLOv11)
- **6개 카테고리** 정확한 분류
  - 플라스틱, 종이, 유리, 캔류, 비닐류, 일반쓰레기
- 올바른 배출 방법 **즉시 안내**
- 오분류 방지 및 주의사항 알림
- 에너지 정보 제시

### 에너지 절약 효과 시각화
- **경제적 절약액** 계산
- **신재생 에너지 생산량** 환산 (kWh)
- CO₂ 감축량 → **소나무 그루 수** 변환

### 에너지 연못: 게임화된 참여
- 분리배출 → **연못 생태계 청결 정도** 시각화
- **랜덤 에너지 지식** 

### 쓰레기 백과사전 & 지식 아카이브
- 카테고리별 **상세 분리배출 가이드**
- **재생에너지 전환 과정**
- 자주 묻는 질문(FAQ) 
- 환경부·지자체 **분리배출 정보**

---

## 스크린샷

<div align="center">

| 홈 화면 | AI 분류 | 쓰레기 백과사전 | 연못 |
|:---:|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![AI](screenshots/ai.png) | ![Article](screenshots/stats.png) | ![Pond](screenshots/pond.png) |

</div>

---

## 기술 스택

### Frontend & Mobile
- **Flutter** - 안드로이드 스튜디오

### AI
- **YOLOv8n** - 객체 탐지 모델
- **Custom Dataset** - TrashNet 기반 학습

### Data & Design
- **Figma** - UI/UX 디자인
- **환경부·한국에너지공단 등 공식 데이터** - 신뢰성 있는 정보 제공

---

## AI 모델 상세

### 컴퓨터 비전 & 머신러닝

**YOLOv8n 모델 커스터마이징**
- 재활용 쓰레기 6개 카테고리 다중 객체 인식
- TrashNet 기반 자체 데이터셋 구축 및 학습

**데이터 증강 기법**
학습 시 적용된 증강 기법
- 다양한 조명 환경 시뮬레이션
- 가우시안 노이즈 추가
- 다양한 각도 회전 
- 좌우 반전, 스케일 변화

**Custom Training Pipeline**
- 데이터 전처리 자동화
- 80:20 Train/Validation 분할
- 30 에포크 학습
- 실시간 성능 모니터링

### 데이터 기반 의사결정

**신뢰할 수 있는 데이터 소스**
- 환경부 재활용품 분리배출 가이드라인
- 한국에너지공단 신재생에너지 통계
- IRENA (국제재생에너지기구)
- 공공기관 데이터 크로스 검증

**제공 정보**
- 쓰레기별 재생에너지 전환율
- 분리배출 vs 혼합배출 효율 차이 (최대 100%p)
- 개인/가정/국가 단위 환경·경제 효과

### 사용자 중심 UX 설계

**3초 내 이해 가능한 정보**
- 140자 이내 핵심 정보 전달
- 직관적인 아이콘과 색상 체계
- 종류별 가이드 제공

**장기적 임팩트 시각화**
- 연못 가꾸기와 같은 게임화 요소로 지속적 사용 유도

---

## 다운로드

### Android APK
**[Google Drive에서 다운로드](https://drive.google.com/drive/folders/13n6XdaZlxzuWlXpKfPHqG-SxXi9Pc5KS?usp=sharing)**

### QR
![QR](<img width="357" height="357" alt="1Td4i" src="https://github.com/user-attachments/assets/5b80b801-61ee-4256-bece-e465c2ea6f21" />)

### 설치 방법
1. 위 링크 혹은 qr코드를 접속해서 APK 파일 다운로드
2. APK 파일 실행하여 설치

---

## 관련 링크

- **AI 모델 저장소**: [SSbry Model Repository](https://github.com/Q5dis/SSbry.git)
- **프로젝트 발표 자료**: [링크 추가 예정]

---

## 앱 개발 중 주요 이슈 및 해결 

### 1. 카메라 촬영 불가능 문제

**문제점**
- Flutter Web에서 카메라 지원이 불안정
- 사용 중인 ONNX 모델이 Web을 지원하지 않음

**해결 방법**
```
Ｘ Web 배포 포기
√ 네이티브 앱 개발에 집중
√ 갤러리 업로드 방식으로 변경
→ 성공적으로 배포 완료
```

**결과**: 더 안정적인 성능과 사용자 경험 확보

<br/>

### 2. ONNX 모델 연동 문제

**문제점**
```
앱 실행 시마다 모델이 제대로 연동되지 않는 오류 발생
```

**원인 분석**
```python
# Python에서 모델 export 시
opset_version = 18  # 기본값

# Flutter ONNX Runtime
max_opset_version = 17  # 최대 지원
```

**해결 방법**
```python
# 모델 재export
torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    opset_version=17  # √ 17로 변경
)
```

**결과**: 모델이 정상적으로 연동되어 안정적인 추론 가능

<br/>

### 3. image_gallery_saver 패키지 충돌

**문제점**
```gradle
// Gradle 버전 충돌 발생
FAILURE: Build failed with an exception.
* What went wrong:
Could not determine the dependencies of task ':app:compileDebugJavaWithJavac'.
```

**시도한 해결 방법**
```
Ｘ 다양한 버전 시도 (1.x ~ 2.x)
Ｘ Gradle 버전 업데이트
Ｘ 의존성 순서 변경
```

**최종 해결**
```yaml
# pubspec.yaml
dependencies:
  # image_gallery_saver: ^2.0.3  # Ｘ 제거
  gal: ^2.1.4  # √ 최신 패키지로 변경
```

**결과**: 
- 더 최신이고 안정적인 `gal` 패키지 사용
- Android 13+ 권한 처리 개선
- 정상 작동 확인

---

## 프로젝트 성과

### 기술적 성과
- √ AI 객체 인식 높은 정확도
- √ 다중 객체 동시 인식
- √ 6개 카테고리 분류 성공

### 사회적 임팩트 (1,000명 사용 시 예상)
- **505,000kWh** 에너지 생산 기여
- **233톤 CO₂** 감축 (소나무 3.5만 그루 효과)
- **7,575만원** 경제적 효과

---

## 팀 구성

<div align="center">

| **오왕경** | **윤태훈** | **최하연** |
| --- | --- | --- |
| <div align="center">- 앱 개발 및 디자인<br/>- UIUX<br/>- 모델 연동</div> | <div align="center">- 데이터 수집/전처리<br/>- YOLO 모델 훈련<br/>- AI 모델 개발<br/>- 성능 최적화</div> | <div align="center">- 일정 관리<br/>- 자료 수집/검증<br/>- AI 부분 서포트<br/>- 발표 자료 작성</div> |
| <div align="center"><a href=""><img src="https://img.shields.io/badge/github-181717?style=flat-square&logo=github&logoColor=white"/></a><br/><a href=""><img src="https://img.shields.io/badge/velog-20C997?style=flat-square&logo=velog&logoColor=white"/></a></div> | <div align="center"><a href="https://github.com/taehun96"><img src="https://img.shields.io/badge/github-181717?style=flat-square&logo=github&logoColor=white"/></a><br/><a href="https://velog.io/@taehun96/posts"><img src="https://img.shields.io/badge/velog-20C997?style=flat-square&logo=velog&logoColor=white"/></a></div> | <div align="center"><a href=""><img src="https://img.shields.io/badge/github-181717?style=flat-square&logo=github&logoColor=white"/></a><br/><a href=""><img src="https://img.shields.io/badge/velog-20C997?style=flat-square&logo=velog&logoColor=white"/></a></div> |

</div>

---

## 참고 자료

### 정부 및 공공기관
- 환경부 재활용품 분리배출 가이드라인
- 한국환경공단, 한국에너지공단
- 서울시 및 각 지자체 공식 안내
- 등등

### 국제기구
- IRENA (국제재생에너지기구)
- IEA (국제에너지기구)
- IPCC, 그린피스
- 등등

### 데이터셋
- TrashNet Dataset (Kaggle)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 기여하기

프로젝트에 기여하고 싶으신가요?

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 문의

프로젝트에 대한 문의사항이 있으시면 Issues를 통해 연락 주세요.


