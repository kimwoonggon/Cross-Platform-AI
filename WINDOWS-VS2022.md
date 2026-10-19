# Windows / Visual Studio 2022 실습 준비

공식 저장소: https://github.com/Pseudo-Lab/Cross-Platform-AI

준비한 위치: `D:\Cross-Platform-AI-VS2022`

기준 커밋: `6811efd9e61a4411d78a1a2c08cef891222b81e4`

기존 `D:\Cross-Platform-AI` 개인 포크의 작업은 수정하지 않았습니다.

## 시작하기

1. 루트의 `open-vs2022.cmd`를 더블클릭합니다. VS 2026 대신 VS 2022로 열립니다.
2. 상단 구성을 **Debug / x64**로 선택합니다.
3. 솔루션 탐색기에서 원하는 장의 `*_example` 프로젝트를 오른쪽 클릭하여 **시작 프로젝트로 설정**합니다. 기본은 08장입니다.
4. 해당 프로젝트의 `main.cpp`에서 `main()` 또는 `ComputeApplication::run()`에 F9로 중단점을 설정합니다.
5. F5로 디버깅을 시작합니다. F10은 다음 줄, F11은 함수 내부 진입, Shift+F5는 종료입니다.
6. **디버그 → 창 → 지역 / 조사식 / 호출 스택**으로 C++ 상태를 확인합니다. 콘솔 출력을 계속 보려면 Ctrl+F5로 실행합니다.

직접 열 솔루션: `build\vs2022-x64\CrossPlatformAI_08_13.sln`

| 장 | 시작 프로젝트 | 소스 폴더 |
|---|---|---|
| 08 | compute_shader_example | examples/08-compute-shader |
| 09 | compute_pipeline_example | examples/09-compute-pipeline |
| 10 | command_buffers_example | examples/10-command-buffers |
| 11 | dispatch_synchronization_example | examples/11-dispatch-synchronization |
| 12 | staging_buffers_example | examples/12-staging-buffers |
| 13 | multiple_dispatches_example | examples/13-multiple-dispatches |

## 실습 코드의 현재 상태

각 장의 원본 `main.cpp`는 이전 장까지 완성된 코드에 현재 장의 TODO가 있는 실습 시작점입니다. 공식 `99-completed`에는 08~13 완성본이 아직 없습니다. 원본 TODO를 그대로 보존했으므로 각 폴더 README를 따라 구현합니다.

- 08은 셰이더 모듈, 09는 파이프라인, 10은 커맨드 버퍼를 추가하는 과제입니다.
- 11의 시작 코드는 커맨드를 기록하지만 GPU 제출·정답 검증은 아직 추가해야 합니다.
- 12의 시작 코드는 앞 장의 A+B를 실행합니다. 스테이징 전송은 TODO입니다.
- 13의 시작 코드는 스테이징을 사용하는 A+B를 실행합니다. 두 번째 디스패치와 A+2B 검증은 TODO입니다.

따라서 실행 성공은 현재 실습 시작점의 실행 확인이며, 각 장의 과제 완성을 뜻하지 않습니다.

F10/F11 디버깅 대상은 CPU의 C++ 코드입니다. GPU의 `add.comp` 내부를 Visual Studio 기본 C++ 디버거로 한 줄씩 실행할 수는 없습니다. GPU 결과는 CPU 읽기와 검증 코드에서 조사합니다.

## 다시 빌드하고 확인하기

PowerShell에서 다음을 실행합니다.

```powershell
cd D:\Cross-Platform-AI-VS2022
.\build-vs2022.ps1
```

스크립트는 VS 2022의 CMake로 솔루션 생성, 여섯 장 Debug 빌드, 실행 검사를 순서대로 수행합니다. 소스와 `add.comp` 변경 후에는 Visual Studio의 빌드로도 반영됩니다. 셰이더는 자동으로 SPIR-V로 컴파일되며 파일 위치는 CMake가 전달합니다.

설정은 MSVC v143 / C++20 / Windows SDK 10.0.26100.0 / Vulkan SDK 1.4.363.0을 사용합니다. `CMakePresets.json`에 이 컴퓨터의 설치 경로가 들어 있습니다. SDK 위치가 변경되면 해당 파일을 수정하고 스크립트를 다시 실행합니다.

Vulkan 검증 레이어 경로는 프로젝트의 디버깅 환경과 실행 검사에 설정되어 있습니다. 검사 로그는 `build/vs2022-x64/Testing/Temporary/LastTest.log`에서 볼 수 있습니다. C++ PDB 디버그 심볼은 각 장의 `Debug` 출력 폴더에 생성됩니다.

08~13은 Vulkan SDK만 필요하므로 이번 빌드에서 사용하지 않는 `external/eva` 서브모듈은 내려받지 않았습니다.

## 이 PC에서의 확인 결과

2026-10-19: 여섯 장 모두 Debug/x64 빌드와 실행 검사 통과. RTX 2070 SUPER에서 12·13장 시작 코드의 두 차례 A+B 결과 검증도 통과했습니다. 실행 검사는 종료 코드와 VUID / SYNC-HAZARD 메시지를 확인합니다.

현재 PC의 Epic Games 오버레이 등록 정보가 존재하지 않는 `EOSOverlayVkLayer-Win32.json` / `EOSOverlayVkLayer-Win64.json`을 참조하여 `Loader Message: loader_get_json: Failed to open JSON file` 오류를 출력합니다. 예제는 정상 종료하며 이 메시지는 실행 검사 실패 조건에 포함하지 않았습니다. 시스템 레지스트리는 변경하지 않았습니다. 따라서 실행 검사 통과가 모든 로더 메시지 부재를 뜻하지는 않습니다.
