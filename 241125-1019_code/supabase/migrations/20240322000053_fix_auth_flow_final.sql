-- First, clean up all tables to start fresh
DROP TABLE IF EXISTS linked_applications CASCADE;
DROP TABLE IF EXISTS applications CASCADE;
DROP TABLE IF EXISTS whitelist CASCADE;

-- Create applications table to store pending applications
CREATE TABLE applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email text UNIQUE NOT NULL,
  encrypted_password text NOT NULL,  -- Store encrypted password until approved
  data jsonb NOT NULL,
  status text NOT NULL DEFAULT 'pending',
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create linked applications table
CREATE TABLE linked_applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  primary_application_id uuid REFERENCES applications(id) ON DELETE CASCADE,
  linked_name text NOT NULL,
  linked_email text NOT NULL,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  UNIQUE(primary_application_id, linked_email)
);

-- Create a function to handle application submission
CREATE OR REPLACE FUNCTION submit_application(
  p_email text,
  p_password text,
  p_data jsonb,
  p_linked_name text DEFAULT NULL,
  p_linked_email text DEFAULT NULL
) RETURNS jsonb AS $$
DECLARE
  v_application applications;
BEGIN
  -- Check if email already exists in auth.users
  IF EXISTS (SELECT 1 FROM auth.users WHERE email = p_email) THEN
    RAISE EXCEPTION 'Email already exists';
  END IF;

  -- Check if email already has a pending application
  IF EXISTS (SELECT 1 FROM applications WHERE email = p_email) THEN
    RAISE EXCEPTION 'Application already exists for this email';
  END IF;

  -- Create application with encrypted password
  INSERT INTO applications (
    email,
    encrypted_password,
    data,
    status,
    created_at,
    updated_at
  ) VALUES (
    p_email,
    crypt(p_password, gen_salt('bf')),
    p_data,
    'pending',
    now(),
    now()
  )
  RETURNING * INTO v_application;

  -- Handle linked application if provided
  IF p_linked_name IS NOT NULL AND p_linked_email IS NOT NULL THEN
    INSERT INTO linked_applications (
      primary_application_id,
      linked_name,
      linked_email,
      created_at
    ) VALUES (
      v_application.id,
      p_linked_name,
      p_linked_email,
      now()
    );
  END IF;

  RETURN jsonb_build_object(
    'application_id', v_application.id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create a function to approve application and create user
CREATE OR REPLACE FUNCTION approve_application(
  p_application_id uuid
) RETURNS void AS $$
DECLARE
  v_application applications;
  v_user_id uuid;
BEGIN
  -- Get the application
  SELECT * INTO v_application
  FROM applications
  WHERE id = p_application_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Application not found';
  END IF;

  -- Generate user ID
  v_user_id := gen_random_uuid();

  -- Create the user with full access
  INSERT INTO auth.users (
    id,
    email,
    encrypted_password,
    email_confirmed_at,
    raw_app_meta_data,
    raw_user_meta_data,
    aud,
    role,
    instance_id,
    created_at,
    updated_at
  ) VALUES (
    v_user_id,
    v_application.email,
    v_application.encrypted_password,  -- Use stored encrypted password
    now(),  -- Email automatically confirmed
    jsonb_build_object(
      'provider', 'email',
      'providers', ARRAY['email']
    ),
    jsonb_build_object('approved', true),
    'authenticated',
    'authenticated',
    '00000000-0000-0000-0000-000000000000',
    now(),
    now()
  );

  -- Create identity record
  INSERT INTO auth.identities (
    id,
    user_id,
    provider_id,
    provider,
    identity_data,
    last_sign_in_at,
    created_at,
    updated_at
  ) VALUES (
    gen_random_uuid(),
    v_user_id,
    v_application.email,
    'email',
    jsonb_build_object(
      'sub', v_user_id::text,
      'email', v_application.email,
      'email_verified', true,
      'provider', 'email'
    ),
    now(),
    now(),
    now()
  );

  -- Create profile
  INSERT INTO profiles (id, email)
  VALUES (v_user_id, v_application.email);

  -- Update application status
  UPDATE applications
  SET 
    status = 'approved',
    updated_at = now()
  WHERE id = p_application_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create view for applications with linked data
CREATE OR REPLACE VIEW application_details AS
SELECT 
  a.*,
  la.linked_name,
  la.linked_email,
  la2.id as linked_application_id,
  la2.email as linked_application_email
FROM applications a
LEFT JOIN linked_applications la ON a.id = la.primary_application_id
LEFT JOIN applications la2 ON la.linked_email = la2.email;

-- Enable RLS
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE linked_applications ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Anyone can submit applications"
  ON applications FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Admin full access to applications"
  ON applications FOR ALL
  USING (public.is_admin());

CREATE POLICY "Admin full access to linked_applications"
  ON linked_applications FOR ALL
  USING (public.is_admin());

-- Grant permissions
GRANT ALL ON applications TO authenticated;
GRANT ALL ON linked_applications TO authenticated;
GRANT SELECT ON application_details TO authenticated;
GRANT EXECUTE ON FUNCTION submit_application TO anon;
GRANT EXECUTE ON FUNCTION submit_application TO authenticated;
GRANT EXECUTE ON FUNCTION approve_application TO authenticated;