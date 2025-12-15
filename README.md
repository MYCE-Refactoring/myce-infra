### 아키텍처 구조도
<img width="1080" height="608" alt="Image" src="https://github.com/user-attachments/assets/f5cb81f6-fa61-4363-add4-2c9e30743235" />

## IaC(Infrastructure as Code)
물리적 환경을 수동으로 사용하는 대신 코드를 사용하여 인프라를 프로비저닝하고 관리하는 프로세스

> 프로비저닝?
> 어떤 서비스를 제공하기까지 준비한 과정

### Terraform
하시코프에서 만든 IaC Tool로, 사람이 읽을 수 있는 구성 파일을 작성하여 클라우드 인프라 구성 요소를 프로비저닝, 업데이트 및 삭제 할 수 있도록 합니다.  
myce-infra에서는 AWS 기반 프로비저닝을 실행합니다.
  
**사전 작업(bootstrap)**
- keypair 생성 및 파일 다운로드
- tfstate 기록 및 Config 저장용 S3 생성

**인프라 프로비저닝(main)** 
- 네트워크 구성
  - VPC 및 Public/Private Subnet 정의
  - Internet Gateway 구축
  - Route Table 생성, Subnet 연결 및 IGW 라우팅 규칙 정의
- 보안 구성
  - 서비스별 Security Group 정책 정의
  - SSH / HTTP / DB 인바운드 규칙 설정
- 컴퓨팅 리소스 구성
  - 서비스별 EC2 인스턴스 구축
  - 보안 구성 연결
  - 서비스 : public / private / bastion / nat
- 데이터베이스 구성
  - MySQL RDS 프로비저닝
  - 사용자 정보 및 데이터베이스 설정
- 생성 EC2 IP 파일 업로드
  - 사전작업 시 생성한 S3 사용

### Ansible
기존의 동일 작업 처리 시 쉘 스크립트를 실행시켜 직접 배포 작업을 수행했으나, 사용자 트래픽이 늘어나고 관리해야할 서버가 많아지면서 동시에 자동화할 필요가 생겼습니다. 이런 문제 해결을 위해 Ansible 배포 도구 구축을 진행했습니다.

**인프라 프로비저닝(env)**
- Nat Instance 구성
  - IP Forwarding 설정
  - nftables 기반 NAT 규칙 설정
- Nat Instance에 NginX 설치 및 설정파일 추가
- Docker 및 Docker Compose 설치

**배포 작업(deploy)**
- 백엔드 프로세스 배포
  - .env 설정 및 Docker Image 다운로드
  - Docker Compose 실행
->  Backend Actions 수행 후 트리거 발생 시 수행
