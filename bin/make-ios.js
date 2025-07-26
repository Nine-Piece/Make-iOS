#!/usr/bin/env node

import { program } from 'commander';
import { execa } from 'execa';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs-extra';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const packageRoot = path.resolve(__dirname, '..');

// Version from package.json
const packageJson = JSON.parse(fs.readFileSync(path.join(packageRoot, 'package.json'), 'utf8'));

program
  .name('make-ios')
  .description('Create a new iOS app with Tuist')
  .version(packageJson.version)
  .argument('[project-name]', 'Name of your iOS project')
  .action(async (projectName) => {
    console.log('🚀 iOS App Generator\n');
    
    // Store current working directory (where user executed the command)
    const currentDir = process.cwd();
    
    // Set project name as environment variable if provided
    if (projectName) {
      process.env.AUTO_PROJECT_NAME = projectName;
    }
    
    // Set the target directory where project should be created
    process.env.TARGET_DIR = currentDir;
    
    try {
      // Execute setup.sh from package directory but create project in current directory
      await execa(path.join(packageRoot, 'setup.sh'), [], { 
        stdio: 'inherit',
        cwd: packageRoot,
        env: process.env
      });
    } catch (error) {
      console.error('Installation failed:', error.message);
      process.exit(1);
    }
  });

program.parse();