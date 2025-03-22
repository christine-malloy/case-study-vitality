# Vitality Network Architecture

## Network Diagram

```mermaid
flowchart TB
    %% Define styles
    classDef vpc fill:#F7FBFF,stroke:#3F8624,stroke-width:2px,color:#0A3200,font-weight:bold
    classDef subnet fill:#F1F8E9,stroke:#7CB342,stroke-width:1px,color:#2E5014,font-weight:bold
    classDef securityGroup fill:#FFEBEE,stroke:#D32F2F,stroke-width:1px,color:#7A0000,font-weight:bold
    classDef component fill:#E3F2FD,stroke:#1976D2,stroke-width:1px,color:#0D47A1,font-weight:bold
    classDef subgraphTitle color:#000000,font-weight:bold

    %% Main VPC with all components inside
    subgraph vpc["VPC: vitality-dev-app-vpc (10.0.0.0/16)"]
        %% Public/Private Subnets
        subgraph publicPrivateSubnets["Public/Private Subnets (us-east-1a, us-east-1b)"]
            publicSubnetA["Public Subnet<br>us-east-1a"]
            publicSubnetB["Public Subnet<br>us-east-1b"]
            privateSubnetA["Private Subnet<br>us-east-1a"]
            privateSubnetB["Private Subnet<br>us-east-1b"]
        end
        
        %% Private Only Subnets
        subgraph privateOnlySubnets["Private Only Subnets (us-east-1c, us-east-1d)"]
            privateSubnetC["Private Subnet<br>us-east-1c"]
            privateSubnetD["Private Subnet<br>us-east-1d"]
        end
        
        %% Security Groups - Now clearly inside the VPC
        subgraph sgPrimary["Primary Security Group"]
            sgPrimarySsh["Ingress: SSH (Port 22)<br>from 0.0.0.0/0"]
            sgPrimaryHttp["Ingress: HTTP (Port 80)<br>from self"]
            sgPrimaryEgress["Egress: All Traffic"]
        end
        
        subgraph sgPostgres["Postgres Security Group"]
            sgPostgresIngress["Ingress: PostgreSQL (Port 5432)<br>from Primary SG"]
            sgPostgresEgress["Egress: All Traffic"]
        end
        
        %% Bastion Host
        bastion["Bastion Host<br>t2.micro"]
        
        %% VPC Label to show this is a VPC resource
        vpcLabel["VPC-scoped<br>Security Groups"]
    end
    
    %% External components
    igw["Internet Gateway"]
    keyPair["SSH Key Pair<br>vitality-dev-app-ssh-key"]
    
    %% Connections
    igw --- vpc
    publicSubnetA --- bastion
    bastion --- sgPrimary
    sgPrimary --- sgPostgres
    bastion --- keyPair
    vpcLabel --- sgPrimary
    vpcLabel --- sgPostgres
    
    %% Apply Classes
    class vpc vpc
    class publicPrivateSubnets,privateOnlySubnets,publicSubnetA,publicSubnetB,privateSubnetA,privateSubnetB,privateSubnetC,privateSubnetD subnet
    class sgPrimary,sgPostgres,sgPrimarySsh,sgPrimaryHttp,sgPrimaryEgress,sgPostgresIngress,sgPostgresEgress securityGroup
    class bastion,igw,keyPair,vpcLabel component
    class publicPrivateSubnets,privateOnlySubnets,sgPrimary,sgPostgres subgraphTitle
```

## Network Components

| Resource | Description | Details |
|----------|-------------|---------|
| VPC | Main Virtual Private Cloud | CIDR: 10.0.0.0/16 |
| Public/Private Subnets | Subnets with both public and private access | AZs: us-east-1a, us-east-1b<br>CIDR: Subset of 10.0.0.0/16 |
| Private Only Subnets | Subnets with private access only | AZs: us-east-1c, us-east-1d<br>CIDR: Subset of 10.0.0.0/16 |
| Primary Security Group | Main security group for standard access | Ingress: SSH (22), HTTP (80)<br>Egress: All traffic |
| Postgres Security Group | Security group for PostgreSQL access | Ingress: PostgreSQL (5432) from Primary SG<br>Egress: All traffic |
| Bastion Host | Jump server for secure access to private resources | Instance Type: t2.micro<br>Location: Public Subnet |
| SSH Key Pair | Key pair for secure SSH access | Generated from local file or created by Terraform |

## Security Group Scope

Security groups in AWS are **VPC-level resources**. This means:

1. They are created and exist within the context of a specific VPC
2. They can be attached to resources within that VPC only
3. They can reference other security groups only within the same VPC
4. Rules can control traffic entering and leaving resources regardless of subnet

## Network Design Principles

1. **Segmentation**: The network is segmented into public, private, and private-only subnets for different security requirements.
2. **Secure Access**: A bastion host in the public subnet provides secure access to resources in private subnets.
3. **Least Privilege**: Security groups restrict traffic to only necessary ports and protocols.
4. **High Availability**: Resources are deployed across multiple availability zones.
5. **Future Expansion**: The design allows for future expansion of subnets and additional resources.

## Security Measures

- SSH access is restricted to the bastion host
- PostgreSQL access is limited to resources within the Primary Security Group
- All internal HTTP traffic is contained within the security group
- Private resources do not have direct internet access

## References

- [CloudPosse VPC Module](https://github.com/cloudposse/terraform-aws-vpc)
- [CloudPosse Dynamic Subnets Module](https://github.com/cloudposse/terraform-aws-dynamic-subnets)
- [CloudPosse Security Group Module](https://github.com/cloudposse/terraform-aws-security-group)
- [CloudPosse EC2 Bastion Server Module](https://github.com/cloudposse/terraform-aws-ec2-bastion-server) 