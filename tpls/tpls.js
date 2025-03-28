export default [
  {
    title: "MCP Server - Stdio 传输",
    name: "mcp-server-stdio",
    commands: [
      "npm i",
      "npm run build  # 或者: npm run watch",
      "npm link       # 可选，使其全局可用",
    ],
  },
  {
    title: "MCP Server - SSE 传输",
    name: "mcp-server-sse",
    commands: [
      "npm i",
      "npm run dev  # 或者: npm run build && npm start",
    ],
  },
];
