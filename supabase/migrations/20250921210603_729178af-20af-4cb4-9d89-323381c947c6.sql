-- Create enums for various status fields
CREATE TYPE public.subscriber_status AS ENUM ('active', 'unsubscribed', 'bounced', 'complained', 'pending');
CREATE TYPE public.campaign_status AS ENUM ('draft', 'scheduled', 'sending', 'sent', 'paused', 'cancelled');
CREATE TYPE public.email_event_type AS ENUM ('sent', 'delivered', 'opened', 'clicked', 'bounced', 'complained', 'unsubscribed');
CREATE TYPE public.automation_status AS ENUM ('active', 'paused', 'draft');
CREATE TYPE public.automation_trigger_type AS ENUM ('signup', 'tag_added', 'segment_joined', 'date_based', 'workshop_interest');
CREATE TYPE public.import_status AS ENUM ('pending', 'processing', 'completed', 'failed');
CREATE TYPE public.suppression_reason AS ENUM ('unsubscribed', 'bounced', 'complained', 'manual');
CREATE TYPE public.custom_field_type AS ENUM ('text', 'number', 'date', 'boolean', 'select');

-- 1. Subscribers table (core table)
CREATE TABLE public.subscribers (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT,
    last_name TEXT,
    status public.subscriber_status NOT NULL DEFAULT 'active',
    tags TEXT[] DEFAULT '{}',
    custom_fields JSONB DEFAULT '{}',
    subscribed_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    unsubscribed_at TIMESTAMP WITH TIME ZONE,
    last_opened_at TIMESTAMP WITH TIME ZONE,
    last_clicked_at TIMESTAMP WITH TIME ZONE,
    open_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    bounce_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 2. Campaigns table
CREATE TABLE public.campaigns (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    preview_text TEXT,
    content TEXT,
    html_content TEXT,
    status public.campaign_status NOT NULL DEFAULT 'draft',
    segment_conditions JSONB,
    scheduled_at TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    sent_count INTEGER DEFAULT 0,
    delivered_count INTEGER DEFAULT 0,
    open_count INTEGER DEFAULT 0,
    click_count INTEGER DEFAULT 0,
    bounce_count INTEGER DEFAULT 0,
    unsubscribe_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 3. Segments table
CREATE TABLE public.segments (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    conditions JSONB NOT NULL DEFAULT '{}',
    subscriber_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 4. Templates table
CREATE TABLE public.templates (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    content TEXT,
    html_content TEXT,
    thumbnail_url TEXT,
    is_system BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 5. Email events table
CREATE TABLE public.email_events (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    subscriber_id UUID NOT NULL REFERENCES public.subscribers(id) ON DELETE CASCADE,
    campaign_id UUID REFERENCES public.campaigns(id) ON DELETE CASCADE,
    event_type public.email_event_type NOT NULL,
    event_data JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 6. Workshops table
CREATE TABLE public.workshops (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    instructor_name TEXT,
    workshop_date TIMESTAMP WITH TIME ZONE,
    duration_minutes INTEGER,
    capacity INTEGER,
    current_registrations INTEGER DEFAULT 0,
    price DECIMAL(10,2),
    registration_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 7. Workshop interests table
CREATE TABLE public.workshop_interests (
    subscriber_id UUID NOT NULL REFERENCES public.subscribers(id) ON DELETE CASCADE,
    workshop_id UUID NOT NULL REFERENCES public.workshops(id) ON DELETE CASCADE,
    interest_level TEXT DEFAULT 'interested',
    registered BOOLEAN DEFAULT false,
    registered_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (subscriber_id, workshop_id)
);

-- 8. Forms table
CREATE TABLE public.forms (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    fields JSONB NOT NULL DEFAULT '[]',
    settings JSONB DEFAULT '{}',
    submission_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 9. Form submissions table
CREATE TABLE public.form_submissions (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    form_id UUID NOT NULL REFERENCES public.forms(id) ON DELETE CASCADE,
    subscriber_id UUID REFERENCES public.subscribers(id) ON DELETE SET NULL,
    data JSONB NOT NULL DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 10. Automations table
CREATE TABLE public.automations (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    trigger_type public.automation_trigger_type NOT NULL,
    trigger_conditions JSONB DEFAULT '{}',
    status public.automation_status NOT NULL DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 11. Automation emails table
CREATE TABLE public.automation_emails (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    automation_id UUID NOT NULL REFERENCES public.automations(id) ON DELETE CASCADE,
    template_id UUID REFERENCES public.templates(id) ON DELETE SET NULL,
    name TEXT NOT NULL,
    subject TEXT NOT NULL,
    content TEXT,
    html_content TEXT,
    delay_hours INTEGER DEFAULT 0,
    send_order INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 12. Automation queue table
CREATE TABLE public.automation_queue (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    subscriber_id UUID NOT NULL REFERENCES public.subscribers(id) ON DELETE CASCADE,
    automation_email_id UUID NOT NULL REFERENCES public.automation_emails(id) ON DELETE CASCADE,
    scheduled_at TIMESTAMP WITH TIME ZONE NOT NULL,
    sent_at TIMESTAMP WITH TIME ZONE,
    status TEXT DEFAULT 'pending',
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 13. Tags table
CREATE TABLE public.tags (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    color TEXT DEFAULT '#3B82F6',
    subscriber_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 14. Subscriber tags table
CREATE TABLE public.subscriber_tags (
    subscriber_id UUID NOT NULL REFERENCES public.subscribers(id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES public.tags(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY (subscriber_id, tag_id)
);

-- 15. Custom fields table
CREATE TABLE public.custom_fields (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    field_type public.custom_field_type NOT NULL,
    options JSONB DEFAULT '{}',
    is_required BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 16. Import jobs table
CREATE TABLE public.import_jobs (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    filename TEXT NOT NULL,
    status public.import_status NOT NULL DEFAULT 'pending',
    total_records INTEGER DEFAULT 0,
    processed_records INTEGER DEFAULT 0,
    successful_records INTEGER DEFAULT 0,
    failed_records INTEGER DEFAULT 0,
    errors JSONB DEFAULT '[]',
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- 17. Suppression list table
CREATE TABLE public.suppression_list (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    reason public.suppression_reason NOT NULL,
    suppression_type TEXT DEFAULT 'global',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Create indexes for commonly queried fields
CREATE INDEX idx_subscribers_email ON public.subscribers(email);
CREATE INDEX idx_subscribers_status ON public.subscribers(status);
CREATE INDEX idx_subscribers_tags ON public.subscribers USING GIN(tags);
CREATE INDEX idx_subscribers_created_at ON public.subscribers(created_at);

CREATE INDEX idx_campaigns_status ON public.campaigns(status);
CREATE INDEX idx_campaigns_sent_at ON public.campaigns(sent_at);

CREATE INDEX idx_email_events_subscriber_id ON public.email_events(subscriber_id);
CREATE INDEX idx_email_events_campaign_id ON public.email_events(campaign_id);
CREATE INDEX idx_email_events_type ON public.email_events(event_type);
CREATE INDEX idx_email_events_created_at ON public.email_events(created_at);

CREATE INDEX idx_workshops_date ON public.workshops(workshop_date);
CREATE INDEX idx_workshops_active ON public.workshops(is_active);

CREATE INDEX idx_form_submissions_form_id ON public.form_submissions(form_id);
CREATE INDEX idx_form_submissions_subscriber_id ON public.form_submissions(subscriber_id);

CREATE INDEX idx_automation_queue_scheduled_at ON public.automation_queue(scheduled_at);
CREATE INDEX idx_automation_queue_status ON public.automation_queue(status);

-- Enable Row Level Security on all tables
ALTER TABLE public.subscribers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workshops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workshop_interests ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.automations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.automation_emails ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.automation_queue ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscriber_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.custom_fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.import_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suppression_list ENABLE ROW LEVEL SECURITY;

-- Create permissive RLS policies for development (allow all operations for now)
-- NOTE: In production, these should be more restrictive based on user authentication

-- Subscribers policies
CREATE POLICY "Allow all operations on subscribers" ON public.subscribers FOR ALL USING (true) WITH CHECK (true);

-- Campaigns policies
CREATE POLICY "Allow all operations on campaigns" ON public.campaigns FOR ALL USING (true) WITH CHECK (true);

-- Segments policies
CREATE POLICY "Allow all operations on segments" ON public.segments FOR ALL USING (true) WITH CHECK (true);

-- Templates policies
CREATE POLICY "Allow all operations on templates" ON public.templates FOR ALL USING (true) WITH CHECK (true);

-- Email events policies
CREATE POLICY "Allow all operations on email_events" ON public.email_events FOR ALL USING (true) WITH CHECK (true);

-- Workshops policies
CREATE POLICY "Allow all operations on workshops" ON public.workshops FOR ALL USING (true) WITH CHECK (true);

-- Workshop interests policies
CREATE POLICY "Allow all operations on workshop_interests" ON public.workshop_interests FOR ALL USING (true) WITH CHECK (true);

-- Forms policies
CREATE POLICY "Allow all operations on forms" ON public.forms FOR ALL USING (true) WITH CHECK (true);

-- Form submissions policies
CREATE POLICY "Allow all operations on form_submissions" ON public.form_submissions FOR ALL USING (true) WITH CHECK (true);

-- Automations policies
CREATE POLICY "Allow all operations on automations" ON public.automations FOR ALL USING (true) WITH CHECK (true);

-- Automation emails policies
CREATE POLICY "Allow all operations on automation_emails" ON public.automation_emails FOR ALL USING (true) WITH CHECK (true);

-- Automation queue policies
CREATE POLICY "Allow all operations on automation_queue" ON public.automation_queue FOR ALL USING (true) WITH CHECK (true);

-- Tags policies
CREATE POLICY "Allow all operations on tags" ON public.tags FOR ALL USING (true) WITH CHECK (true);

-- Subscriber tags policies
CREATE POLICY "Allow all operations on subscriber_tags" ON public.subscriber_tags FOR ALL USING (true) WITH CHECK (true);

-- Custom fields policies
CREATE POLICY "Allow all operations on custom_fields" ON public.custom_fields FOR ALL USING (true) WITH CHECK (true);

-- Import jobs policies
CREATE POLICY "Allow all operations on import_jobs" ON public.import_jobs FOR ALL USING (true) WITH CHECK (true);

-- Suppression list policies
CREATE POLICY "Allow all operations on suppression_list" ON public.suppression_list FOR ALL USING (true) WITH CHECK (true);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

-- Create triggers for automatic timestamp updates
CREATE TRIGGER update_subscribers_updated_at
    BEFORE UPDATE ON public.subscribers
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_campaigns_updated_at
    BEFORE UPDATE ON public.campaigns
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_segments_updated_at
    BEFORE UPDATE ON public.segments
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

CREATE TRIGGER update_forms_updated_at
    BEFORE UPDATE ON public.forms
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_automations_updated_at
    BEFORE UPDATE ON public.automations
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_automation_emails_updated_at
    BEFORE UPDATE ON public.automation_emails
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_automation_queue_updated_at
    BEFORE UPDATE ON public.automation_queue
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_tags_updated_at
    BEFORE UPDATE ON public.tags
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_custom_fields_updated_at
    BEFORE UPDATE ON public.custom_fields
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_import_jobs_updated_at
    BEFORE UPDATE ON public.import_jobs
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();