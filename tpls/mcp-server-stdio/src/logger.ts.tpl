import { createLogger, format, transports, Logger, transport } from 'winston';
import path from 'path';
import fs from 'fs';

export type LoggerType = 'console' | 'file';

export interface LoggerOptions {
  type?: LoggerType;
  level?: string;
  filename?: string; // 仅 file 模式下有效
}

/**
 * 根据参数创建 logger，自动切换 console/file 输出
 */
export function createLoggerByType(options: LoggerOptions = {}): Logger {
  const { type = 'console', level = 'info', filename } = options;
  const loggerTransports: transport[] = [];

  if (type === 'file') {
    // 默认日志路径 logs/combined.log，自动创建 logs 目录
    const defaultPath = path.resolve(process.cwd(), 'logs', 'combined.log');
    const filePath = filename || defaultPath;
    const logDir = path.dirname(filePath);
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    loggerTransports.push(
      new transports.File({
        filename: filePath,
        level,
        format: format.combine(
          format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
          format.printf(info => `${info.timestamp} [${info.level}] ${info.message}`)
        ),
      })
    );
  } else {
    loggerTransports.push(
      new transports.Console({
        level,
        format: format.combine(
          format.colorize(),
          format.timestamp({ format: 'HH:mm:ss' }),
          format.printf(info => `${info.timestamp} [${info.level}] ${info.message}`)
        ),
      })
    );
  }

  return createLogger({
    level,
    transports: loggerTransports,
    defaultMeta: { service: 'your-service-name' },
  });
}
