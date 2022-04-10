const puppeteer = require("puppeteer");
const fs = require("fs");
const path = require("path");
const PNG = require("pngjs").PNG;
const pixelmatch = require("pixelmatch");

const args = process.argv.slice(2);

//These contain external data that take time to load and that can change, so
//excluding from the screenshot tests.
const exclude = ["CoronavirusDeaths.elm"];

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

    if (fs.existsSync(`images/${prevName}`)) {
      const current = PNG.sync.read(fs.readFileSync(`images/${currentName}`));
      const prev = PNG.sync.read(fs.readFileSync(`images/${prevName}`));
      const { width, height } = prev;
      const diff = new PNG({ width, height });

      const zz = pixelmatch(prev.data, current.data, diff.data, width, height, {
        threshold: 0.1,
      });

      if (zz !== 0) {
        console.warn(
          `Page ${allFiles[i]} has changed! Check the diffs folder for details.`
        );
        problems = true;
        fs.writeFileSync(`diffs/${diffName}`, PNG.sync.write(diff));
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
    if (exclude.some((x) => allFiles[i] === x)) {
      continue;
    }

    const pngName = allFiles[i].replace(".elm", ".png").replace("/", "--");
    const currentName = pngName.replace(".", "--current.");
    const prevName = pngName.replace(".", "--prev.");
    const diffName = pngName.replace(".", "--diff.");

    if (args[0] === "--reset") {
      const current = `images/${currentName}`;
      const prev = `images/${prevName}`;
      const diff = `diffs/${diffName}`;
      fs.existsSync(current) &&
        fs.unlink(current, (err) => err && console.log("ERROR: " + err));
      fs.existsSync(prev) &&
        fs.unlink(prev, (err) => err && console.log("ERROR: " + err));
      fs.existsSync(diff) &&
        fs.unlink(diff, (err) => err && console.log("ERROR: " + err));
    } else {
      if (
        fs.existsSync(`images/${currentName}`) ||
        (fs.existsSync(`images/${currentName}`) &&
          !fs.existsSync(`images/${prevName}`))
      ) {
        const current = `images/${currentName}`;
        const prev = `images/${prevName}`;
        fs.rename(current, prev, (err) => err && console.log("ERROR: " + err));
      }
    }
    await page.goto("http://localhost:8000/" + allFiles[i]);
    await page.screenshot({ path: `images/${currentName}` });
  }
  await browser.close();
  await compareImages();
};

buildScreenshots();
