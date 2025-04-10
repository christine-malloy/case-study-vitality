# Build stage
FROM oven/bun:1 AS builder

WORKDIR /app

# Copy only the API files
COPY api/package.json api/bun.lock ./
COPY api/index.ts api/db.ts ./

# Install dependencies
RUN bun install --frozen-lockfile

# Production stage
FROM oven/bun:1-slim AS runner

WORKDIR /app

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3001

# Copy necessary files from builder
COPY --from=builder /app/package.json .
COPY --from=builder /app/bun.lock .
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/*.ts .
COPY --from=builder /app/**/*.ts .

# Expose the port
EXPOSE 3001

# Start the application
CMD ["bun", "run", "index.ts"] 