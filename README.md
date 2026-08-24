# AWS EKS Technical Architecture

This repo is aimed for hihgly avaiable EKS clusters

```mermaid
graph TB
    subgraph AWS ["AWS Cloud (ap-southeast-2)"]
        subgraph VPC ["AWS VPC (10.0.0.0/16)"]
            
            IGW["Internet Gateway"]
            
            subgraph PublicSubnets ["Public Subnets (Multi-AZ)"]
                NAT_A["NAT Gateway (AZ-A)"]
                NAT_B["NAT Gateway (AZ-B)"]
                ALB["AWS Application Load Balancer"]
            end

            subgraph EKS ["Amazon EKS Cluster v1.31"]
                ControlPlane["EKS Control Plane (OIDC Enabled)"]
                
                subgraph PrivateSubnets ["Private Subnets (Multi-AZ)"]
                    subgraph NodeGroup ["Managed Node Group (t3.medium)"]
                        Pod1["Pod 1: Nginx (app-test)"]
                        Pod2["Pod 2: Nginx (app-test)"]
                    end
                end
            end

            IRSA["EBS CSI Driver (IRSA OIDC)"]
            SC["StorageClass: ebs-sc"]
            PVC["PVC: app-pvc (4Gi)"]
            EBS[("AWS EBS Volume")]
        end
    end

    Client["Internet Clients"] --> IGW
    IGW --> ALB
    ALB -->|Ingress Route| Pod1
    ALB -->|Ingress Route| Pod2
    
    Pod1 -->|Outbound Traffic| NAT_A
    Pod2 -->|Outbound Traffic| NAT_B
    NAT_A --> IGW
    NAT_B --> IGW

    ControlPlane -->|IAM Role Auth| IRSA
    IRSA -->|Provision Volume| SC
    SC --> PVC
    PVC -->|Mount /usr/share/nginx/html/data| EBS
    Pod1 -.->|Attach Storage| EBS
    Pod2 -.->|Attach Storage| EBS
```

## Prequistites
* **AWS CLI**: '>=2.x'
* **Terraform**: '>=1.5.0'
* **Hashicorp/AWS**: '~> 5.0.0'
* **kubectl**: '>=1.31.x'
* **terraform-aws-modules/eks/aws**: '~> 20.0'
  
## Deploy Instructions

### Phase 1: Infrastructure Provisiong (Terraform)
```bash
    terraform init
    terraform fmt
    terraform validate
    terraform plan
    terraform apply --auto-approve
```

### Phase 2: Kubernetes Deployment
- `aws eks update-kubeconfig --region ap-southeast-2 --name testing-k8s-cluster --profile testing-session`
- `kubectl apply -f k8s-app.yml`


### Phase 3: Validation
1. Verify Nodes:
    - `kubectl get nodes -o wide`
2. Verify Pods and PVC and screenshot:
    - `kubectl get pods -n app-test -o wide`
    - `kubectl get pvc -n app-test`
    - `kubectl describe pod -n app-test -l app.kubernetes.io/name=sample-app`
3. Test Connectivity:
    - curl -I URL

### Phase 4: Cleanup Instruction
1. `kubectl delete -f k8s-app.yml`
1. `terrform destroy --auto-approve`
1. `terrform plan`