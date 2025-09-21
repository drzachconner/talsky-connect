-- Update subscribers table to add missing columns
ALTER TABLE public.subscribers 
ADD COLUMN IF NOT EXISTS practice_type text,
ADD COLUMN IF NOT EXISTS license_number text,
ADD COLUMN IF NOT EXISTS graduation_year integer,
ADD COLUMN IF NOT EXISTS state text,
ADD COLUMN IF NOT EXISTS city text,
ADD COLUMN IF NOT EXISTS zip_code text,
ADD COLUMN IF NOT EXISTS clinic_name text,
ADD COLUMN IF NOT EXISTS phone text,
ADD COLUMN IF NOT EXISTS confirmed_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS last_email_opened_at timestamp with time zone,
ADD COLUMN IF NOT EXISTS total_opens integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS total_clicks integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS engagement_score integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS preferred_email_frequency text,
ADD COLUMN IF NOT EXISTS unsubscribe_token text,
ADD COLUMN IF NOT EXISTS confirmation_token text,
ADD COLUMN IF NOT EXISTS notes text;

-- Add unique constraints separately
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'subscribers_email_key') THEN
        ALTER TABLE public.subscribers ADD CONSTRAINT subscribers_email_key UNIQUE (email);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'subscribers_unsubscribe_token_key') THEN
        ALTER TABLE public.subscribers ADD CONSTRAINT subscribers_unsubscribe_token_key UNIQUE (unsubscribe_token);
    END IF;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'subscribers_confirmation_token_key') THEN
        ALTER TABLE public.subscribers ADD CONSTRAINT subscribers_confirmation_token_key UNIQUE (confirmation_token);
    END IF;
END $$;

-- Update templates table to match requirements
ALTER TABLE public.templates 
ADD COLUMN IF NOT EXISTS category text,
ADD COLUMN IF NOT EXISTS subject_template text,
ADD COLUMN IF NOT EXISTS preview_text_template text,
ADD COLUMN IF NOT EXISTS content_html text,
ADD COLUMN IF NOT EXISTS content_json jsonb,
ADD COLUMN IF NOT EXISTS variables text[],
ADD COLUMN IF NOT EXISTS is_starter_template boolean DEFAULT false,
ADD COLUMN IF NOT EXISTS times_used integer DEFAULT 0,
ADD COLUMN IF NOT EXISTS avg_open_rate numeric;

-- Update workshops table - rename existing columns first
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'workshops' AND column_name = 'title') THEN
        ALTER TABLE public.workshops RENAME COLUMN title TO name;
    END IF;
END $$;

DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'workshops' AND column_name = 'workshop_date') THEN
        ALTER TABLE public.workshops RENAME COLUMN workshop_date TO date;
    END IF;
END $$;

DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'workshops' AND column_name = 'instructor_name') THEN
        ALTER TABLE public.workshops RENAME COLUMN instructor_name TO instructor;
    END IF;
END $$;

-- Add missing columns to workshops
ALTER TABLE public.workshops 
ADD COLUMN IF NOT EXISTS end_date timestamp with time zone,
ADD COLUMN IF NOT EXISTS type text,
ADD COLUMN IF NOT EXISTS location_name text,
ADD COLUMN IF NOT EXISTS location_address text,
ADD COLUMN IF NOT EXISTS location_map_url text,
ADD COLUMN IF NOT EXISTS timezone text,
ADD COLUMN IF NOT EXISTS spots_remaining integer,
ADD COLUMN IF NOT EXISTS early_bird_price numeric,
ADD COLUMN IF NOT EXISTS early_bird_deadline timestamp with time zone,
ADD COLUMN IF NOT EXISTS learning_objectives text[],
ADD COLUMN IF NOT EXISTS image_url text,
ADD COLUMN IF NOT EXISTS materials_included text[];

-- Update workshop_interests table
ALTER TABLE public.workshop_interests 
ADD COLUMN IF NOT EXISTS registration_date timestamp with time zone,
ADD COLUMN IF NOT EXISTS source_campaign_id uuid,
ADD COLUMN IF NOT EXISTS notes text;

-- Update suppression_list table structure
ALTER TABLE public.suppression_list 
ADD COLUMN IF NOT EXISTS added_at timestamp with time zone DEFAULT now(),
ADD COLUMN IF NOT EXISTS campaign_id uuid,
ADD COLUMN IF NOT EXISTS notes text;

-- Drop existing primary key and create new one for suppression_list
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'suppression_list_pkey') THEN
        ALTER TABLE public.suppression_list DROP CONSTRAINT suppression_list_pkey;
    END IF;
    ALTER TABLE public.suppression_list ADD CONSTRAINT suppression_list_pkey PRIMARY KEY (email);
EXCEPTION WHEN duplicate_table THEN
    NULL;
END $$;

-- Add foreign key constraints with proper error handling
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'subscriber_tags_tag_id_fkey') THEN
        ALTER TABLE public.subscriber_tags 
        ADD CONSTRAINT subscriber_tags_tag_id_fkey 
        FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'subscriber_tags_subscriber_id_fkey') THEN
        ALTER TABLE public.subscriber_tags 
        ADD CONSTRAINT subscriber_tags_subscriber_id_fkey 
        FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'email_events_subscriber_id_fkey') THEN
        ALTER TABLE public.email_events 
        ADD CONSTRAINT email_events_subscriber_id_fkey 
        FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'workshop_interests_workshop_id_fkey') THEN
        ALTER TABLE public.workshop_interests 
        ADD CONSTRAINT workshop_interests_workshop_id_fkey 
        FOREIGN KEY (workshop_id) REFERENCES public.workshops(id) ON DELETE CASCADE;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'workshop_interests_subscriber_id_fkey') THEN
        ALTER TABLE public.workshop_interests 
        ADD CONSTRAINT workshop_interests_subscriber_id_fkey 
        FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;
    END IF;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

-- Create indexes on frequently queried columns
CREATE INDEX IF NOT EXISTS idx_subscribers_email ON public.subscribers(email);
CREATE INDEX IF NOT EXISTS idx_subscribers_status ON public.subscribers(status);
CREATE INDEX IF NOT EXISTS idx_subscribers_practice_type ON public.subscribers(practice_type);
CREATE INDEX IF NOT EXISTS idx_subscribers_state ON public.subscribers(state);
CREATE INDEX IF NOT EXISTS idx_campaigns_status ON public.campaigns(status);
CREATE INDEX IF NOT EXISTS idx_email_events_subscriber_id ON public.email_events(subscriber_id);
CREATE INDEX IF NOT EXISTS idx_email_events_campaign_id ON public.email_events(campaign_id);
CREATE INDEX IF NOT EXISTS idx_email_events_event_type ON public.email_events(event_type);
CREATE INDEX IF NOT EXISTS idx_workshop_interests_workshop_id ON public.workshop_interests(workshop_id);
CREATE INDEX IF NOT EXISTS idx_workshop_interests_subscriber_id ON public.workshop_interests(subscriber_id);
CREATE INDEX IF NOT EXISTS idx_tags_name ON public.tags(name);