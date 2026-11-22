# 🚀 HireAI — Complete Setup Guide

## ✅ Kya Ban Gaya

| File/Folder | Status |
|---|---|
| `frontend/` — Next.js App | ✅ Ready |
| `frontend/app/page.tsx` — Landing Page | ✅ Done |
| `frontend/app/auth/login/` — Login | ✅ Done |
| `frontend/app/auth/register/` — Register | ✅ Done |
| `frontend/app/employer/dashboard/` — Employer Dashboard | ✅ Done |
| `frontend/app/employer/jobs/new/` — Job Posting | ✅ Done |
| `frontend/app/candidate/dashboard/` — Resume Upload | ✅ Done |
| `frontend/app/candidate/interview/[id]/` — AI Interview | ✅ Done |
| `frontend/app/candidate/results/[id]/` — Results + Charts | ✅ Done |
| `backend/` — FastAPI Backend | ✅ Ready |
| `backend/main.py` — API Server | ✅ Done |
| `backend/services/gemini_service.py` — AI Service | ✅ Done |
| `backend/services/resume_parser.py` — PDF/DOCX Parser | ✅ Done |
| `backend/routers/auth.py` — Auth API | ✅ Done |
| `backend/routers/jobs.py` — Jobs API | ✅ Done |
| `backend/routers/resumes.py` — Resume API | ✅ Done |
| `backend/routers/interviews.py` — Interview API | ✅ Done |
| `supabase_schema.sql` — Database Schema | ✅ Done |

---

## 🗄️ Step 1 — Supabase Setup (5 min)

1. **supabase.com** pe jao → Sign up / Login
2. **New Project** banao → Name: `hireai`
3. Project create hone ke baad:
   - **SQL Editor** pe click karo
   - `supabase_schema.sql` file ka content copy-paste karo
   - **Run** karo → Saari tables ban jayengi

4. **Settings → API** pe jao aur ye values copy karo:
   - `Project URL` → ye hai tumhara `SUPABASE_URL`
   - `anon public` key → ye hai `SUPABASE_ANON_KEY`
   - `service_role` key → ye hai `SUPABASE_SERVICE_KEY`

---

## 📝 Step 2 — Environment Variables Fill Karo

### Frontend — `frontend/.env.local`
```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJ...
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Backend — `backend/.env`
```
GEMINI_API_KEY=AIzaSyAQ....(tumhari key already hai)
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_SERVICE_KEY=eyJ...(service_role key)
SECRET_KEY=any-random-long-string-here
```

---

## ▶️ Step 3 — App Run Karo

### Frontend (Terminal 1):
```powershell
cd "c:\Users\HP\Desktop\resume app\frontend"
npm run dev
```
→ Opens at **http://localhost:3000**

### Backend (Terminal 2):
```powershell
cd "c:\Users\HP\Desktop\resume app\backend"
.\venv\Scripts\uvicorn main:app --reload --port 8000
```
→ API at **http://localhost:8000**
→ Swagger docs at **http://localhost:8000/docs**

---

## 🌐 Step 4 — Deploy Karo (Free)

### Frontend → Vercel

1. [github.com](https://github.com) pe account banao
2. New repo banao: `hireai`
3. `frontend/` folder ka code push karo
4. [vercel.com](https://vercel.com) → GitHub se login → Import repo
5. Environment variables add karo (same as `.env.local`)
6. Deploy! → URL milega: `hireai.vercel.app`

### Backend → Google Cloud Run

1. [console.cloud.google.com](https://console.cloud.google.com) pe jao
2. New project banao
3. Cloud Run enable karo
4. `backend/` folder se Docker image build karo:
```bash
gcloud builds submit --tag gcr.io/PROJECT_ID/hireai-api
gcloud run deploy hireai-api --image gcr.io/PROJECT_ID/hireai-api --platform managed
```
5. Environment variables add karo Cloud Run console mein

---

## 🔗 Supabase Auth — Google Login Enable Karo

1. Supabase Dashboard → **Authentication → Providers**
2. **Google** enable karo
3. Google Cloud Console se OAuth credentials banao
4. Client ID aur Secret add karo

---

## 📱 App Features Summary

| Feature | Status |
|---|---|
| 🏠 Landing Page (Animated Flow) | ✅ |
| 🔐 Login / Register (Google + Email) | ✅ |
| 🏢 Employer Dashboard | ✅ |
| 💼 Job Posting Form | ✅ |
| 📄 Resume Upload (Drag & Drop) | ✅ |
| 🤖 AI Resume Parsing (Gemini Flash) | ✅ |
| 🔍 AI Job Matching (Gemini Pro) | ✅ |
| 🎤 AI Interview (Voice + Text) | ✅ |
| ⏱️ Circular Countdown Timer | ✅ |
| 📊 Results + Radar Chart | ✅ |
| 🏆 Animated Score Bars | ✅ |
| 🎉 Confetti on Completion | ✅ |
| 🌙 Dark/Light Mode | ✅ |
| ♿ Reduce Motion Accessibility | ✅ |

---

> **Total Cost = ₹0** 🎉 Sab kuch free!
