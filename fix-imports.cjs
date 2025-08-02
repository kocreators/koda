const fs = require('fs');
const path = require('path');

const directory = './src'; // change this to your source folder

function processFile(filePath) {
  let content = fs.readFileSync(filePath, 'utf8');

  // Regex to find import from 'package@version' or "package@version"
  // It will capture the version part and remove it
  const fixed = content.replace(
    /(['"])(@?[\w\-\/]+)@[\d\.]+(\.[\d\.]+)?\1/g,
    (match, quote, pkg) => `${quote}${pkg}${quote}`
  );

  if (fixed !== content) {
    fs.writeFileSync(filePath, fixed, 'utf8');
    console.log(`Fixed imports in: ${filePath}`);
  }
}

function walk(dir) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);
    if (stat.isDirectory()) {
      walk(fullPath);
    } else if (fullPath.endsWith('.ts') || fullPath.endsWith('.tsx') || fullPath.endsWith('.js') || fullPath.endsWith('.jsx')) {
      processFile(fullPath);
    }
  }
}

walk(directory);
