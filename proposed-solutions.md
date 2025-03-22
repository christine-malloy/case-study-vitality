# Proposed Solutions

This case study presents a wide variety of challenges, so we require a holistic solution. At a high level, the solution will involve 3 major initiatives:

- Migration to AWS
- Overhaul of the local dev environment
- Implement robust and proactive observability

Additionally, we will need to consider the long term requirement of achieving SOC2 compliance.

Let's review the motivation for each initiative:

## Migration to AWS

Our current hosting solution involves using a combination of Vercel, Railway, and Supabase. Hosting solutions such as these that come from smaller cloud providers sometimes have scaling issues. To be fair, everyone has scaling issues, but often times those smaller hosting solutions (Heroku, Rackspace) don't give as much controls and power to scale as you might get in one of the three big cloud providers, AWS, GCP, and Azure. It's one of those cases where, with great power comes great responsibility. 

Using an all-in-one hosted solution like Supabase focuses on developer quality of life and delivering a "no ops" solution that lets developers get back to coding. However, as we have seen in particular with Supabase, managing it at scale requires specific attention, which in essence brings us back to square one of the developers having to manage the database when they would rather be coding. This is because tuning and scaling a database as a startup grows is a sufficient and interesting challenge. Solutions like Supabase can be good for the outset of a project, but after sufficient scale it makes sense to begin to consider other options designed for larger production loads.

Reviewing the landscape of the three cloud providers proven to operate at scale, we have:

### AWS (Amazon Web Services)

#### Pros:
- **Mature Platform**: As the longest-standing provider, AWS offers the most extensive range of services and features.
- **Large Community**: A vast ecosystem with extensive documentation, third-party tools, and a strong user base.
- **Strong Security & Compliance**: Industry-leading security features and compliance certifications.
- **Global Presence**: The largest network of data centers worldwide, ideal for low-latency applications.
- **AWS RDS Aurora** - managed serverless database clustering service which can address our connection issues, give us powerful scaling controls, facilitate no-downtime and DR (disaster recovery) thanks to reader nodes and automatic failover. Massive scaling potential especially for read-heavy applications.

#### Cons:
- **Steep Learning Curve**: Complex and overwhelming for beginners due to its breadth of offerings. However this is well managed by a robust IAC strategy.
- **Costly for Some Services**: Certain features, like data transfer or premium support, can get expensive.
- **Complex Pricing**: The pricing structure can be hard to predict, potentially leading to unexpected costs.

### GCP (Google Cloud Platform)

#### Pros:
- **Competitive Pricing**: Offers cost-effective compute resources and storage options.
- **Data & AI Tools**: Excels in data analytics and machine learning (e.g., BigQuery, TensorFlow).
- **User-Friendly Interface**: Simple and intuitive, making it accessible for developers.
- **Global Network**: Leverages Google's strong network backbone, though with fewer data centers than AWS.

#### Cons:
- **Fewer Services**: Lags behind AWS and Azure in the total number of services offered.
- **Smaller Infrastructure Footprint**: Fewer global data centers, which may affect latency in some regions.
- **Less Mature Enterprise Support**: Not as robust as AWS or Azure for large-scale enterprise needs.

### Azure (Microsoft Azure)

#### Pros:
- **Microsoft Integration**: Seamlessly integrates with Microsoft products like Office 365 and Active Directory.
- **Enterprise Support**: Strong focus on enterprise needs, with excellent hybrid cloud capabilities.
- **Competitive for Microsoft Workloads**: Cost-effective for organizations already using Microsoft tech.
- **Good Balance of Services**: Offers a wide range of services with a manageable learning curve.

#### Cons:
- **Expensive for Non-Microsoft Workloads**: Costs can rise if not leveraging Microsoft-specific services.
- **Less Mature Open-Source Ecosystem**: Trails AWS and GCP in open-source tool support.
- **Some Services Lag Behind**: Certain offerings are still catching up to the maturity of AWS and GCP.

After assessing the available options, AWS emerges as the top choice for our needs, thanks to two standout strengths.

First, AWS offers an impressive suite of security tools that ensure robust protection. Tools like Security Hub provide a clear view of compliance status and security alerts, Inspector enables proactive vulnerability scanning, and Macie enhances data security. On top of that, AWS supports an extensive list of compliance certifications—think SOC 1-3, PCI DSS, HIPAA/HITECH, FedRAMP, GDPR, and ISO 27001—making it a powerhouse for meeting regulatory requirements.

