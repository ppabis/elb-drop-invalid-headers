This is an example infrastructure that tests how
AWS ELB option "drop invalid header fields" functions.

It will create:

- VPC + 2 public subnets
- Application Load Balancer
- A Lambda function + IAM role
- S3 bucket for logs

Read more here:

* [https://pabis.eu/blog/2025-04-24-Application-Load-Balancer-Drop-Invalid-Headers.html](https://pabis.eu/blog/2025-04-24-Application-Load-Balancer-Drop-Invalid-Headers.html)
* [https://dev.to/aws-builders/application-load-balancer-drop-invalid-headers-3hn0](https://dev.to/aws-builders/application-load-balancer-drop-invalid-headers-3hn0)