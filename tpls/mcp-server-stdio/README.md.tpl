# {{name}} MCP 服务器

{{description}}

这是一个基于TypeScript的MCP服务器，实现了一个简单的笔记系统。它通过以下功能演示了MCP的核心概念：

- 表示带有URI和元数据的文本笔记的资源
- 用于创建新笔记的工具
- 用于生成笔记摘要的提示

## 功能特性

### Resources
- 通过`note://`URI列出和访问笔记
- 每个笔记都有标题、内容和元数据
- 纯文本mime类型便于简单内容访问

### Tools
- `create_note` - 创建新的文本笔记
  - 需要标题和内容作为必填参数
  - 将笔记存储在服务器状态中

### Prompts
- `summarize_notes` - 生成所有存储笔记的摘要
  - 包含所有笔记内容作为嵌入资源
  - 返回结构化提示以供LLM进行摘要

## 开发

安装依赖：
```bash
npm install
```

构建服务器：
```bash
npm run build
```

开发时自动重新构建：
```bash
npm run watch
```



### 调试

由于MCP服务器通过stdio进行通信，调试可能具有挑战性。我们推荐使用[MCP Inspector](https://github.com/modelcontextprotocol/inspector)，它可以通过软件包脚本获得：

```bash
npm run inspector
```

Inspector将提供一个URL，让您可以在浏览器中访问调试工具。

### MCP 配置

```
{
  "mcpServers": {
    "{{pkgName}}": {
      "command": "npx",
      "args": ["-y", "{{pkgName}}"]
    }
  }
}
```