# Observability Plan

## Review of the Sentry/Supabase Dashboard/Axiom/Posthog Stack

Our observability stack combines four specialized tools, each addressing a distinct aspect of monitoring and analytics:

- **Sentry**: A tool for error tracking and performance monitoring, offering detailed stack traces and insights into application issues.
- **Supabase Dashboard**: Part of the Supabase platform (an open-source Firebase alternative), it provides database management and monitoring capabilities, particularly for PostgreSQL-based systems.
- **Axiom**: A log management and analytics platform designed to handle large volumes of log data with search and visualization features.
- **Posthog**: An open-source product analytics tool focused on tracking user behavior, feature usage, and other user-centric metrics.

### Pros
- **Specialization**: Each tool excels in its domain:
  - Sentry for deep error tracking.
  - Supabase dashboard for database performance and management.
  - Axiom for robust log analytics.
  - Posthog for detailed product analytics.
- **Flexibility**: Allows you to pick the best tool for each observability need, creating a tailored solution.
- **Cost**: Can be cost-effective, especially if leveraging free tiers or open-source options.

### Cons
- **Integration Overhead**: Combining these tools requires manual effort, potentially involving custom development to unify data flows.
- **Complexity**: Managing multiple interfaces and data formats increases operational complexity.
- **Lack of Unified View**: Without additional tools (e.g., a visualization layer like Grafana), it lacks a true single pane of glass, making it harder to correlate data across the stack.

## Solution

Our solution will address the current observability challenges through a comprehensive approach that leverages OpenTelemetry (OTEL) as the foundation for unified data collection across our entire stack. This strategy will transform our fragmented monitoring landscape into a cohesive observability platform.

### Key Components of Our Solution

1. **OpenTelemetry Implementation**:
   - Deploy OpenTelemetry collectors to standardize telemetry data collection across all services
   - Instrument application code with OTEL SDKs to capture metrics, traces, and logs in a consistent format
   - Configure automatic instrumentation where possible to reduce developer overhead

2. **AWS-Native Integration**:
   - Leverage AWS X-Ray for distributed tracing as we migrate to AWS
   - Utilize Amazon CloudWatch as a centralized metrics repository
   - Implement AWS CloudWatch Logs as our unified logging solution

3. **Database Monitoring Enhancement**:
   - Deploy specialized OTEL collectors for PostgreSQL/Aurora to track connection pools, query performance, and resource utilization
   - Create custom instrumentation to capture database connection lifecycle events
   - Implement proactive alerting for connection pool saturation and dropped connections

4. **Memory Leak Detection**:
   - Configure detailed memory usage metrics collection via OTEL
   - Implement anomaly detection to identify unusual memory growth patterns
   - Create dashboards specifically designed to visualize memory trends over time

5. **Single Pane of Glass Dashboard**:
   - Implement Grafana as our visualization layer, connecting to all data sources
   - Design role-specific dashboards for developers, operations, and management
   - Create correlation views that link traces, logs, and metrics for faster troubleshooting

This solution will provide comprehensive visibility into our system's behavior, enabling us to proactively identify issues before they impact users and dramatically reduce our mean time to resolution when problems do occur.

## Single Pane of Glass

A "Single Pane of Glass" approach to observability refers to a unified dashboard or interface that consolidates monitoring data from multiple sources into one cohesive view. This approach is critical for our solution for several reasons:

### Benefits of a Single Pane of Glass

- **Reduced Context Switching**: Engineers can monitor the entire system without switching between multiple tools, reducing cognitive load and improving efficiency.
- **Correlation of Events**: When issues occur, having metrics, logs, and traces in one place makes it easier to correlate events across different system components.
- **Faster Troubleshooting**: During incidents, the ability to quickly navigate between related data points significantly reduces mean time to resolution (MTTR).
- **Holistic System Understanding**: Provides a comprehensive view of the system's health, making it easier to identify patterns and potential bottlenecks.
- **Simplified Onboarding**: New team members only need to learn one interface rather than multiple disparate tools.

### Addressing Current Challenges

Our current tool sprawl (Sentry, Supabase Dashboard, Axiom, and Posthog) creates several problems that a single pane of glass solution will address:

1. **Memory Leak Detection**: Consolidated metrics will make it easier to spot memory growth patterns before they cause server crashes, eliminating the need for scheduled restarts.
2. **Database Connection Issues**: Unified monitoring of both application errors and database performance metrics will help correlate dropped connections with their root causes.
3. **Deployment Monitoring**: A comprehensive view of system health before, during, and after deployments will support safer rollouts and faster rollbacks when needed.

### Implementation Considerations

For our implementation, we need a solution that:

- Integrates with AWS services as we migrate to their ecosystem
- Provides customizable dashboards for different stakeholders (developers, operations, management)
- Offers alerting capabilities with configurable thresholds
- Supports both real-time monitoring and historical analysis
- Scales cost-effectively with our growth

The single pane of glass approach will be central to our observability strategy, transforming how we detect, diagnose, and resolve issues across our entire application stack.

## OTEL

