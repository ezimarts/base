# # -----------------------------
# # Elastic IP for NAT Gateway
# # -----------------------------
# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "nat-eip"
#   }
# }

# # -----------------------------
# # NAT Gateway
# # -----------------------------
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet_1.id

#   tags = {
#     Name = "main-nat-gateway"
#   }

#   depends_on = [aws_internet_gateway.igw]
# }

# # -----------------------------
# # Private Route Table
# # -----------------------------
# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.main.id

#   # Route internet traffic through NAT Gateway
#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }
