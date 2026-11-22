@echo off
title Starting HireAI Platform...
echo ====================================================
echo          Starting HireAI Full Platform...
echo ====================================================

:: 1. Start Backend on Port 8000
echo [1/3] Starting FastAPI Backend on Port 8000...
cd /d "c:\Users\HP\Desktop\resume app\backend"
start "HireAI Backend (Port 8000)" cmd /k ".\venv\Scripts\activate && uvicorn main:app --port 8000"

timeout /t 3 /nobreak >nul

:: 2. Start Frontend on Port 3000
echo [2/3] Starting Next.js Frontend on Port 3000...
cd /d "c:\Users\HP\Desktop\resume app\frontend"
start "HireAI Frontend (Port 3000)" cmd /k "npm run dev"

timeout /t 5 /nobreak >nul

:: 3. Open Browser Automatically
echo [3/3] Opening HireAI in browser...
start http://localhost:3000

echo ====================================================
echo    HireAI is LIVE! Enjoy testing with your team!
echo ====================================================
