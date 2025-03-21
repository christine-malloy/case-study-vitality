# Compute Solution Plan

Today the api/jobs solution runs on Railway. We will compare this to managed solutions in AWS, since that is our selected cloud provider for the database solution. When making our considerations, we want to balance developer experience and velocity with scalability. Often times, infrastructure solutions with more scaling potential often come with more management complexity and overhead. Sometimes it makes more sense to pay for scaling up front with a managed PaaS solution, versus paying for engineering time to manage an IaaS solution that gives you more control. With great power comes great responsibility. Our solution will be focused on balancing these factors against our immediate needs and long-term priorities.

## Docker

As a quick note of mention, the solution assumes that our applications will be Dockerized. this is because Docker is by now and industry standard, widely appreciated for a number of problems it solves, and is almost required due to the number of hosted compute solutions that leverage Docker.

Docker is a containerization platform that packages applications and their dependencies into standardized units called containers. These containers are lightweight, portable, and can run consistently across different environments.

### Benefits of Docker for Our Solution:

- **Portability**: Docker containers can run on any platform that supports Docker, making our applications highly portable across different environments (development, testing, production) and cloud providers.

- **Consistency**: Docker ensures that applications run the same way regardless of where they're deployed, eliminating "it works on my machine" problems.

- **Isolation**: Containers isolate applications from each other and from the underlying infrastructure, improving security and reducing conflicts.

- **Efficiency**: Containers share the host OS kernel, making them more lightweight than virtual machines and allowing for better resource utilization.

- **Scalability**: Docker containers can be easily scaled horizontally by spinning up additional instances as needed.

By adopting Docker as the foundation of our compute strategy, we gain significant flexibility in our infrastructure choices. This containerization approach means we can:

1. Start with simpler managed solutions like Railway or AWS App Runner that have lower operational overhead
2. Gradually transition to more sophisticated platforms like ECS or EKS as our scale and requirements evolve
3. Avoid vendor lock-in since our containerized applications can be migrated between different cloud providers or platforms with minimal changes

This flexibility is crucial for a growing startup, as it allows our infrastructure to adapt to changing business needs without requiring significant application rewrites. We can make infrastructure decisions based on current requirements while maintaining the ability to evolve our approach as the business scales.

## Current Solution - Railway

Railway is a platform-as-a-service (PaaS) provider that offers containerized deployments with automatic scaling and management.

### Pros:
- Simple developer experience with GitHub integration
- Quick deployments with zero configuration
- Built-in metrics and logging
- Automatic HTTPS and custom domains
- Pay-per-use pricing model
- Managed PostgreSQL databases
- Automatic container scaling

### Cons:
- Limited control over infrastructure
- Connection stability issues at scale
- Higher costs at larger scale compared to raw infrastructure
- Limited geographic distribution
- Less mature enterprise features
- Fewer compliance certifications
- Database connection limits that are difficult to tune
- Less control over scaling parameters

### Typical Costs for Growing Startups:

Railway uses consumption-based pricing with the following typical ranges:

#### Small Scale (Early Startup)
- 2-3 services: $20-50/month
- Basic PostgreSQL: $20-30/month
- Total: ~$40-80/month

#### Medium Scale (Growth Stage)
- 5-10 services: $100-300/month
- Production PostgreSQL: $50-150/month
- Total: ~$150-450/month

#### Large Scale (Rapid Growth)
- 10+ services: $300-1000+/month
- High-usage PostgreSQL: $200-500+/month
- Total: $500-1500+/month

At this scale, costs become less predictable and often exceed equivalent AWS infrastructure costs, making migration to cloud providers like AWS more attractive from both a control and cost perspective.

## AWS App Runner

AWS App Runner is a fully managed service that makes it easy to deploy containerized web applications and APIs at scale without requiring infrastructure expertise.

#### Pros:
- Fully managed container orchestration
- Automatic scaling based on traffic
- Built-in CI/CD pipeline integration
- Private networking with VPC integration
- Simplified deployment process
- Managed TLS certificates and HTTPS
- AWS ecosystem integration (CloudWatch, IAM, etc.)
- Regional availability with global edge network
- Predictable pricing model

#### Cons:
- Less flexible than ECS/EKS for complex deployments
- Limited customization of underlying infrastructure
- Fewer configuration options than Railway for simple use cases
- Higher baseline costs for very small applications
- Requires more AWS knowledge than Railway

### TRPC Server Solution with App Runner

