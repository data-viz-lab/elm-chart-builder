const puppeteer = require("puppeteer");

const fs = require("fs");
const path = require("path");

const getAllFiles = (dirPath, arrayOfFiles = []) => {
  files = fs.readdirSync(dirPath);

  files.forEach(function (file) {
    if (
      fs.statSync(dirPath + "/" + file).isDirectory() &&
      file !== "elm-stuff"
    ) {
      arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles);
    } else if (file.endsWith(".elm") && file !== "Data.elm") {
      arrayOfFiles.push(path.join(__dirname, dirPath, "/", file));
    }
  });

  return arrayOfFiles;
};

const replacer = __dirname.replace("screenshot-tests", "examples/");
const allFiles = getAllFiles("../examples").map((f) => f.replace(replacer, ""));
console.log(allFiles);

const buildScreenshots = async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setViewport({
    width: 1600,
    height: 900,
    deviceScaleFactor: 1,
  });

  for (var i = 0, len = allFiles.length - 1; i < len; i++) {
    const png = allFiles[i].replace(".elm", ".png").replace("/", "--");
    await page.goto("http://localhost:8000/" + allFiles[i]);
    await page.screenshot({ path: "images/" + png });
  }

  await browser.close();
};

buildScreenshots();
