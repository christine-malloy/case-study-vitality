# Current State Analysis
Our startup faces several critical challenges:

- Memory Leaks: Servers crash due to unchecked memory usage, mitigated by a cron job restarting them every 2 hours to avoid high costs.
- Poor Observability: Limited visibility into errors, tool sprawl, with no proactive error detection.
- Database Issues: database frequently drops connections, impacting reliability. Need different hosting solution.
- Rollback Strategies: CI/CD lacks robust rollback mechanisms for failed migrations or deployments across microservices.
- Kubernetes Uncertainty: Questions about whether and when to adopt Kubernetes.
- Zero-Downtime Migrations: Long migrations and potential user errors during updates.
- Shared Dev Database: Six engineers use a shared database, risking conflicts.
- SOC2 Compliance: Required but not yet implemented.
- Architecture Diagram: Needs an updated representation of the system.