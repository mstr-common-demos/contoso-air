# Use the official Node.js 22 Alpine image for a smaller footprint
FROM node:22-alpine

# Set working directory
WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S contosoair -u 1001

# Copy the entire web application including node_modules
COPY src/web/ ./

# Change ownership to non-root user
RUN chown -R contosoair:nodejs /app
USER contosoair

# Expose port 3000
EXPOSE 3000

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) }).on('error', () => { process.exit(1) })"

# Start the application
CMD ["npm", "start"]