OpenTelemetry is an open-source observability framework that provides a unified way to collect and export telemetry data (metrics, logs, and traces) from applications and infrastructure. It serves as a vendor-neutral abstraction layer between your applications and various observability backends.

## Why OpenTelemetry is Essential for Our Strategy

### Vendor Neutrality and Flexibility
- **Avoid Vendor Lock-in**: By adopting OpenTelemetry as our instrumentation standard, we can switch between observability backends without changing our application code.
- **Future-proofing**: As the observability landscape evolves, we can adopt new tools without reinstrumenting our applications.
- **Unified Data Collection**: Consistent data collection across all services, regardless of language or framework.

### Comprehensive Coverage
- **Complete Telemetry**: OpenTelemetry provides a unified approach to collecting all three pillars of observability:
  - **Metrics**: Quantitative measurements over time (e.g., memory usage, request rates)
  - **Traces**: Distributed request flows across services
  - **Logs**: Structured event records

### Standardization Benefits
- **Consistent Context Propagation**: Ensures that context (like trace IDs) is properly maintained across service boundaries.
- **Semantic Conventions**: Standardized naming and attributes make data more consistent and easier to analyze.
- **Reduced Instrumentation Effort**: Auto-instrumentation libraries reduce the manual work needed to collect telemetry.

## Implementation Plan

### Phase 1: Core Instrumentation
1. **Add OpenTelemetry SDKs** to all services, starting with our most critical components:
   - TRPC API server
   - Sync engine (Zero)
   - Background job processors
2. **Configure auto-instrumentation** for common frameworks and libraries to capture:
   - HTTP requests/responses
   - Database queries
   - Cache operations
   - Message queue interactions

### Phase 2: Custom Instrumentation
1. **Implement custom spans** for business-critical operations:
   - Database connection management (to track our connection issues)
   - Memory usage tracking (to identify memory leaks)
   - Authentication flows
   - Data synchronization processes

### Phase 3: Export Configuration
1. **Set up the OpenTelemetry Collector** as a central aggregation point
2. **Configure exporters** to send data to our chosen observability backend(s)
3. **Implement sampling strategies** to control data volume while preserving critical information

## Specific Use Cases for Our Challenges

### Tracking Database Connection Issues
- Use OTEL to instrument database connection pools
- Create custom metrics for connection attempts, successes, failures, and pool exhaustion
- Add spans around connection acquisition and release to identify bottlenecks

### Monitoring Memory Leaks
- Implement custom metrics to track memory usage over time
- Create histograms of request processing time correlated with memory consumption
- Add resource attributes to identify which services or containers are experiencing memory growth

### Deployment and Rollback Monitoring
- Add version tags to all telemetry data
- Create service-level objectives (SLOs) based on error rates and latency
- Monitor these metrics during and after deployments to trigger automated rollbacks if needed

## Integration with Observability Backends

The beauty of OpenTelemetry is that we can export our telemetry data to any supported backend. This gives us the flexibility to:

- Start with AWS CloudWatch if we proceed with AWS migration
- Evaluate other solutions like Grafana Cloud or SigNoz without reinstrumenting
- Run multiple backends in parallel during transition periods
- Switch providers if pricing or features change significantly

By building on OpenTelemetry, we create a foundation for observability that's independent of our specific tooling choices, allowing us to adapt as our needs evolve while maintaining consistent visibility into our system's behavior.

## Recommended Toolset: Cost-Effective, Straightforward, and Single Pane of Glass

### Top Recommendation: AWS CloudWatch
- **Overview**: AWS CloudWatch is a monitoring and observability service built for AWS resources and applications running on AWS. It provides data and actionable insights for monitoring applications, responding to system-wide performance changes, and optimizing resource utilization.
- **Why It Fits**:
  - **AWS Integration**: Native integration with all AWS services, making it ideal if you're using AWS infrastructure.
  - **Comprehensive**: Collects metrics, logs, and traces from your applications and infrastructure.
  - **Customizable Dashboards**: Create dashboards that provide a unified view of your resources and applications.
- **Pros**:
  - Seamless integration with AWS services (RDS, Lambda, EC2, etc.).
  - Built-in alarms and notifications.
  - No additional infrastructure needed if already on AWS.
  - Automatic scaling with your AWS usage.
- **Cons**:
  - Limited functionality outside the AWS ecosystem.
  - Can become complex for advanced use cases.
  - Dashboard capabilities less sophisticated than specialized tools like Grafana.
- **Cost**:
  - **Metrics**: First 10 custom metrics and all standard metrics are included in the AWS Free Tier.
    - Beyond free tier: $0.30 per metric per month.
  - **Logs**: First 5GB of log data ingestion and storage are free.
    - Beyond free tier: $0.50 per GB for ingestion, $0.03 per GB for storage.
  - **Dashboards**: $3.00 per dashboard per month.
  - **Alarms**: $0.10 per alarm metric per month.
  - **X-Ray (Tracing)**: $5.00 per million traces recorded, $0.50 per million traces retrieved.
  - **Total Cost**: For a small to medium application, approximately $50-200/month depending on usage.