App Runner is an excellent fit for hosting the TRPC server as it:

1. Supports containerized Node.js/Bun applications natively
2. Can scale automatically based on incoming request volume
3. Integrates directly with our AWS RDS Aurora database
4. Provides health checks and automatic restarts
5. Offers observability through CloudWatch integration

### Comparison to Railway

Both App Runner and Railway are PaaS solutions, but they differ in key ways:

| Feature | AWS App Runner | Railway |
|---------|---------------|---------|
| Infrastructure Control | More granular control | Simplified, less control |
| Scaling | Configurable auto-scaling | Basic auto-scaling |
| Database Integration | Native AWS RDS integration | Managed PostgreSQL with limitations |
| Networking | VPC integration, private networking | Limited network configuration |
| Observability | CloudWatch integration | Basic metrics and logging |
| Compliance | AWS compliance framework | Limited compliance certifications |
| Pricing | Predictable, resource-based | Consumption-based, less predictable at scale |
| Learning Curve | Steeper, requires AWS knowledge | Gentler, developer-friendly |
| Enterprise Readiness | Enterprise-grade features | Limited enterprise capabilities |

### Cost Projection for AWS App Runner

App Runner pricing is based on compute and memory resources used, plus additional charges for provisioned concurrency:

#### Small Scale (Early Startup)
- 1 vCPU, 2GB memory instance: ~$36/month (base)
- Provisioned concurrency (1 instance): ~$25/month
- Data transfer: ~$5-10/month
- Total: ~$66-71/month

#### Medium Scale (Growth Stage)
- 2 vCPU, 4GB memory instances: ~$144/month (base)
- Provisioned concurrency (2-3 instances): ~$50-75/month
- Data transfer: ~$15-30/month
- Total: ~$209-249/month

#### Large Scale (Rapid Growth)
- 4 vCPU, 8GB memory instances: ~$576/month (base)
- Auto-scaling (3-10 instances): ~$75-250/month
- Data transfer: ~$50-100/month
- Total: ~$701-926/month

While the baseline costs for App Runner may be slightly higher than Railway for very small deployments, the predictable scaling and cost structure becomes more economical as the application grows. Additionally, the improved reliability, integration with AWS services, and enterprise-grade features provide better value at scale compared to Railway's consumption-based model which can become unpredictable during traffic spikes.

For our growing application with increasing scale requirements and the need for better database connection management, App Runner provides a logical stepping stone between Railway's simplicity and a full Kubernetes deployment, while keeping us within the AWS ecosystem where our database will reside.

## AWS EKS

### AWS Elastic Kubernetes Service (EKS) Overview

AWS EKS is a managed Kubernetes service that simplifies the deployment, management, and scaling of containerized applications using Kubernetes. It provides a highly available and secure Kubernetes control plane without requiring you to install, operate, and maintain your own Kubernetes control plane.

#### Key Features of EKS

1. Fully managed Kubernetes control plane
2. Seamless integration with AWS services (IAM, VPC, ECR)
3. Support for both EC2 and Fargate (serverless) compute
4. Advanced networking and security capabilities
5. Automated version upgrades and patching
6. Multi-AZ high availability

#### Pros of AWS EKS

- **Production-Grade Kubernetes**: Enterprise-ready, highly available Kubernetes deployment
- **Flexibility**: Supports various workload types and custom configurations
- **Scalability**: Virtually unlimited scaling capabilities for large applications
- **Portability**: Standard Kubernetes API means workloads can be migrated to/from other Kubernetes platforms
- **Ecosystem**: Access to the vast Kubernetes ecosystem of tools and extensions
- **Security**: Advanced security features including pod security policies, network policies, and IAM integration

#### Cons of AWS EKS

- **Complexity**: Steeper learning curve compared to simpler PaaS solutions
- **Management Overhead**: Requires Kubernetes expertise for effective operation
- **Cost**: Higher baseline costs due to control plane charges and worker node requirements
- **Setup Time**: More complex initial setup compared to App Runner or Railway

#### Comparison to Railway

