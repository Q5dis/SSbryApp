class WasteInfo {
  final String koreanName;
  final String category;
  final String disposalMethod;
  final String energyInfo;
  final String caution;
  final int colorCode;

  const WasteInfo({
    required this.koreanName,
    required this.category,
    required this.disposalMethod,
    required this.energyInfo,
    this.caution = '',
    required this.colorCode,
  });
}

const Map<String, WasteInfo> wasteDatabase = {
  'plastic': WasteInfo(
    koreanName: '플라스틱',
    category: 'plastic',
    disposalMethod: '내용물 제거 후 물로 헹구고 라벨·뚜껑 분리. 페트병은 찌그러트려 배출. 투명·유색 구분 필수.',
    energyInfo: '열분해로 합성원유 생산! 1kg→0.8L 연료. 태양광 패널 백시트 소재로도 활용. 분리배출 시 CO₂ 2.1톤 감축.',
    colorCode: 0xFF4CAF50, // 녹색
  ),

  'glass': WasteInfo(
    koreanName: '유리',
    category: 'glass',
    disposalMethod: '내용물 제거·세척 후 라벨 떼고 뚜껑 분리. 색깔별 구분 배출.',
    energyInfo: '태양광 패널 표면 유리로 재탄생! 1톤 재생 시 제조에너지 32% 절약(1,200kWh). 무한 재활용 가능.',
    caution: '거울, 깨진유리, 도자기, 유리식기, 전구, 형광등, 창문유리, 내열유리는 종량제 봉투에! 부피가 클 경우는 불연성 마대에!',
    colorCode: 0xFF2196F3, // 파란색
  ),

  'can': WasteInfo(
    koreanName: '캔/금속류',
    category: 'can',
    disposalMethod: '내용물 완전 제거 후 물로 깨끗이 헹구고 라벨 제거. 스프레이는 완전히 사용 후 배출.',
    energyInfo: '풍력터빈 타워·발전기 부품 소재! 재생 철강은 에너지 74% 절약, 알루미늄은 95% 절약. 1톤→14,000kWh 절약.',
    colorCode: 0xFFFFC107, // 노란색
  ),

  'trash': WasteInfo(
    koreanName: '일반쓰레기',
    category: 'trash',
    disposalMethod: '재활용 불가능한 쓰레기는 종량제봉투에 배출.',
    energyInfo: '소각 시 열에너지 회수로 발전·난방 활용! 1톤→500~700kWh 전력 생산. 매립보다 온실가스 60% 감축.',
    caution: '달걀껍질·뼈·음식물 묻은 종이·깨진유리 등.',
    colorCode: 0xFF9E9E9E, // 회색
  ),

  'paper': WasteInfo(
    koreanName: '종이류',
    category: 'paper',
    disposalMethod: '이물질 제거·건조 후 배출. 테이프·스테이플러 제거 필수. 종이팩은 별도 분리! 코팅지는 배출 불가.',
    energyInfo: '바이오매스 펠릿·바이오에탄올 생산! 1톤→3,500kWh 열에너지(가정 3개월 전력). 신규 펄프 대비 84% 에너지 절약.',
    colorCode: 0xFF795548, // 갈색
  ),

  'vinyl': WasteInfo(
    koreanName: '비닐류',
    category: 'vinyl',
    disposalMethod: '내용물 제거 후 물로 헹궈 건조. 이물질 완전 제거. 음식물 묻은 비닐은 종량제봉투 배출.',
    energyInfo: '열분해로 합성연료 생산 또는 고형연료(SRF) 제조! 1kg→0.7L 연료. 재활용 시 석유 70% 절약·CO₂ 감축.',
    colorCode: 0xFFE91E63, // 핑크색
  ),
};