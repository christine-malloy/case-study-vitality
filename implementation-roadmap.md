# Implementation Roadmap

## Phase 1 - Dev and Observability Overhaul:
- Establish local dev process
- Build out custom instrumentation around Db connections and api memory usage.
- Boost observability with logging, tracing, and dashboards.
- Monitor and mitigate Supabase connection drops.
## Phase 2 - AWS Migration:
- Test and potentially migrate to AWS RDS Aurora or similar.
- Begin AWS migration plan, starting with AWS RDS Aurora for the postgres server, AWS App Runner for the Bun server, AWS Batch for the jobs, and AWS S3 with Cloudfront for the Next.js frontend.
- Leverage liquibase for zero-downtime migrations
- Establish release and rollback strategies. 
- Implement pipelines to transactionally deploy new versions.
## Phase 3 - SOC2 Compliance:
- Start SOC2 compliance with key controls, leveraging AWS Security Hub to track compliance work
## Phase 4 - Architecture Review:
- At this stage, review microservice map and App Runner solution, and consider EKS. Migrate to EKS if it makes sense based on scaling needs.