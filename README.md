# 카카오내비 for React Native

![platforms](https://img.shields.io/badge/platforms-Android%20%7C%20iOS-brightgreen.svg?style=flat-square&colorB=191A17)
[![npm](https://img.shields.io/npm/v/react-native-kakaonavi.svg?style=flat-square)](https://www.npmjs.com/package/react-native-kakaonavi)
[![npm](https://img.shields.io/npm/dm/react-native-kakaonavi.svg?style=flat-square&colorB=007ec6)](https://www.npmjs.com/package/react-native-kakaonavi)

[![github issues](https://img.shields.io/github/issues/trabricks/react-native-kakao-navi.svg?style=flat-square)](https://github.com/trabricks/react-native-kakao-navi/issues)
[![github closed issues](https://img.shields.io/github/issues-closed/trabricks/react-native-kakao-navi.svg?style=flat-square&colorB=44cc11)](https://github.com/trabricks/react-native-kakao-navi/issues?q=is%3Aissue+is%3Aclosed)
[![Issue Stats](https://img.shields.io/issuestats/i/github/actbase/react-kakaosdk.svg?style=flat-square&colorB=44cc11)](https://github.com/actbase/react-kakaosdk/issues)

## Guide Index

- [`목적지 공유하기`](#목적지-공유)
- [`목적지 길안내`](#목적지-길안내)

## 기본설정

기본설정 부분은 [KakaoSDK 시작하기(React-Native)](https://github.com/actbase/react-kakaosdk)를 참고해서 설정하시면 됩니다.

[react-native-kakao-navi](https://github.com/Kwon-Bum-Kyu/react-native-kakaonavi) 해당 모듈을 개량하여 최신버전에 맞게 만들었습니다.

궁금한 사항이 있는경우 카카오톡 오픈채팅 React & React-Native에서 물어보면 많은 분들이 답변해주십니다.



## Getting started

### Mostly automatic installation (RN >= 0.61)

```
$ npx @actbase/react-kakaosdk
$ npm install react-native-kakaonavi
$ cd ios && pod install && cd ..
```

### iOS

iOS에서는 Location에 대한 권한 동의 plist를 작성해주셔야 합니다. 

### [`카카오 권한설정`](https://developers.kakao.com/docs/latest/ko/getting-started/sdk-ios)

### [`카카오 내비 권한설정`](https://developers.kakao.com/docs/latest/ko/kakaonavi/ios)

## `카카오내비`

### `Location`

카카오내비 API에서 지도상의 특정 위치를 정의하는 class. 목적지 또는 경유지로 사용됩니다. 좌표계는 [`CoordType.KATEC`](#CoordType), [`CoordType.WGS84`](#CoordType)가 사용되며 기본 값은 [`CoordType.KATEC`](#CoordType)입니다. [`CoordType.WGS84`](#CoordType) 좌표계를 사용하려면 [RpOptions](#RpOptions)객체를 활용하여 coordType을 [`CoordType.WGS84`](#CoordType)로 지정해야 합니다.

| Name | Type   | Description         | Default | Usage       |
| ---- | ------ | ------------------- | ------- | ----------- |
| name | string | 장소 이름 (필수)    |         | 공유/길안내 |
| x    | number | 장소 x (경도, 필수) |         | 공유/길안내 |
| y    | number | 장소 y (위도, 필수) |         | 공유/길안내 |

```typescript
const destination: ARNKakaoNaviLocation = {
  name: "카카오판교오피스",
  x: "321286",
  y: "533707"
};
```

### `Options`

카카오내비 API의 선택 파라미터들을 정의하는 Object. 이 클래스가 포함하는 모든 파라미터들은 선택적입니다. 목적지 공유에는 coordType만 쓰이고 나머지 파라미터들은 목적지 길안내에 쓰입니다.

| Name        | Type                          | Description                                          | Default             | Usage       |
| ----------- | ----------------------------- | ---------------------------------------------------- | ------------------- | ----------- |
| coordType   | [`CoordType`](#CoordType)     | 좌표 타입                                            | `CoordType.KATEC`   | 공유/길안내 |
| vehicleType | [`VehicleType`](#VehicleType) | 차종                                                 | `VehicleType.First` | 길안내      |
| rpoption    | [`RpOption`](#RpOption)       | 경로 옵션                                            | `RpOption.Fast`     | 길안내      |
| routeInfo   | boolean                       | 전체경로보기 여부                                    | false               | 길안내      |
| startX      | number                        | 시작좌표 X                                           |                     | 길안내      |
| startY      | number                        | 시작좌표 Y                                           |                     | 길안내      |
| startAngle  | number                        | 시작 앵글 (0~359).                                   | -1                  | 길안내      |
| userId      | string                        | 길안내 유저 구분을 위한 USER ID (현재 택시에서 사용) |                     | 길안내      |
| returnUri   | string                        | 길안내 종료(전체 경로보기시 종료) 후 호출 될 URI     |                     | 길안내      |

```typescript
const options: ARNKakaoNaviOptions = {
  coordType: CoordType.WGS84,
  vehicleType: VehicleType.Second,
  rpoption: RpOption.HighWay,
  routeInfo: false,
  startX: "321286",
  startY: "533707",
  startAngle: 0,
  userId: "asdf",
  returnUri: "localhost"
};
```

### `ViaList`

| Type                        | Description            | Default | Usage       |
| --------------------------- | ---------------------- | ------- | ----------- |
| [`Location`](#Location)\[\] | 경유지 설정 (최대 3개) | []      | 공유/길안내 |

```typescript
const viaList: ARNKakaoNaviViaList = [
  {
    name: "카카오판교오피스",
    x: "321286",
    y: "533707"
  },
  {
    name: "카카오판교오피스",
    x: "321286",
    y: "533707"
  },
  {
    name: "카카오판교오피스",
    x: "321286",
    y: "533707"
  }
];
```

### `CoordType`

| Name  | Value | Description                     |
| ----- | ----- | ------------------------------- |
| KATEC | 1     | Katec 좌표계                    |
| WGS84 | 2     | World Geodetic System 84 좌표계 |

### `VehicleType`

| Name     | Value | Description                        |
| -------- | ----- | ---------------------------------- |
| First    | 1     | 1종 (승용차/소형승합차/소형화물화) |
| Second   | 2     | 2종 (중형승합차/중형화물차)        |
| Third    | 3     | 3종 (대형승합차/2축 대형화물차)    |
| Fourth   | 4     | 4종 (3축 대형화물차)               |
| Fifth    | 5     | 5종 (4축이상 특수화물차)           |
| Sixth    | 6     | 6종 (경차)                         |
| TwoWheel | 7     | 이륜차                             |

### `RpOption`

| Name     | Value | Description    |
| -------- | ----- | -------------- |
| Fast     | 1     | 빠른길         |
| Free     | 2     | 무료도로       |
| Shortest | 3     | 최단거리       |
| NoAuto   | 4     | 자동차전용제외 |
| Wide     | 5     | 큰길우선       |
| HighWay  | 6     | 고속도로우선   |
| Normal   | 7     | 일반도로우선   |

### `기본 세팅`
```typescript
import KaKaoNavi from "react-native-kakaonavi";
import KakaoSDK from "@actbase/react-kakaosdk";

export const App = () => {
  useEffect(() => {
    inits();
  }, [])
  const inits = async () => {
    await KakaoSDK.init("KaKao_App_Key");
  }
}
```

### `목적지 공유`

```typescript
KaKaoNavi
  .share(destination, options, viaList)
  .then(res => console.log(res))
  .catch(e => console.log(e));
```

#### `목적지 길안내`

```typescript
KaKaoNavi
  .navigate(destination, options, viaList)
  .then(res => console.log(res))
  .catch(e => console.log(e));
```
