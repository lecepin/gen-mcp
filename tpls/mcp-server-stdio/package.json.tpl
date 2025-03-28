{
  "name": "{{pkgName}}",
  "version": "0.1.0",
  "description": "{{description}}",
  "private": true,
  "type": "module",
  "bin": {
    "{{pkgName}}": "./build/index.js"
  },
  "files": [
    "build"
  ],
  "type": "module",
  "scripts": {
    "build": "tsc && node -e \"require('fs').chmodSync('build/index.js', '755')\"",
    "prepare": "npm run build",
    "watch": "tsc --watch",
    "inspector": "npx -y @modelcontextprotocol/inspector build/index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "1.8.0",
    "zod": "^3.24.2"
  },
  "devDependencies": {
    "@types/node": "^20.11.24",
    "typescript": "^5.3.3"
  }
}
