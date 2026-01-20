#!/usr/bin/env node
const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

const client = new Client({
  host: 'localhost',
  port: 5432,
  user: 'backstage',
  password: 'backstage123',
  database: 'backstage'
});

async function initDB() {
  await client.connect();
  await client.query(`
    CREATE TABLE IF NOT EXISTS config_backup (
      id SERIAL PRIMARY KEY,
      config_data TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `);
}

async function saveConfig() {
  const envPath = path.join(__dirname, 'infra-ai-backstage/.env');
  const envContent = fs.readFileSync(envPath, 'utf8');
  
  await client.query(
    'INSERT INTO config_backup (config_data) VALUES ($1)',
    [envContent]
  );
  console.log('✅ Configuración guardada en DB');
}

async function restoreConfig() {
  const result = await client.query(
    'SELECT config_data FROM config_backup ORDER BY created_at DESC LIMIT 1'
  );
  
  if (result.rows.length === 0) {
    console.log('❌ No hay configuración guardada');
    return;
  }
  
  const envPath = path.join(__dirname, 'infra-ai-backstage/.env');
  fs.writeFileSync(envPath, result.rows[0].config_data);
  console.log('✅ Configuración restaurada desde DB');
}

async function main() {
  const action = process.argv[2];
  
  try {
    await initDB();
    
    if (action === 'save') {
      await saveConfig();
    } else if (action === 'restore') {
      await restoreConfig();
    } else {
      console.log('Uso: node config-manager.js [save|restore]');
    }
  } catch (error) {
    console.error('Error:', error.message);
  } finally {
    await client.end();
  }
}

main();