| Feature | AWS EKS | Railway |
|---------|---------|---------|
| Infrastructure Control | Complete control | Simplified, minimal control |
| Scaling | Highly configurable, unlimited | Basic auto-scaling, limited |
| Database Integration | Any database, advanced configurations | Managed PostgreSQL with limitations |
| Networking | Advanced networking, service mesh support | Limited network configuration |
| Observability | Full observability stack options | Basic metrics and logging |
| Compliance | Comprehensive AWS compliance | Limited compliance certifications |
| Pricing | Complex, higher baseline | Consumption-based, simpler |
| Learning Curve | Steep, requires Kubernetes expertise | Gentle, developer-friendly |
| Enterprise Readiness | Full enterprise capabilities | Limited enterprise features |
| Deployment Complexity | High, requires Helm/Arg | Low, simple pielines|

### Cost Projection for AWS EKS

EKS pricing includes the Kubernetes control plane cost plus the underlying compute resources:

#### Small Scale (Early Startup)
- EKS control plane: $73/month
- 2 t3.medium worker nodes (24/7): ~$60/month
- Load balancer and storage: ~$30/month
- Data transfer: ~$10-20/month
- Total: ~$173-183/month

#### Medium Scale (Growth Stage)
- EKS control plane: $73/month
- 3-5 t3.large worker nodes: ~$180-300/month
- Load balancer and storage: ~$50/month
- Data transfer: ~$30-50/month
- Total: ~$333-473/month

#### Large Scale (Rapid Growth)
- EKS control plane: $73/month
- 6-12 t3.xlarge or r5.large worker nodes: ~$600-1,200/month
- Multiple load balancers and increased storage: ~$100-150/month
- Data transfer: ~$100-200/month
- Total: ~$873-1,623/month

While EKS has a higher cost floor compared to both Railway and App Runner, it provides significantly more flexibility, control, and scalability. For applications with complex deployment requirements, multiple services, or specific compliance needs, the additional cost is often justified by the capabilities provided. However, the operational complexity and expertise required should not be underestimated.

For our current stage, EKS would likely be overengineered and unnecessarily complex. App Runner provides a better balance of simplicity and AWS integration while we grow, with EKS remaining an option for future migration as our scale and complexity increase.

## AWS Batch

AWS Batch is a fully managed service that enables developers to run batch computing workloads on the AWS Cloud. It dynamically provisions the optimal quantity and type of compute resources based on the volume and specific requirements of the batch jobs submitted.

### Key Features of AWS Batch

- **Fully Managed**: Eliminates the need to install and manage batch computing software
- **Dynamic Resource Provisioning**: Automatically scales EC2 instances based on job requirements
- **Priority-based Job Scheduling**: Allows for efficient resource allocation based on job importance
- **Cost Optimization**: Uses Spot Instances to reduce costs for non-time-critical workloads
- **Integration with AWS Services**: Works seamlessly with IAM, CloudWatch, and other AWS services

### AWS Batch for Jobs

AWS Batch is particularly well-suited for our pub/sub job processing needs:

1. **Asynchronous Job Processing**: Can efficiently handle our background jobs that are triggered by pub/sub events
2. **Scalable Architecture**: Automatically scales to accommodate varying job loads without manual intervention
3. **Cost Efficiency**: Only pay for the compute resources used during job execution
4. **Job Prioritization**: Can prioritize critical jobs over less time-sensitive tasks
5. **Retry Mechanisms**: Built-in retry capabilities for handling transient failures

### Implementation Approach

1. **Job Definitions**: Define our job types with their resource requirements and container images
2. **Job Queues**: Create queues with different priorities for various job types
3. **Compute Environments**: Configure environments that can scale based on workload demands
4. **Event Triggers**: Use EventBridge or SQS to trigger Batch jobs based on pub/sub events

### Cost Projection for AWS Batch

AWS Batch itself has no additional charge - you only pay for the underlying resources:

#### Small Scale (Early Startup)
- EC2 instances (on-demand or spot): ~$30-60/month
- Data transfer: ~$5-10/month
- Total: ~$35-70/month

#### Medium Scale (Growth Stage)
- EC2 instances (on-demand or spot): ~$100-200/month
- Data transfer: ~$15-30/month
- Total: ~$115-230/month

#### Large Scale (Rapid Growth)
- EC2 instances (on-demand or spot): ~$300-600/month
- Data transfer: ~$50-100/month
- Total: ~$350-700/month

### Comparison to Railway

| Feature | AWS Batch | Railway |
|---------|-----------|---------|
| Job Management | Comprehensive, purpose-built for batch jobs | Basic, general-purpose |
| Scaling | Automatic, fine-grained control | Basic auto-scaling |
| Cost Model | Pay for compute used | Consumption-based with higher overhead |
| Integration | Deep AWS ecosystem integration | Limited integrations |
| Complexity | Moderate learning curve | Simple, developer-friendly |
| Job Prioritization | Advanced queue management | Limited prioritization options |
| Monitoring | Detailed CloudWatch metrics | Basic metrics |

