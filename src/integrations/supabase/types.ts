export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "13.0.5"
  }
  public: {
    Tables: {
      automation_emails: {
        Row: {
          automation_id: string
          content: string | null
          created_at: string
          delay_hours: number | null
          html_content: string | null
          id: string
          name: string
          send_order: number | null
          subject: string
          template_id: string | null
          updated_at: string
        }
        Insert: {
          automation_id: string
          content?: string | null
          created_at?: string
          delay_hours?: number | null
          html_content?: string | null
          id?: string
          name: string
          send_order?: number | null
          subject: string
          template_id?: string | null
          updated_at?: string
        }
        Update: {
          automation_id?: string
          content?: string | null
          created_at?: string
          delay_hours?: number | null
          html_content?: string | null
          id?: string
          name?: string
          send_order?: number | null
          subject?: string
          template_id?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "automation_emails_automation_id_fkey"
            columns: ["automation_id"]
            isOneToOne: false
            referencedRelation: "automations"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "automation_emails_template_id_fkey"
            columns: ["template_id"]
            isOneToOne: false
            referencedRelation: "templates"
            referencedColumns: ["id"]
          },
        ]
      }
      automation_queue: {
        Row: {
          automation_email_id: string
          created_at: string
          error_message: string | null
          id: string
          scheduled_at: string
          sent_at: string | null
          status: string | null
          subscriber_id: string
          updated_at: string
        }
        Insert: {
          automation_email_id: string
          created_at?: string
          error_message?: string | null
          id?: string
          scheduled_at: string
          sent_at?: string | null
          status?: string | null
          subscriber_id: string
          updated_at?: string
        }
        Update: {
          automation_email_id?: string
          created_at?: string
          error_message?: string | null
          id?: string
          scheduled_at?: string
          sent_at?: string | null
          status?: string | null
          subscriber_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "automation_queue_automation_email_id_fkey"
            columns: ["automation_email_id"]
            isOneToOne: false
            referencedRelation: "automation_emails"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "automation_queue_subscriber_id_fkey"
            columns: ["subscriber_id"]
            isOneToOne: false
            referencedRelation: "subscribers"
            referencedColumns: ["id"]
          },
        ]
      }
      automations: {
        Row: {
          created_at: string
          description: string | null
          id: string
          name: string
          status: Database["public"]["Enums"]["automation_status"]
          trigger_conditions: Json | null
          trigger_type: Database["public"]["Enums"]["automation_trigger_type"]
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          id?: string
          name: string
          status?: Database["public"]["Enums"]["automation_status"]
          trigger_conditions?: Json | null
          trigger_type: Database["public"]["Enums"]["automation_trigger_type"]
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          id?: string
          name?: string
          status?: Database["public"]["Enums"]["automation_status"]
          trigger_conditions?: Json | null
          trigger_type?: Database["public"]["Enums"]["automation_trigger_type"]
          updated_at?: string
        }
        Relationships: []
      }
      campaigns: {
        Row: {
          bounce_count: number | null
          click_count: number | null
          content: string | null
          created_at: string
          delivered_count: number | null
          html_content: string | null
          id: string
          name: string
          open_count: number | null
          preview_text: string | null
          scheduled_at: string | null
          segment_conditions: Json | null
          sent_at: string | null
          sent_count: number | null
          status: Database["public"]["Enums"]["campaign_status"]
          subject: string
          unsubscribe_count: number | null
          updated_at: string
        }
        Insert: {
          bounce_count?: number | null
          click_count?: number | null
          content?: string | null
          created_at?: string
          delivered_count?: number | null
          html_content?: string | null
          id?: string
          name: string
          open_count?: number | null
          preview_text?: string | null
          scheduled_at?: string | null
          segment_conditions?: Json | null
          sent_at?: string | null
          sent_count?: number | null
          status?: Database["public"]["Enums"]["campaign_status"]
          subject: string
          unsubscribe_count?: number | null
          updated_at?: string
        }
        Update: {
          bounce_count?: number | null
          click_count?: number | null
          content?: string | null
          created_at?: string
          delivered_count?: number | null
          html_content?: string | null
          id?: string
          name?: string
          open_count?: number | null
          preview_text?: string | null
          scheduled_at?: string | null
          segment_conditions?: Json | null
          sent_at?: string | null
          sent_count?: number | null
          status?: Database["public"]["Enums"]["campaign_status"]
          subject?: string
          unsubscribe_count?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      custom_fields: {
        Row: {
          created_at: string
          field_type: Database["public"]["Enums"]["custom_field_type"]
          id: string
          is_required: boolean | null
          name: string
          options: Json | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          field_type: Database["public"]["Enums"]["custom_field_type"]
          id?: string
          is_required?: boolean | null
          name: string
          options?: Json | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          field_type?: Database["public"]["Enums"]["custom_field_type"]
          id?: string
          is_required?: boolean | null
          name?: string
          options?: Json | null
          updated_at?: string
        }
        Relationships: []
      }
      email_events: {
        Row: {
          campaign_id: string | null
          created_at: string
          event_data: Json | null
          event_type: Database["public"]["Enums"]["email_event_type"]
          id: string
          ip_address: unknown | null
          subscriber_id: string
          user_agent: string | null
        }
        Insert: {
          campaign_id?: string | null
          created_at?: string
          event_data?: Json | null
          event_type: Database["public"]["Enums"]["email_event_type"]
          id?: string
          ip_address?: unknown | null
          subscriber_id: string
          user_agent?: string | null
        }
        Update: {
          campaign_id?: string | null
          created_at?: string
          event_data?: Json | null
          event_type?: Database["public"]["Enums"]["email_event_type"]
          id?: string
          ip_address?: unknown | null
          subscriber_id?: string
          user_agent?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "email_events_campaign_id_fkey"
            columns: ["campaign_id"]
            isOneToOne: false
            referencedRelation: "campaigns"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "email_events_subscriber_id_fkey"
            columns: ["subscriber_id"]
            isOneToOne: false
            referencedRelation: "subscribers"
            referencedColumns: ["id"]
          },
        ]
      }
      form_submissions: {
        Row: {
          created_at: string
          data: Json
          form_id: string
          id: string
          ip_address: unknown | null
          subscriber_id: string | null
          user_agent: string | null
        }
        Insert: {
          created_at?: string
          data?: Json
          form_id: string
          id?: string
          ip_address?: unknown | null
          subscriber_id?: string | null
          user_agent?: string | null
        }
        Update: {
          created_at?: string
          data?: Json
          form_id?: string
          id?: string
          ip_address?: unknown | null
          subscriber_id?: string | null
          user_agent?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "form_submissions_form_id_fkey"
            columns: ["form_id"]
            isOneToOne: false
            referencedRelation: "forms"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "form_submissions_subscriber_id_fkey"
            columns: ["subscriber_id"]
            isOneToOne: false
            referencedRelation: "subscribers"
            referencedColumns: ["id"]
          },
        ]
      }
      forms: {
        Row: {
          created_at: string
          description: string | null
          fields: Json
          id: string
          is_active: boolean | null
          name: string
          settings: Json | null
          submission_count: number | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          description?: string | null
          fields?: Json
          id?: string
          is_active?: boolean | null
          name: string
          settings?: Json | null
          submission_count?: number | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          description?: string | null
          fields?: Json
          id?: string
          is_active?: boolean | null
          name?: string
          settings?: Json | null
          submission_count?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      import_jobs: {
        Row: {
          completed_at: string | null
          created_at: string
          errors: Json | null
          failed_records: number | null
          filename: string
          id: string
          processed_records: number | null
          started_at: string | null
          status: Database["public"]["Enums"]["import_status"]
          successful_records: number | null
          total_records: number | null
          updated_at: string
        }
        Insert: {
          completed_at?: string | null
          created_at?: string
          errors?: Json | null
          failed_records?: number | null
          filename: string
          id?: string
          processed_records?: number | null
          started_at?: string | null
          status?: Database["public"]["Enums"]["import_status"]
          successful_records?: number | null
          total_records?: number | null
          updated_at?: string
        }
        Update: {
          completed_at?: string | null
          created_at?: string
          errors?: Json | null
          failed_records?: number | null
          filename?: string
          id?: string
          processed_records?: number | null
          started_at?: string | null
          status?: Database["public"]["Enums"]["import_status"]
          successful_records?: number | null
          total_records?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      segments: {
        Row: {
          conditions: Json
          created_at: string
          description: string | null
          id: string
          name: string
          subscriber_count: number | null
          updated_at: string
        }
        Insert: {
          conditions?: Json
          created_at?: string
          description?: string | null
          id?: string
          name: string
          subscriber_count?: number | null
          updated_at?: string
        }
        Update: {
          conditions?: Json
          created_at?: string
          description?: string | null
          id?: string
          name?: string
          subscriber_count?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      subscriber_tags: {
        Row: {
          created_at: string
          subscriber_id: string
          tag_id: string
        }
        Insert: {
          created_at?: string
          subscriber_id: string
          tag_id: string
        }
        Update: {
          created_at?: string
          subscriber_id?: string
          tag_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "subscriber_tags_subscriber_id_fkey"
            columns: ["subscriber_id"]
            isOneToOne: false
            referencedRelation: "subscribers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "subscriber_tags_tag_id_fkey"
            columns: ["tag_id"]
            isOneToOne: false
            referencedRelation: "tags"
            referencedColumns: ["id"]
          },
        ]
      }
      subscribers: {
        Row: {
          bounce_count: number | null
          click_count: number | null
          created_at: string
          custom_fields: Json | null
          email: string
          first_name: string | null
          id: string
          last_clicked_at: string | null
          last_name: string | null
          last_opened_at: string | null
          open_count: number | null
          status: Database["public"]["Enums"]["subscriber_status"]
          subscribed_at: string | null
          tags: string[] | null
          unsubscribed_at: string | null
          updated_at: string
        }
        Insert: {
          bounce_count?: number | null
          click_count?: number | null
          created_at?: string
          custom_fields?: Json | null
          email: string
          first_name?: string | null
          id?: string
          last_clicked_at?: string | null
          last_name?: string | null
          last_opened_at?: string | null
          open_count?: number | null
          status?: Database["public"]["Enums"]["subscriber_status"]
          subscribed_at?: string | null
          tags?: string[] | null
          unsubscribed_at?: string | null
          updated_at?: string
        }
        Update: {
          bounce_count?: number | null
          click_count?: number | null
          created_at?: string
          custom_fields?: Json | null
          email?: string
          first_name?: string | null
          id?: string
          last_clicked_at?: string | null
          last_name?: string | null
          last_opened_at?: string | null
          open_count?: number | null
          status?: Database["public"]["Enums"]["subscriber_status"]
          subscribed_at?: string | null
          tags?: string[] | null
          unsubscribed_at?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      suppression_list: {
        Row: {
          created_at: string
          email: string
          id: string
          reason: Database["public"]["Enums"]["suppression_reason"]
          suppression_type: string | null
        }
        Insert: {
          created_at?: string
          email: string
          id?: string
          reason: Database["public"]["Enums"]["suppression_reason"]
          suppression_type?: string | null
        }
        Update: {
          created_at?: string
          email?: string
          id?: string
          reason?: Database["public"]["Enums"]["suppression_reason"]
          suppression_type?: string | null
        }
        Relationships: []
      }
      tags: {
        Row: {
          color: string | null
          created_at: string
          id: string
          name: string
          subscriber_count: number | null
          updated_at: string
        }
        Insert: {
          color?: string | null
          created_at?: string
          id?: string
          name: string
          subscriber_count?: number | null
          updated_at?: string
        }
        Update: {
          color?: string | null
          created_at?: string
          id?: string
          name?: string
          subscriber_count?: number | null
          updated_at?: string
        }
        Relationships: []
      }
      templates: {
        Row: {
          content: string | null
          created_at: string
          description: string | null
          html_content: string | null
          id: string
          is_system: boolean | null
          name: string
          thumbnail_url: string | null
          updated_at: string
        }
        Insert: {
          content?: string | null
          created_at?: string
          description?: string | null
          html_content?: string | null
          id?: string
          is_system?: boolean | null
          name: string
          thumbnail_url?: string | null
          updated_at?: string
        }
        Update: {
          content?: string | null
          created_at?: string
          description?: string | null
          html_content?: string | null
          id?: string
          is_system?: boolean | null
          name?: string
          thumbnail_url?: string | null
          updated_at?: string
        }
        Relationships: []
      }
      workshop_interests: {
        Row: {
          created_at: string
          interest_level: string | null
          registered: boolean | null
          registered_at: string | null
          subscriber_id: string
          workshop_id: string
        }
        Insert: {
          created_at?: string
          interest_level?: string | null
          registered?: boolean | null
          registered_at?: string | null
          subscriber_id: string
          workshop_id: string
        }
        Update: {
          created_at?: string
          interest_level?: string | null
          registered?: boolean | null
          registered_at?: string | null
          subscriber_id?: string
          workshop_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "workshop_interests_subscriber_id_fkey"
            columns: ["subscriber_id"]
            isOneToOne: false
            referencedRelation: "subscribers"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "workshop_interests_workshop_id_fkey"
            columns: ["workshop_id"]
            isOneToOne: false
            referencedRelation: "workshops"
            referencedColumns: ["id"]
          },
        ]
      }
      workshops: {
        Row: {
          capacity: number | null
          created_at: string
          current_registrations: number | null
          description: string | null
          duration_minutes: number | null
          id: string
          instructor_name: string | null
          is_active: boolean | null
          price: number | null
          registration_url: string | null
          title: string
          updated_at: string
          workshop_date: string | null
        }
        Insert: {
          capacity?: number | null
          created_at?: string
          current_registrations?: number | null
          description?: string | null
          duration_minutes?: number | null
          id?: string
          instructor_name?: string | null
          is_active?: boolean | null
          price?: number | null
          registration_url?: string | null
          title: string
          updated_at?: string
          workshop_date?: string | null
        }
        Update: {
          capacity?: number | null
          created_at?: string
          current_registrations?: number | null
          description?: string | null
          duration_minutes?: number | null
          id?: string
          instructor_name?: string | null
          is_active?: boolean | null
          price?: number | null
          registration_url?: string | null
          title?: string
          updated_at?: string
          workshop_date?: string | null
        }
        Relationships: []
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      automation_status: "active" | "paused" | "draft"
      automation_trigger_type:
        | "signup"
        | "tag_added"
        | "segment_joined"
        | "date_based"
        | "workshop_interest"
      campaign_status:
        | "draft"
        | "scheduled"
        | "sending"
        | "sent"
        | "paused"
        | "cancelled"
      custom_field_type: "text" | "number" | "date" | "boolean" | "select"
      email_event_type:
        | "sent"
        | "delivered"
        | "opened"
        | "clicked"
        | "bounced"
        | "complained"
        | "unsubscribed"
      import_status: "pending" | "processing" | "completed" | "failed"
      subscriber_status:
        | "active"
        | "unsubscribed"
        | "bounced"
        | "complained"
        | "pending"
      suppression_reason: "unsubscribed" | "bounced" | "complained" | "manual"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      automation_status: ["active", "paused", "draft"],
      automation_trigger_type: [
        "signup",
        "tag_added",
        "segment_joined",
        "date_based",
        "workshop_interest",
      ],
      campaign_status: [
        "draft",
        "scheduled",
        "sending",
        "sent",
        "paused",
        "cancelled",
      ],
      custom_field_type: ["text", "number", "date", "boolean", "select"],
      email_event_type: [
        "sent",
        "delivered",
        "opened",
        "clicked",
        "bounced",
        "complained",
        "unsubscribed",
      ],
      import_status: ["pending", "processing", "completed", "failed"],
      subscriber_status: [
        "active",
        "unsubscribed",
        "bounced",
        "complained",
        "pending",
      ],
      suppression_reason: ["unsubscribed", "bounced", "complained", "manual"],
    },
  },
} as const
