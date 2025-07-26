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
  // Core files
  'package.json',
  'README.md',
  'README_ko.md',
  'LICENSE',
  
  // CLI entry point
  'bin/make-ios.js',
  
  // Main setup script
  'setup.sh',
  
  // Scripts directory
  'scripts/generate_project.sh',
  'scripts/update_dependencies.sh',
  'scripts/install_tuist.sh',
  
  // Templates - SwiftUI
  'templates/SwiftUI/AppDelegate.swift',
  'templates/SwiftUI/SceneDelegate.swift',
  'templates/SwiftUI/ContentView.swift',
  
  // Templates - UIKit
  'templates/UIKit/AppDelegate.swift',
  'templates/UIKit/SceneDelegate.swift',
  'templates/UIKit/ViewControllers/HomeViewController.swift',
  'templates/UIKit/ViewControllers/MoreViewController.swift',
  
  // Templates - Common resources
  'templates/common/Assets.xcassets/Contents.json',
  'templates/common/Assets.xcassets/AppIcon.appiconset/Contents.json',
  'templates/common/Assets.xcassets/AppIcon-Debug.appiconset/Contents.json',
  'templates/plist/Info-Debug.plist',
  'templates/plist/Info-Release.plist',
  'templates/storyboard/LaunchScreen.storyboard',
  
  // Tuist configuration
  'tuist/Project.swift',
  'tuist/Tuist.swift',
  'tuist/Tuist/Config.swift',
  'tuist/Configurations/Debug.xcconfig',
  'tuist/Configurations/Release.xcconfig'
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