AWS Batch provides a more specialized and scalable solution for our pub/sub job processing needs compared to Railway, with better cost efficiency at scale and more sophisticated job management capabilities.

## AWS Lamba

AWS Lambda is a serverless compute service that runs code in response to events and automatically manages the underlying compute resources. It's an excellent option for event-driven workloads like our pub/sub job processing system.

### Key Benefits for Our Job Processing Needs

1. **True Serverless Architecture**: No servers to manage, provision, or scale - Lambda automatically scales with the number of events
2. **Event-Driven Execution**: Natively integrates with AWS services like SQS, SNS, and EventBridge for seamless pub/sub processing
3. **Cost Efficiency**: Pay only for compute time consumed, with no charges when code isn't running
4. **Rapid Scaling**: Scales instantly to handle traffic spikes without pre-provisioning
5. **Simplified Operations**: Reduces operational complexity with no infrastructure management
6. **Concurrency Controls**: Provides fine-grained control over scaling behavior and concurrency limits

### Implementation Approach

1. **Function Design**: Create Lambda functions for different job types, optimized for specific workloads
2. **Event Sources**: Configure SQS queues or SNS topics as event sources to trigger Lambda functions
3. **Concurrency Management**: Set appropriate concurrency limits to control scaling behavior
4. **Dead Letter Queues**: Implement DLQs for handling failed job executions
5. **Monitoring**: Use CloudWatch for comprehensive monitoring and alerting

### Cost Projection for AWS Lambda

Lambda pricing is based on the number of requests and the duration of execution:

#### Small Scale (Early Startup)
- 1 million invocations per month: ~$0.20
- 400,000 GB-seconds of compute: ~$6.67
- Data transfer: ~$5-10/month
- Total: ~$12-17/month

#### Medium Scale (Growth Stage)
- 10 million invocations per month: ~$2.00
- 4 million GB-seconds of compute: ~$66.67
- Data transfer: ~$15-30/month
- Total: ~$84-99/month

#### Large Scale (Rapid Growth)
- 50 million invocations per month: ~$10.00
- 20 million GB-seconds of compute: ~$333.33
- Data transfer: ~$50-100/month
- Total: ~$393-443/month

### Comparison to Other Solutions

| Feature | AWS Lambda | AWS Batch | Railway |
|---------|------------|-----------|---------|
| Scaling | Instant, automatic | Automatic but not instant | Basic auto-scaling |
| Cold Starts | May experience cold starts | No cold starts | No cold starts |
| Execution Time | Limited to 15 minutes | Unlimited duration | Unlimited duration |
| Resource Limits | Memory up to 10GB | Flexible resource allocation | Limited configuration options |
| Cost Model | Pay per invocation and duration | Pay for compute used | Consumption-based with overhead |
| Operational Complexity | Very low | Moderate | Low |
| Job Complexity | Best for shorter, event-driven jobs | Ideal for longer, resource-intensive jobs | General purpose |
| Monitoring | Detailed CloudWatch integration | CloudWatch integration | Basic metrics |

### When to Choose Lambda for Jobs

Lambda is ideal for our pub/sub job processing when:

1. **Jobs are short-lived**: Tasks complete within minutes rather than hours
2. **Workloads are unpredictable**: Traffic patterns vary significantly throughout the day
3. **Event-driven architecture**: Jobs are triggered by specific events
4. **Cost optimization is critical**: Minimizing costs during periods of low activity
5. **Operational simplicity is valued**: Reducing infrastructure management overhead

For our current scale and job characteristics, Lambda provides an excellent balance of simplicity, cost-efficiency, and scalability. As our workloads grow or become more complex, we can selectively migrate specific job types to AWS Batch while keeping others on Lambda, creating a hybrid approach that leverages the strengths of each service.

## Summary

This is a brief overview of the compute solutions available in AWS and how they compare to Railway. The listed services were chosen due to their relevancy, picking out App Runner and Batch in particular as our top choices. By no means is this the only potential solution. Besides the alternatives of Lambda and EKS, we could also consider Lightsail, Elastic Beanstalk, and ECS on EC2 or Fargate. Suffice it to say, there are a number of options that lets us be adapatable and chose the option that will be the most cost efficient will prioritizing operational success.