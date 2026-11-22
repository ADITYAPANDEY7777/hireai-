-- HireAI Database Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table (extends Supabase auth.users)
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  role TEXT CHECK (role IN ('employer', 'candidate', 'admin')) DEFAULT 'candidate',
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Companies table
CREATE TABLE IF NOT EXISTS companies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employer_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  logo_url TEXT,
  website TEXT,
  industry TEXT,
  size TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Jobs table
CREATE TABLE IF NOT EXISTS jobs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  employer_id UUID REFERENCES users(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id),
  title TEXT NOT NULL,
  description TEXT,
  requirements TEXT,
  location TEXT,
  job_type TEXT DEFAULT 'Full-time',
  experience_level TEXT,
  salary_min INTEGER DEFAULT 0,
  salary_max INTEGER DEFAULT 0,
  skills TEXT[] DEFAULT '{}',
  status TEXT CHECK (status IN ('active', 'closed', 'draft')) DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Candidates table
CREATE TABLE IF NOT EXISTS candidates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
  resume_url TEXT,
  title TEXT,
  location TEXT,
  experience_years INTEGER DEFAULT 0,
  skills TEXT[] DEFAULT '{}',
  parsed_data JSONB DEFAULT '{}',
  linkedin_url TEXT,
  portfolio_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Applications table
CREATE TABLE IF NOT EXISTS applications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
  candidate_id UUID REFERENCES users(id) ON DELETE CASCADE,
  match_score FLOAT DEFAULT 0,
  match_data JSONB DEFAULT '{}',
  interview_score FLOAT,
  status TEXT CHECK (status IN ('applied', 'shortlisted', 'interview_scheduled', 'completed', 'rejected')) DEFAULT 'applied',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(job_id, candidate_id)
);

-- Interviews table
CREATE TABLE IF NOT EXISTS interviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  application_id UUID REFERENCES applications(id) ON DELETE CASCADE,
  job_id UUID REFERENCES jobs(id),
  candidate_id UUID REFERENCES users(id),
  questions JSONB DEFAULT '[]',
  answers JSONB DEFAULT '[]',
  results JSONB DEFAULT '{}',
  overall_score FLOAT,
  status TEXT CHECK (status IN ('pending', 'in_progress', 'submitted', 'completed', 'error')) DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

-- Reports table
CREATE TABLE IF NOT EXISTS reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  interview_id UUID REFERENCES interviews(id),
  application_id UUID REFERENCES applications(id),
  candidate_id UUID REFERENCES users(id),
  job_id UUID REFERENCES jobs(id),
  candidate_name TEXT,
  overall_score FLOAT,
  results JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id),
  action TEXT NOT NULL,
  resource_type TEXT,
  resource_id UUID,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security Policies

-- Users: can read own profile
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid() = id);

-- Jobs: employers manage their own, everyone can view active
ALTER TABLE jobs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view active jobs" ON jobs FOR SELECT USING (status = 'active');
CREATE POLICY "Employers manage own jobs" ON jobs FOR ALL USING (auth.uid() = employer_id);

-- Candidates: own profile
ALTER TABLE candidates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Candidates view own profile" ON candidates FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Candidates manage own profile" ON candidates FOR ALL USING (auth.uid() = user_id);

-- Applications: candidates see own, employers see for their jobs
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Candidates see own applications" ON applications FOR SELECT USING (auth.uid() = candidate_id);
CREATE POLICY "Employers see applications for their jobs" ON applications FOR SELECT 
  USING (EXISTS (SELECT 1 FROM jobs WHERE jobs.id = applications.job_id AND jobs.employer_id = auth.uid()));

-- Interviews: candidates see own
ALTER TABLE interviews ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Candidates see own interviews" ON interviews FOR SELECT USING (auth.uid() = candidate_id);
CREATE POLICY "Candidates update own interviews" ON interviews FOR UPDATE USING (auth.uid() = candidate_id);

-- Reports: employers see for their jobs
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Employers see reports for their jobs" ON reports FOR SELECT
  USING (EXISTS (SELECT 1 FROM jobs WHERE jobs.id = reports.job_id AND jobs.employer_id = auth.uid()));

-- Storage bucket for resumes
INSERT INTO storage.buckets (id, name, public) VALUES ('resumes', 'resumes', false);

-- Storage policy: users can upload their own resumes
CREATE POLICY "Users upload own resumes" ON storage.objects 
  FOR INSERT WITH CHECK (bucket_id = 'resumes' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users view own resumes" ON storage.objects 
  FOR SELECT USING (bucket_id = 'resumes' AND auth.uid()::text = (storage.foldername(name))[1]);
