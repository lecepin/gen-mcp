{
  "name": "{{pkgName}}",
  "version": "0.1.0",
  "description": "{{description}}",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "tsc",
    "prepare": "npm run build",
    "watch": "tsc --watch",
    "start": "node build/index.js",
    "dev": "nodemon --exec 'npm run build && npm start' --watch src --ext ts",
    "inspector": "npx -y @modelcontextprotocol/inspector"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "1.8.0",
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "zod": "^3.24.2"
  },
  "devDependencies": {
    "@types/cors": "^2.8.16",
    "@types/express": "^4.17.21",
    "@types/node": "^20.11.24",
    "nodemon": "^3.0.1",
    "typescript": "^5.3.3"
  }
} 