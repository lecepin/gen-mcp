# {{name}}

这是一个基于 Model Context Protocol (MCP) 使用 SSE (Server-Sent Events) 传输的服务器示例。

## 功能

这个服务器实现了一个简单的笔记系统，具有以下功能：

- 将笔记列为资源
- 读取单个笔记
- 通过工具创建新笔记
- 通过提示(prompt)汇总所有笔记

## 安装

```bash
npm install
```

## 构建

```bash
npm run build
```

## 运行

```bash
npm start
```

服务器将在 http://localhost:3001 上运行。

## 开发

启动开发模式（自动监视文件变化并重启服务器）：

```bash
npm run dev
```

## 测试

使用 MCP Inspector 测试服务器：

```bash
npm run inspector
```

或者直接使用：

```bash
npx -y @modelcontextprotocol/inspector
```

## 连接到 Claude

1. 确保服务器正在运行
2. 在 Claude 应用程序中配置此服务器：
   - 设置名称（如 "notes-server"）
   - URL: http://localhost:3001
   - 点击"保存"

现在您可以在 Claude 中使用服务器提供的资源、工具和提示。 

### MCP 配置

```
{
  "mcpServers": {
    "{{pkgName}}": {
      "type": "url",
      "url": "http://localhost:3001/sse"
    }
  }
}
```