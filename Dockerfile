# ---- Stage 1: Build with Bun ----
FROM oven/bun:latest AS build

WORKDIR /app

# Copy project files
COPY . .

# Create .env.local with your API keys
RUN echo "VITE_DEBUG_URL=\"\"\n\
VITE_APP_ID=22665066\n\
VITE_APP_HASH=\"92dbe89d182f72f427972d8993850130\"" > .env.local

# Install dependencies and build
RUN bun install
RUN bun run build

# ---- Stage 2: Serve with Nginx ----
FROM nginx:alpine

# Remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy built dist from Bun build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
