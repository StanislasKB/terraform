# Terraform EC2 - Modular Structure

## Project Structure

```
terraform/
├── modules/
│   ├── ec2/
│   │   ├── main.tf             # AWS resources (aws_instance, aws_eip)
│   │   ├── variables.tf        # All module variables
│   │   └── outputs.tf          # Exported values
│   │
│   ├── networking/
│   │   ├── main.tf             # VPC, Subnet, IGW, Route Table, Security Group
│   │   ├── variables.tf        # All module variables
│   │   └── outputs.tf          # vpc_id, subnet_id, security_group_id
│   │
│   └── ssh_key/
│       ├── main.tf             # Register public key in AWS (aws_key_pair)
│       ├── variables.tf        # key_name, public_key
│       └── outputs.tf          # key_name
│
├── environments/
│   ├── dev/
│   │   ├── main.tf             # Module calls + provider configuration
│   │   ├── variables.tf        # Variable declarations
│   │   ├── outputs.tf          # Environment outputs
│   │   ├── backend.tf          # S3 remote state
│   │   └── terraform.tfvars    # Non-sensitive values to customize
│   │
│   ├── staging/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── backend.tf
│   │   └── terraform.tfvars
│   │
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── backend.tf
│       └── terraform.tfvars
│
└── .gitignore
```

## Usage

### 1. Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.10.0
- AWS CLI configured (`aws configure`) or environment variables:
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
```
- An S3 bucket for remote state (DynamoDB locking is no longer required):
```bash
aws s3api create-bucket --bucket <YOUR_BUCKET> --region us-east-1
```
- A pre-generated SSH key pair (one time only):
```bash
ssh-keygen -t rsa -f deploy_key -N ""
# deploy_key      → GitHub Secret : EC2_SSH_PRIVATE_KEY  (used by Ansible)
# deploy_key.pem  → GitHub Secret : EC2_SSH_PUBLIC_KEY   (used by Terraform)
```

### 2. Configure GitHub Secrets

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_REGION` | AWS region (e.g. `us-east-1`) |
| `EC2_SSH_PUBLIC_KEY` | Contents of `deploy_key.pub` |
| `EC2_SSH_PRIVATE_KEY` | Contents of `deploy_key` |
| `EC2_KEY_NAME` | Key name in AWS (e.g. `web-laravel-staging`) |

### 3. Customize values

Edit the `terraform.tfvars` file for the target environment.  
Never put secrets in this file - non-sensitive values only:
```hcl
project_name      = "web-laravel"
ami_id            = "ami-XXXXXXXXXXXXXXXXX"
availability_zone = "us-east-1a"
```

### 4. Deploy manually

```bash
# Navigate to the target environment
cd environments/staging

# Initialize Terraform
terraform init

# Review the plan
terraform plan \
  -var="ssh_public_key=$EC2_SSH_PUBLIC_KEY" \
  -var="key_name=$EC2_KEY_NAME"

# Apply
terraform apply \
  -var="ssh_public_key=$EC2_SSH_PUBLIC_KEY" \
  -var="key_name=$EC2_KEY_NAME"

# Destroy (if needed)
terraform destroy \
  -var="ssh_public_key=$EC2_SSH_PUBLIC_KEY" \
  -var="key_name=$EC2_KEY_NAME"
```

### 5. Deploy via CI/CD

Deployment to `staging` is triggered automatically on every push to the `staging` branch of the Laravel repository:

```
push/merge → staging branch (Laravel repo)
      ↓
1. Laravel tests (CI)
      ↓
2. Checkout Terraform repo + terraform apply
      ↓
3. Capture EC2 IP (terraform output)
      ↓
4. Checkout Ansible repo + ansible-playbook
```

## Key Variables

### Networking module

| Variable | Description | Default |
|---|---|---|
| `vpc_cidr` | VPC CIDR block | `10.0.0.0/16` |
| `public_subnet_cidr` | Public subnet CIDR block | `10.0.1.0/24` |
| `availability_zone` | Availability zone | **required** |
| `ingress_rules` | Security Group inbound rules | `[]` |

### ssh_key module

| Variable | Description | Default |
|---|---|---|
| `key_name` | Key name in AWS EC2 | **required via CI/CD** |
| `public_key` | SSH public key content | **required via CI/CD** |

### ec2 module

| Variable | Description | Default |
|---|---|---|
| `ami_id` | AMI ID | **required** |
| `instance_type` | Instance type | `t3.micro` |
| `root_volume_size` | Root disk size (GB) | `20` |
| `root_volume_type` | Root volume type | `gp3` |
| `encrypt_volumes` | EBS encryption | `true` |
| `associate_public_ip` | Auto-assign public IP | `false` |
| `create_eip` | Create a static Elastic IP | `false` |
| `enable_detailed_monitoring` | Detailed CloudWatch monitoring | `false` |

## SSH Key

The key pair is generated once outside of Terraform:
```bash
ssh-keygen -t rsa -f deploy_key -N ""
```

- `deploy_key.pem` → stored in GitHub Secret `EC2_SSH_PUBLIC_KEY` → registered in AWS via Terraform (`aws_key_pair`)
- `deploy_key` → stored in GitHub Secret `EC2_SSH_PRIVATE_KEY` → used by Ansible to connect to instances

To connect manually to an instance:
```bash
ssh -i deploy_key.pem ubuntu@<IP>
```

## Public IP

The behavior is hardcoded in each environment's `main.tf`:

- **dev / staging**: `associate_public_ip = true` - automatic public IP, changes on every restart
- **prod**: `create_eip = true` and `associate_public_ip = false` - static Elastic IP, independent of the instance lifecycle

## Remote State

Terraform state is stored remotely on S3 with native S3 locking (`use_lockfile = true`, available since Terraform 1.10).  
Each environment has its own state key:

| Environment | S3 Key |
|---|---|
| dev | `dev/terraform.tfstate` |
| staging | `staging/terraform.tfstate` |
| prod | `prod/terraform.tfstate` |

## Included Best Practices

- IMDSv2 enforced on all instances (SSRF protection)
- EBS volumes encrypted by default
- SSH key pre-generated outside Terraform, never committed, stored in GitHub Secrets
- SSH restricted in prod (`/32`), open in dev/staging
- S3 remote state encrypted with native S3 locking (use_lockfile)
- Automatic tags on all resources (`Project`, `Environment`, `ManagedBy`)
- Clear separation between dev / staging / prod
- Secrets injected only via `-var` from GitHub Secrets, never in `terraform.tfvars`
```