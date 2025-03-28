在上一篇文章《快速开发一个 MCP 服务，增强你的 AI Agent》中，我们讨论了如何开发 MCP 服务来增强 AI Agent 的能力。但是，我注意到社区中缺乏一个好用的 MCP 脚手架工具，许多现有的工具要么不完善，要么已经停止维护。

为了解决这个问题，我开发了一个简单易用的 MCP CLI 工具：`gen-mcp`，它可以帮助开发者快速创建 MCP 服务项目，尤其对 TypeScript 用户更加友好。

## 为什么需要这个工具？

开发 MCP 服务时常常面临以下问题：

1. 项目结构搭建繁琐
2. 配置 TypeScript 环境需要额外工作
3. 不同传输协议（如 SSE 和 Stdio）的实现方式不同
4. 缺乏最佳实践的参考

`gen-mcp`正是为解决这些问题而生。

## 工具特点

- 支持两种主流传输方式：SSE 和 Stdio
- 提供完整的 TypeScript 支持
- 内置笔记应用示例，展示资源、工具和提示的使用
- 简单直观的命令行交互

## 快速上手

### 安装

```bash
# 全局安装
npm install -g gen-mcp

# 或者直接使用 npx
npx gen-mcp
```

<img width="496" alt="image" src="https://github.com/user-attachments/assets/84cb088e-8b7c-410d-baae-aa1bd5cb265d" />


### 创建项目

安装后，只需运行以下命令：

```bash
red-mcp
# 或
mcp
# 或
npx gen-mcp
```

按照交互提示：

1. 选择模板（Stdio 或 SSE 传输）
2. 指定安装路径
3. 输入包名

然后，工具会自动为你创建项目，并提供后续步骤的指引。

## 模板介绍

### MCP Server - Stdio 传输

这个模板适合开发命令行工具集成的 MCP 服务，比如与 Claude CLI 集成。

主要特点：

- 通过标准输入/输出流通信
- 适合开发命令行工具
- 可以通过`npm link`快速全局安装进行测试

### MCP Server - SSE 传输

这个模板适合开发 Web 应用集成的 MCP 服务，比如与网页版 Claude 集成。

主要特点：

- 使用 Server-Sent Events 进行通信
- 内置 Express 服务器
- 支持 CORS，方便前端集成
- 提供开发模式自动重启

### 调试与配置

开发 MCP 服务时，调试和配置是两个关键环节。我们的模板提供了完善的支持：

#### 调试功能

1. **MCP Inspector 集成**：每个模板都可以通过以下命令启动调试:

   ```bash
   npm run inspector
   ```

   Inspector 提供了直观的界面，可以实时查看资源、工具调用和提示的执行情况。

2. **开发模式监控**：SSE 模板内置了开发模式，会监听文件变化并自动重启服务:
   ```bash
   npm run dev
   ```

#### 配置 MCP 服务

将您开发的 MCP 服务添加非常简单：

1. **Cursor 集成**：

   - 在 Cursor 中使用时，可以通过右侧栏"连接"面板添加自定义 MCP 服务
   - 位置：`~/.cursor/mcp.json`
   - 输入服务名称和 URL（对于 SSE 模板）
   - 对于 Stdio 模板，可配置命令路径

2. **Claude 集成**：

- 同上
- 位置：`~/Library/Application Support/Claude/claude_desktop_config.json`

Cli 模式：

```
{
  "mcpServers": {
    "server-name": {
      "command": "npx",
      "args": ["-y", "mcp-server"],
      "env": {
        "API_KEY": "value"
      }
    }
  }
}
```

SSE 模式：

```
{
  "mcpServers": {
    "server-name": {
      "url": "http://localhost:3000/sse",
      "env": {
        "API_KEY": "value"
      }
    }
  }
}
```

## 示例应用：笔记系统

两个模板都内置了一个简单的笔记系统示例，展示了 MCP 的三大核心功能：

1. **资源(Resources)**：通过`note:///{id}`URI 访问笔记
2. **工具(Tools)**：`create_note`工具用于创建新笔记
3. **提示(Prompts)**：`summarize_notes`用于生成所有笔记的摘要

这个示例不仅展示了 MCP 的基本用法，也为你自己的项目提供了参考架构。

## 注意

如果出现报错，可能是由于 nvm 等多版本管理工具导致 node 找不到。可以 `which node` 后，修改 `index.js` 的 shebang。
