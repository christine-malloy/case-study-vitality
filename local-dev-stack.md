# Local Dev Stack

The local development environment isn’t just a nice-to-have—it’s the first line of defense for any IT organization. It’s where developers catch logic defects, performance bottlenecks, and database query hiccups before they escalate into production nightmares. When devs can replicate the full stack locally—services, resources, and all—they can troubleshoot, experiment, and solve problems on their own terms. This tightens feedback loops, accelerates velocity, and empowers rapid iteration cycles that fuel discovery and innovation.

##  Today 

Right now, our local dev setup hinges on a shared remote Postgres database. That’s a workable starting point for small teams or startups, but it’s a ticking time bomb as we scale. Data consistency turns into a mess when multiple devs are working off the same database. Idempotent end-to-end tests? Nearly impossible with unpredictable, shared data. And schema changes—common in greenfield projects—become a slog, forcing devs to tiptoe around each other’s work instead of moving fast.

## Solution 

The fix? Replicate the entire stack locally with Docker and Docker Compose. By codifying a deployment manifest, we give devs a repeatable, portable setup that runs on MacOS, Windows, or Linux with just Docker installed (Docker Compose now comes bundled—no extra setup required). Fire up the , and in minutes, you’ve got a Bun API server and a Postgres database humming locally.  initialize schemas and seed data, so you’re not starting from scratch. After the first run, rebuilds take mere seconds. This hands devs a disposable, self-contained playground they can spin up, tweak, and tear down without breaking a sweat—or anyone else’s workflow. Need to tweak models or test a wild idea? Go for it. No more shared-resource bottlenecks slowing you down.

## Integration Test
But here’s where it gets really good: the . This gem spins up the Compose stack, pings the API at /status to confirm it’s alive, then unleashes the . What’s that mean in practice? Live API requests hitting a real server backed by a real Postgres instance—not mocks or simulations. Take the GET `/cars` route: it fires a SQL query to fetch all cars, giving you end-to-end validation with predictable, local data. This setup lets devs catch database bugs and query issues early, building features with confidence that they’re truly code-complete.

And it scales beyond your machine. Since it's Dockerized, this stack can run anywhere Docker does—even inside another container. That means we can plug it into CI/CD pipelines on platforms like [GitHub ARC](https://github.com/actions/actions-runner-controller), [Azure DevOps](https://azure.microsoft.com/en-us/services/devops/), or [Travis CI](https://travis-ci.org/). Automating these end-to-end tests in CI catches query and database problems long before they sneak into production. The result? Devs ship faster, with fewer surprises and no "it works on my machine" excuses. It's a clear, repeatable story that boosts product quality and keeps developers happy—because who doesn't love a system they can actually trust?

## Next Steps

The stack only includes the API service and postgres instance. We would want to next add in the redis servers and the zero sync layer. These are simple other resources in the system, and any resource is effectively a data source that can be replicated. As long as there is a docker container for it, it can be added to the stack, and build out a true replication of the platform. We would also want to build a similar solution for the job services.

## Conclusion

In conclusion, a robust local development stack is essential for engineering excellence. By containerizing our environment with Docker, we eliminate shared database issues, enable reliable testing, and create consistent experiences across our team. This approach accelerates onboarding, supports experimentation, and provides a foundation for integration testing. As we expand to include additional services like Redis and job processors, we'll create an increasingly faithful replica of production. This investment delivers immediate productivity gains while building the infrastructure needed to support our long-term growth and quality objectives.


