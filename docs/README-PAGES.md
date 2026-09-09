# 🌐 GitHub Pages Deployment Guide

Your professional portfolio website is built inside the `docs/` directory of your repository. GitHub Pages supports serving static websites directly from the `/docs` folder or via GitHub Actions.

---

## ⚡ Option 1: Direct GitHub Pages Setup (Recommended - 1 Minute)

1. Push your repository changes to GitHub:
   ```bash
   git add docs/ .github/workflows/deploy-pages.yml
   git commit -m "Add GitHub Pages professional portfolio website"
   git push origin main
   ```

2. Open your repository on GitHub:
   `https://github.com/jibinmathew/devAssist`

3. Click on **Settings** (top menu tab of your repository).

4. Scroll down to **Pages** in the left sidebar menu (under *Code and automation*).

5. Under **Build and deployment**:
   - **Source**: Select `Deploy from a branch`
   - **Branch**: Select `main` and choose folder `/docs`
   - Click **Save**.

6. Within 60 seconds, your website will be live at:
   👉 **`https://jibinmathew.github.io/devAssist/`**

---

## 🚀 Option 2: Automated Deployment via GitHub Actions Workflow

An automated deployment pipeline is included at `.github/workflows/deploy-pages.yml`.

1. In GitHub Repository Settings -> **Pages**:
   - Change **Source** to **`GitHub Actions`**.
2. Every time you push to `main`, GitHub Actions will automatically deploy your latest site updates.

---

## 🎨 Local Preview Instructions

You can preview the site locally anytime by opening `docs/index.html` directly in your web browser:
```bash
open docs/index.html
```
or running a local dev server:
```bash
npx serve docs
```
