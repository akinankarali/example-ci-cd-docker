# Use an official Node.js image as the base image
FROM node:18-alpine AS build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the Next.js app for production
RUN npm run build

# Use a smaller base image to serve the app
FROM node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built files from the previous stage
COPY --from=build /app ./

# Install only production dependencies
RUN npm install --only=production

# Expose the port the app will run on
EXPOSE 3000

# Set the default command to start the Next.js app
CMD ["npm", "run", "start"]