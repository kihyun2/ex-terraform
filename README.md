## 인프라 Terraform 구성 (간단 안내)

이 저장소는 VPC, 보안그룹, EC2 인스턴스 모듈을 포함한 간단한 AWS 인프라를 Terraform으로 정의한 예시입니다.

### 폴더 구조

- `main.tf`, `variables.tf`, `outputs.tf` - 루트 모듈(모듈 호출 및 프로바이더 설정)
- `vpc/` - VPC와 서브넷, 라우트, 인터넷 게이트웨이 리소스
- `security/` - 보안 그룹(또는 보안 그룹 규칙)을 정의하는 모듈
- `ec2/` - 프론트엔드(FE)와 백엔드(BE) EC2 인스턴스 리소스

### 요구사항

- Terraform 1.0+ 권장
- AWS provider (root `main.tf`에서 required_providers에 정의됨)
- AWS CLI 자격증명(또는 환경 변수) 구성 필요

### 빠른 시작

1. 작업 디렉터리로 이동

```cmd
cd {path}/ex-terraform
```

2. 초기화 및 계획 확인

```cmd
terraform init
terraform plan
```

3. 적용

```cmd
terraform apply
```

### 주요 입력(루트/모듈에 전달되는 변수)

- `key_name` - EC2 키페어 이름
- 모듈별로 `vpc_id`, `public_subnet_id`, `private_subnet_id`, 보안그룹 ID 등 출력값을 전달합니다.

### 출력값

- 루트의 `outputs.tf`에서 FE public IP, BE private IP, VPC ID 등을 출력합니다.

### 자주 발생하는 오류와 해결 방법

- Error: Unsupported argument (예: `public_subnet_cidr`, `vpc_id`)

  - 원인: 루트에서 모듈로 전달한 인자명이 해당 모듈의 `variables.tf`에 정의되어 있지 않거나, 모듈 블록이 올바르게 선언되지 않았을 때 발생합니다.
  - 해결: 모듈 디렉터리(`vpc/`, `security/`, `ec2/`)의 `variables.tf`에 해당 변수가 정의되어 있는지 확인하세요.

- Error: Reference to undeclared module (예: `module.ec2` not declared)

  - 원인: 루트 `main.tf`에서 해당 모듈을 호출하지 않았거나, 모듈 블록이 삭제/주석 처리된 경우입니다.
  - 해결: `main.tf`에 `module "ec2" { source = "./ec2" ... }` 같은 블록이 있는지 확인하세요.

- 보안 그룹 관련: inline ingress에서 `security_groups`를 사용하면 에러가 나거나 기대한 대로 동작하지 않을 수 있습니다.
  - 설명: VPC 환경에서는 다른 보안그룹을 소스로 지정할 때 `aws_security_group_rule` 리소스와 `source_security_group_id`를 사용하는 것이 권장됩니다. `security_groups` 인수는 일부 환경/프로바이더 버전에서 지원되지 않거나 EC2-Classic용일 수 있습니다.
  - 해결 예시: `aws_security_group_rule`를 사용해 아래처럼 작성합니다.

```hcl
resource "aws_security_group_rule" "fe_to_be" {
	type                     = "ingress"
	from_port                = 8080
	to_port                  = 8080
	protocol                 = "tcp"
	security_group_id        = aws_security_group.be_sg.id
	source_security_group_id = aws_security_group.fe_sg.id
}
```

- 캐시/모듈 문제
  - 때때로 `.terraform` 폴더의 캐시 때문에 모듈 변경이 반영되지 않습니다. 그런 경우 `.terraform` 폴더를 삭제하고 `terraform init`을 다시 실행하세요.

```cmd
rmdir /s /q .terraform
terraform init
```

### 권장 개선사항

- 보안 그룹 규칙은 명시적으로 `aws_security_group_rule`로 분리
- 모듈의 `variables.tf`와 `outputs.tf`를 명확히 문서화
- Terraform 버전과 AWS provider 버전 고정

---

간단한 노트: EC2 AMI 교체가 필요한 경우 `ec2/*` 내부의 AMI ID를 업데이트하세요.
