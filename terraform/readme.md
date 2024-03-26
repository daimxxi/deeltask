Directory Content: Terraform Code for 1-Tier Architecture Deployment and a Drone starlark Pipline to lint, validate, scan and apply TF code, the pipline is written in a DroneCI starlark format.

The architecture includes the following components:

* VPC: Configured with one public and one private subnet.
* EC2 Instance: Deployed within the private subnet.
* Load Balancer: Deployed in the public subnet.
* InternetGateway: It enables instances in the private subnet to access the internet for software updates, while also facilitating incoming traffic from users.
* NatGateway: Instances in the private subnet to initiate outbound connections to the internet.
* Routetables: Rules for routing network traffic within the VPC

This setup provides a basic infrastructure for hosting and serving applications within a secure network environment.