### Grafana Cloud (with Optional Sentry Integration)
- **Overview**: Grafana Cloud is a managed observability platform that unifies metrics, logs, and traces. It offers a generous free tier and integrates with various data sources (e.g., Prometheus, Loki, PostgreSQL).
- **Why It Fits**:
  - **Single Pane of Glass**: Provides a unified dashboard for all telemetry data.
  - **Cost-Effective**: Free tier includes 10,000 metrics series, 50GB logs, and 50GB traces; paid plans are scalable and transparent.
  - **Straightforward**: Easy to set up with a user-friendly interface and wide community support.
- **Optional Add-On**: Integrate **Sentry** for specialized error tracking if your application requires deep debugging capabilities. Sentry data can be visualized in Grafana dashboards.
- **Pros**:
  - Unified view of metrics, logs, and traces.
  - Affordable pricing with a strong free tier.
  - Can monitor Supabase’s PostgreSQL database via integrations.
  - Flexible enough to incorporate specialized tools like Sentry.
- **Cons**:
  - May require initial configuration to connect all data sources.
- **Cost**:
  - Free tier: 10,000 metrics series, 50GB logs, 50GB traces.
  - Paid: $5/1,000 metrics series, $0.50/GB logs, $5/GB traces.
  - Sentry (optional): Free up to 5,000 events/month; $26/month for more.

### Alternative 1: SigNoz (Open-Source)
- **Overview**: SigNoz is an open-source observability platform built on OpenTelemetry, offering metrics, traces, and logs in a single UI.
- **Why It Fits**:
  - **Single Pane of Glass**: Combines all telemetry data seamlessly.
  - **Cost-Effective**: Free to use; costs are limited to self-hosting infrastructure.
  - **Straightforward**: Designed for easy setup, especially for cloud-native apps.
- **Pros**:
  - Full control with open-source flexibility.
  - No licensing fees.
- **Cons**:
  - Requires self-hosting and maintenance expertise.
- **Cost**: Infrastructure costs (e.g., servers, storage).

### Alternative 2: Datadog (Premium Option)
- **Overview**: A fully managed, comprehensive observability solution with extensive features.
- **Why It Fits**:
  - **Single Pane of Glass**: Covers all observability needs in one platform.
  - **Straightforward**: Minimal setup with a polished interface.
- **Pros**:
  - Robust feature set, including RUM and incident management.
  - Ideal for teams needing a turnkey solution.
- **Cons**:
  - High cost limits its cost-effectiveness.
- **Cost**: Starts at $15/host/month; scales with usage.

### Cost Comparison

| Feature | AWS CloudWatch | Grafana Cloud | Datadog | SigNoz | Custom Stack |
|---------|---------------|--------------|---------|--------|-------------|
| Metrics | $0.30/metric/month | Free tier: 10,000 series<br>$5/1,000 series after | $15/host/month | Self-hosted costs only | Variable (can use free tiers) |
| Logs | $0.50/GB ingestion<br>$0.03/GB storage | Free tier: 50GB<br>$0.50/GB after | $0.10/GB ingested | Self-hosted costs only | Axiom: Free tier 1GB/day<br>$25/month for 1TB |
| Traces | $5.00/million traces | Free tier: 50GB<br>$5/GB after | Included with APM ($31/host) | Self-hosted costs only | Typically part of APM solution |
| Dashboards | $3.00/dashboard/month | Included | Included | Included | Typically free with visualization tools |
| Total (Small App) | $50-100/month | $0-50/month | $200-500/month | $20-50/month (infrastructure) | $0-100/month |
| Total (Medium App) | $100-300/month | $50-200/month | $500-2,000/month | $50-200/month (infrastructure) | $100-300/month |
| Total (Large App) | $300-1,000+/month | $200-1,000+/month | $2,000-10,000+/month | $200-500+/month (infrastructure) | $300-1,000+/month |

## Final Recommendation
For a streamlined, integrated solution that aligns with our AWS migration strategy, **AWS CloudWatch** is the recommended choice. Since we're planning to migrate to AWS services (RDS Aurora, App Runner, AWS Batch, and S3 with CloudFront), CloudWatch provides native integration with all these services, eliminating the need for additional configuration. This tight integration will enable automatic monitoring of our infrastructure with minimal setup overhead once migration is complete.

Adding **AWS X-Ray** for distributed tracing and **CloudWatch Synthetics** for canary testing creates a comprehensive observability solution within the AWS ecosystem. For enhanced error tracking, **Sentry** can still be incorporated as it works well alongside CloudWatch. This combination will provide deep visibility into our PostgreSQL database connections and memory usage issues.

While Grafana Cloud and SigNoz offer compelling features, and Datadog provides premium capabilities, the fact that we are already migrating to AWS makes CloudWatch the most sensible choice. Using AWS's native monitoring solution eliminates the need to integrate third-party tools with our AWS infrastructure. CloudWatch's consolidated billing with our other AWS services will also simplify cost management.

Given our AWS migration roadmap outlined in Phase 2, **AWS CloudWatch** is the most logical choice—supplemented with **Sentry** for specialized error tracking if needed. This approach maximizes operational efficiency while providing the comprehensive observability required to address our current challenges, and aligns perfectly with our overall migration strategy.