Second, Aurora, AWS's serverless database engine, seals the deal. Its seamless scaling capabilities, paired with built-in disaster recovery (DR) and high availability (HA), make it an obvious fit for this case study's demands.

On the other hand, GCP stands out as a worthy runner-up, particularly for its startup-friendly features. Its intuitive design and low learning curve mean our small team can prioritize coding over wrestling with cloud complexities—a major plus for startups. While this might feel unexpected given our initial provider preferences, GCP's edge comes from Google's backing, which brings a wealth of reliable, battle-tested tools for big data. Among them, Cloud Spanner shines, purpose-built to tackle multi-region workloads and deliver global scalability, addressing critical needs in distributed systems.

In short, AWS takes the lead with its security prowess and Aurora's capabilities, while GCP remains a compelling option for its startup appeal and Cloud Spanner's strengths.

## Overhaul of the local dev environment

Currently, our developers rely on a shared database instance, which often causes data inconsistencies and slows down development. This setup also complicates testing and acceptance processes. To address this, we'll implement a solution that replicates the full environment—API and database—locally. Developers can make API calls to this local setup, connect it to a local frontend instance, and run an integration test suite to perform end-to-end testing on a complete system. Since it operates locally, this approach speeds up feedback loops, enabling quicker bug fixes and feature development. It also allows developers to create and test new schemas independently, without disrupting the rest of the team. They can even run pen and load tests locally, to facilitate security compliance and performance optimization.

## Implement robust and proactive observability

Observability is a top priority for IT organizations, especially with our challenges involving memory leaks and database connections. Creating a unified "Single Pane of Glass" view to monitor critical pain points is one of the most impactful steps we can take. To achieve this, we'll deploy OpenTelemetry (OTEL) across backend and frontend services to establish a consistent logging framework. We'll ensure logs are structured and assigned appropriate levels for effective filtering. Traces will be activated and linked to logs, enabling us to track, measure, and correlate executions with specific endpoints. Custom metrics will be set up to monitor functions that load large objects into memory, helping us detect and manage potential memory leaks. Similarly, we'll track database connections with custom metrics, measuring open connections and their percentage of capacity. Finally, we'll configure alarms to flag these issues and, ideally, trigger automated remediation to address them promptly.  

## [Database Management](./db-connection-issues.md)
- Evaluate alternatives like AWS RDS Aurora or Azure SQL for better reliability and scalability than Supabase.
- Use connection pooling (e.g., PgBouncer) to manage connections efficiently.
- Optimize queries to reduce load and prevent drops.
- Prioritize zero downtime migrations

## [Memory Leaks](./memory-leak-issues.md)
- Investigate application code with profiling tools to pinpoint leaks.
- Adjust container memory limits if containerized, or optimize bare-metal configs.
- Monitor memory usage with alerts for anomalies.

## [Observability](./observability-plan.md)
- Implement a Single Pane of Glass approach for comprehensive visibility across all systems
- Deploy OpenTelemetry (OTEL) for unified logging, tracing, and metrics collection
- Leverage AWS CloudWatch as our primary observability platform, with custom dashboards for key metrics
- Set up automated alerts for memory usage spikes and database connection issues
- Integrate distributed tracing to identify bottlenecks and performance issues in real-time

## [Rollback Strategies](./rollback-plan.md)
- Ensure atomic deployments with automated rollbacks on failure.
- Use feature flags to toggle features without redeploying.
- Build CI/CD pipelines with testing gates and microservice coordination.

## [Compute Solution](./compute-solution-plan.md)
- Assess scaling needs (concurrent users, microservices count). For now, simpler tools like AWS ECS or Azure - Container Apps may suffice.
- Revisit Kubernetes if managing 10+ microservices or needing multi-region deployments.

## [Local Development](./local-dev-stack.md)
- Provide each developer an isolated database via Docker Compose with Postgres.
- Use migration tools (e.g., Flyway, Liquibase) to sync schemas locally.

## [SOC2 Compliance](./soc2-compliance-plan.md)
- Implement controls: access restrictions, audit logs, regular security assessments.
- Automate remediation tasks and surface compliance metrics to developers.
- Document processes for audits.

## [Architecture Diagram](./arch-plan.md)
- Map current setup: Vercel (Next.js frontend), Railway (Bun servers, TRPC API, Redis, Zero sync), Supabase (Postgres, auth).
- Propose enhancements like a more reliable DB provider and optimized service interactions.