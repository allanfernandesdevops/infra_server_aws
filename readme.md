# Terraform para criação da infra na AWS da empresa TEC.
## Pré-req.
- Bucket criado no S3 para armazenamento do state do terraform.
- AMI gerada através do pipeline create_image.
- Certificado gerado para o domínio.
- Keypair já criada.
- Como as parte de VPC e subnets já estão criadas será necessário incluir no arquivo `terraform.tfvars` as subnets **privadas** onde estão as EC2 e as subnets públicas onde ficarão os **load balancers**.
