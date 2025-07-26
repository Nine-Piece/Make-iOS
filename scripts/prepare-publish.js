#!/usr/bin/env node

import fs from 'fs-extra';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '..');

console.log('Preparing for npm publish...');

// Check if all required files exist
const requiredFiles = [
  'package.json',
  'README.md',
  'README_ko.md',
  'LICENSE',
  'bin/make-ios.js',
  'templates/SwiftUI/AppDelegate.swift',
  'templates/UIKit/AppDelegate.swift',
  'tuist/Project.swift'
];

let hasErrors = false;

for (const file of requiredFiles) {
  const filePath = path.join(rootDir, file);
  if (!fs.existsSync(filePath)) {
    console.error(`❌ Missing required file: ${file}`);
    hasErrors = true;
  } else {
    console.log(`✅ ${file}`);
  }
}

if (hasErrors) {
  console.error('\n❌ Some required files are missing. Please check and try again.');
  process.exit(1);
}

// Note: GitHub URLs are already set to nine-piece/make-ios
// No need to replace URLs during npm publish

console.log('\n✨ Package is ready for publishing!');
console.log('\nTo publish:');
console.log('  npm login');
console.log('  npm publish');
console.log('\nAfter publishing, users can create iOS apps with:');
console.log('  npx make-ios my-app');
console.log('  npm init ios-app my-app');
console.log('  yarn create ios-app my-app');
console.log('  pnpm create ios-app my-app');