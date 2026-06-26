import fs from 'node:fs/promises'
import path from 'node:path'
import { pathToFileURL } from 'node:url'

const baseURL = process.env.DASHBOARD_FRONTEND_URL || 'http://127.0.0.1:3001'
const outDir = process.env.DASHBOARD_UI_OUT_DIR
const email = process.env.DASHBOARD_UI_EMAIL || 'round9-admin@example.test'
const dashboardCredential = process.env.DASHBOARD_UI_PASSWORD
const playwrightModulePath = process.env.PLAYWRIGHT_MODULE_PATH

if (!outDir) {
  throw new Error('DASHBOARD_UI_OUT_DIR is required')
}
if (!playwrightModulePath) {
  throw new Error('PLAYWRIGHT_MODULE_PATH is required')
}
if (!dashboardCredential) {
  throw new Error('DASHBOARD_UI_PASSWORD is required')
}

await fs.mkdir(outDir, { recursive: true })

const { chromium } = await import(pathToFileURL(playwrightModulePath).href)
const browser = await chromium.launch({ headless: true })
const page = await browser.newPage({ viewport: { width: 1280, height: 900 } })

try {
  const loginResponse = await page.request.post(`${baseURL}/api/auth/login`, {
    data: { email, password: dashboardCredential },
  })
  if (!loginResponse.ok()) {
    throw new Error(`login failed: HTTP ${loginResponse.status()} ${await loginResponse.text()}`)
  }
  const loginPayload = await loginResponse.json()
  if (!loginPayload.token) {
    throw new Error('login response did not include token')
  }
  await page.goto(baseURL, { waitUntil: 'networkidle' })
  await page.evaluate((token) => {
    window.localStorage.setItem('vsr_auth_token', token)
  }, loginPayload.token)

  await page.goto(`${baseURL}/config`, { waitUntil: 'networkidle' })
  await page.getByText('Global Config').first().waitFor({ timeout: 15000 })
  await page.getByText('Canonical Global Config').first().waitFor({ timeout: 15000 })
  await page.screenshot({ path: path.join(outDir, 'config-page-authenticated.png'), fullPage: true })

  await page.goto(`${baseURL}/playground`, { waitUntil: 'networkidle' })
  await page.getByPlaceholder('Ask me anything...').waitFor({ timeout: 15000 })
  await page.screenshot({ path: path.join(outDir, 'playground-page-authenticated.png'), fullPage: true })

  const result = {
    configURL: `${baseURL}/config`,
    playgroundURL: `${baseURL}/playground`,
    checks: [
      'dashboard auth API accepted bootstrap admin credentials',
      'config page rendered Global Config and Canonical Global Config',
      'playground page rendered chat input placeholder',
    ],
  }
  await fs.writeFile(path.join(outDir, 'ui-smoke-result.json'), JSON.stringify(result, null, 2) + '\n')
  console.log('dashboard_ui_smoke=PASS')
} catch (error) {
  await fs.writeFile(path.join(outDir, 'ui-smoke-debug-url.txt'), `${page.url()}\n`)
  await fs.writeFile(path.join(outDir, 'ui-smoke-debug-text.txt'), await page.locator('body').innerText().catch(() => ''))
  await page.screenshot({ path: path.join(outDir, 'ui-smoke-debug.png'), fullPage: true }).catch(() => {})
  throw error
} finally {
  await browser.close()
}
