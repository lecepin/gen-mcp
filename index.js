#!/usr/bin/env node

import { echo, fetch, fs, chalk, $, question, path } from "zx";
import semver from "semver";
import inquirer from "inquirer";
import Say from "cfonts";
import tpls from "./tpls/tpls.js";
import { copyDirectory, getGitInfo, initGit, getDirname } from "./tpls/util.js";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

async function greeting(currentPackageJson) {
  Say.say("red-mcp", {
    colors: ["#ff2e4d", "cyan"],
  });
  echo`${chalk.hex("#0f0")("版本: " + currentPackageJson.version)}`;
  echo``;
}

async function checkForUpdates(currentPackageJson) {
  const currentVersion = currentPackageJson.version;
  const response = await fetch(
    "https://registry.npmjs.org/gen-pkg"
  );
  const latestVersionInfo = await response.json();
  const latestVersion = latestVersionInfo["dist-tags"].latest;

  if (0 && semver.lt(currentVersion, latestVersion)) {
    echo`${chalk.yellow("发现新版本")}: ${currentVersion} -> ${chalk.yellow(
      latestVersion
    )}`;
    echo`执行: ${chalk.green(
      `npm install -g ${currentPackageJson.name}@latest`
    )} 进行更新`;

    process.exit(1);
  }
}

async function selectTpl(tpls) {
  const { tpl } = await inquirer.prompt([
    {
      type: "list",
      name: "tpl",
      message: "选择模板:",
      choices: tpls.map((tpl) => tpl.title),
    },
  ]);
  const { name } = tpls.find((item) => item.title === tpl);

  return name;
}

async function selectInstallPath() {
  const dirPath = (await question("请输入安装路径: (默认当前目录 ./)")) || "./";
  return path.resolve(dirPath);
}

async function getPkgName() {
  let pkgName;

  while (!pkgName) {
    pkgName = await question("请输入包名: ");
  }

  return pkgName.trim();
}

async function installTpl(tplName, installPath, pkgName) {
  const { username, email } = await getGitInfo();
  
  // 获取模板对象，用于读取commands
  const tplObj = tpls.find(tpl => tpl.name === tplName);

  await copyDirectory({
    path: path.join(__dirname, "tpls", tplName),
    target: installPath,
    context: {
      author:
        email && username
          ? `${username} <${email}>`.replace(/\s+/g, "").trim()
          : "",
      pkgName,
      name: pkgName.split("/")[1],
      description: "A Model Context Protocol server",
    },
  });

  await initGit(installPath);
  
  // 构建命令提示信息
  const commandsText = tplObj.commands 
    ? tplObj.commands.map(cmd => chalk.green(cmd)).join('\n')
    : chalk.green("npm install\nnpm run build");
    
  echo`
${chalk.green.bold("安装成功")}

请执行:
${chalk.green(`cd ${installPath}`)}
${commandsText}
`;
}

async function main() {
  $.verbose = false;
  const currentPackageJson = JSON.parse(
    await fs.readFile(path.join(__dirname, "package.json"), "utf8")
  );

  await greeting(currentPackageJson);
  try {
    await checkForUpdates(currentPackageJson);
  } catch (error) {}
  const tplName = await selectTpl(tpls);
  const installPath = await selectInstallPath();
  const pkgName = await getPkgName();
  await installTpl(tplName, installPath, pkgName);
}

main().catch((err) => {
  console.error(err);
});
