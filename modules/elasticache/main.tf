resource "aws_elasticache_cluster" "redis-lab-cache" {
cluster_id = "tecnofit-cluster"
engine = "redis"
node_type = "cache.t3.micro"
port = 6379
num_cache_nodes = 1
parameter_group_name = "default.redis6.x"
subnet_group_name = aws_elasticache_subnet_group.default.name

tags = {
  Project = "lab"
}

}

resource "aws_elasticache_subnet_group" "default" {
  name       = "elasticache-subnet"
  subnet_ids = ["${var.ec2_subnets}"]
} 