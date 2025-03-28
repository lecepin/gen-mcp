import express from "express";
import {
  McpServer,
  ResourceTemplate,
} from "@modelcontextprotocol/sdk/server/mcp.js";
import { SSEServerTransport } from "@modelcontextprotocol/sdk/server/sse.js";
import { z } from "zod";
import cors from "cors";


/**
 * 笔记对象的类型别名
 */
type Note = { title: string; content: string };

/**
 * 笔记的简单内存存储。
 * 在实际实现中，这可能会由数据库支持。
 */
const notes: { [id: string]: Note } = {
  "1": { title: "第一条笔记", content: "这是第一条笔记" },
  "2": { title: "第二条笔记", content: "这是第二条笔记" },
};

/**
 * 创建MCP服务器，具有资源（用于列出/读取笔记）、
 * 工具（用于创建新笔记）和提示（用于汇总笔记）的功能。
 */
const server = new McpServer({
  name: "{{name}}",
  version: "1.0.0",
});

/**
 * 注册笔记资源
 * 使用ResourceTemplate来定义资源URI模式和列出/读取笔记
 */
server.resource(
  "notes",
  new ResourceTemplate("note:///{id}", {
    // 列出所有笔记资源
    list: async () => ({
      resources: Object.entries(notes).map(([id, note]) => ({
        uri: `note:///${id}`,
        mimeType: "text/plain",
        name: note.title,
        description: `A text note: ${note.title}`,
      })),
    }),
  }),
  // 读取指定笔记内容
  async (uri, params) => {
    const id = params.id as string;
    const note = notes[id];
    if (!note) {
      throw new Error(`笔记 ${id} 未找到`);
    }

    return {
      contents: [
        {
          uri: uri.href,
          mimeType: "text/plain",
          text: note.content,
        },
      ],
    };
  }
);

/**
 * 注册创建笔记工具
 * 使用zod进行参数验证
 */
server.tool(
  "create_note",
  {
    title: z.string().describe("Title of the note"),
    content: z.string().describe("Text content of the note"),
  },
  async ({ title, content }) => {
    const id = String(Object.keys(notes).length + 1);
    notes[id] = { title, content };

    return {
      content: [
        {
          type: "text",
          text: `已创建笔记 ${id}: ${title}`,
        },
      ],
    };
  }
);

/**
 * 注册笔记摘要提示
 */
server.prompt("summarize_notes", {}, async () => {
  const noteResources = Object.entries(notes).map(([id, note]) => ({
    role: "user" as const,
    content: {
      type: "resource" as const,
      resource: {
        uri: `note:///${id}`,
        mimeType: "text/plain",
        text: note.content,
      },
    },
  }));

  return {
    messages: [
      {
        role: "user",
        content: {
          type: "text",
          text: "请汇总以下笔记：",
        },
      },
      ...noteResources,
      {
        role: "user",
        content: {
          type: "text",
          text: "请提供以上所有笔记的简明摘要。",
        },
      },
    ],
  };
});

const app = express();

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "OPTIONS"],
    credentials: false,
  })
);

let transport: SSEServerTransport;

app.get("/sse", async (req, res) => {
  transport = new SSEServerTransport("/messages", res);
  await server.connect(transport);
});

app.post("/messages", async (req, res) => {
  await transport.handlePostMessage(req, res);
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`MCP SSE Server running on port ${PORT}`);
});
