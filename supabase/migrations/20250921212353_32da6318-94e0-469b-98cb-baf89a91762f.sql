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
ADD COLUMN IF NOT EXISTS unsubscribe_token text UNIQUE,
ADD COLUMN IF NOT EXISTS confirmation_token text UNIQUE,
ADD COLUMN IF NOT EXISTS notes text;

-- Ensure email is unique
ALTER TABLE public.subscribers DROP CONSTRAINT IF EXISTS subscribers_email_key;
ALTER TABLE public.subscribers ADD CONSTRAINT subscribers_email_key UNIQUE (email);

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

-- Update workshops table to match requirements
ALTER TABLE public.workshops 
DROP COLUMN IF EXISTS title CASCADE,
ADD COLUMN IF NOT EXISTS name text,
ADD COLUMN IF NOT EXISTS instructor text,
ADD COLUMN IF NOT EXISTS date timestamp with time zone,
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

-- Rename columns in workshops
ALTER TABLE public.workshops 
RENAME COLUMN workshop_date TO date;
ALTER TABLE public.workshops 
RENAME COLUMN instructor_name TO instructor;

-- Update workshop_interests table
ALTER TABLE public.workshop_interests 
ADD COLUMN IF NOT EXISTS id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
ADD COLUMN IF NOT EXISTS registration_date timestamp with time zone,
ADD COLUMN IF NOT EXISTS source_campaign_id uuid,
ADD COLUMN IF NOT EXISTS notes text;

-- Update suppression_list table structure
ALTER TABLE public.suppression_list 
DROP CONSTRAINT IF EXISTS suppression_list_pkey,
ADD COLUMN IF NOT EXISTS added_at timestamp with time zone DEFAULT now(),
ADD COLUMN IF NOT EXISTS campaign_id uuid,
ADD COLUMN IF NOT EXISTS notes text;

-- Make email the primary key in suppression_list
ALTER TABLE public.suppression_list 
ADD CONSTRAINT suppression_list_pkey PRIMARY KEY (email);

-- Add foreign key constraints
ALTER TABLE public.subscriber_tags 
ADD CONSTRAINT IF NOT EXISTS subscriber_tags_tag_id_fkey 
FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE CASCADE;

ALTER TABLE public.subscriber_tags 
ADD CONSTRAINT IF NOT EXISTS subscriber_tags_subscriber_id_fkey 
FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;

ALTER TABLE public.email_events 
ADD CONSTRAINT IF NOT EXISTS email_events_subscriber_id_fkey 
FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;

ALTER TABLE public.workshop_interests 
ADD CONSTRAINT IF NOT EXISTS workshop_interests_workshop_id_fkey 
FOREIGN KEY (workshop_id) REFERENCES public.workshops(id) ON DELETE CASCADE;

ALTER TABLE public.workshop_interests 
ADD CONSTRAINT IF NOT EXISTS workshop_interests_subscriber_id_fkey 
FOREIGN KEY (subscriber_id) REFERENCES public.subscribers(id) ON DELETE CASCADE;

ALTER TABLE public.workshop_interests 
ADD CONSTRAINT IF NOT EXISTS workshop_interests_source_campaign_id_fkey 
FOREIGN KEY (source_campaign_id) REFERENCES public.campaigns(id) ON DELETE SET NULL;

ALTER TABLE public.suppression_list 
ADD CONSTRAINT IF NOT EXISTS suppression_list_campaign_id_fkey 
FOREIGN KEY (campaign_id) REFERENCES public.campaigns(id) ON DELETE SET NULL;

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

-- Create triggers to update updated_at timestamps
CREATE TRIGGER update_subscribers_updated_at
BEFORE UPDATE ON public.subscribers
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_templates_updated_at
BEFORE UPDATE ON public.templates
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_workshops_updated_at
BEFORE UPDATE ON public.workshops
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_tags_updated_at
BEFORE UPDATE ON public.tags
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();