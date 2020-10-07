const puppeteer = require("puppeteer");
const fs = require("fs");
const path = require("path");
const PNG = require("pngjs").PNG;
const pixelmatch = require("pixelmatch");

const args = process.argv.slice(2);

let problems = false;

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

const compareImages = () => {
  for (var i = 0, len = allFiles.length - 1; i < len; i++) {
    const pngName = allFiles[i].replace(".elm", ".png").replace("/", "--");
    const currentName = pngName.replace(".", "--current.");
    const prevName = pngName.replace(".", "--prev.");
    const diffName = pngName.replace(".", "--diff.");

    if (fs.existsSync("images/" + prevName)) {
      const current = PNG.sync.read(fs.readFileSync("images/" + currentName));
      const prev = PNG.sync.read(fs.readFileSync("images/" + prevName));
      const { width, height } = prev;
      const diff = new PNG({ width, height });

      const zz = pixelmatch(prev.data, current.data, diff.data, width, height, {
        threshold: 0.1,
      });

      if (zz !== 0) {
        console.warn(`Page ${allFiles[i]} has changed!`);
        problems = true;
      }
    }
  }

  if (!problems) {
    console.warn("All pages are good");
  }
};

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

    const current = png.replace(".", "--current.");
    const prev = png.replace(".", "--prev.");

    if (
      (fs.existsSync("images/" + current) && args[0] === "--reset") ||
      (fs.existsSync("images/" + current) && !fs.existsSync("images/" + prev))
    ) {
      // rename the existing screenshots
      fs.rename("images/" + current, "images/" + prev, (err) => {
        if (err) console.log("ERROR: " + err);
      });
    }

    await page.goto("http://localhost:8000/" + allFiles[i]);
    await page.screenshot({ path: "images/" + current });
  }

  await browser.close();

  await compareImages();
};

buildScreenshots();
