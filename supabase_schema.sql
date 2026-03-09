-- Enable Extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 2.1 profiles
CREATE TABLE IF NOT EXISTS public.profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone text UNIQUE NOT NULL,
  role text DEFAULT 'passenger',
  full_name text,
  email text,
  address text,
  avatar_url text,
  is_verified boolean DEFAULT false,
  default_payment text DEFAULT 'cash',
  fcm_token text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 2.2 drivers
CREATE TABLE IF NOT EXISTS public.drivers (
  id uuid PRIMARY KEY REFERENCES auth.users(id),
  phone text,
  full_name text,
  avatar_url text,
  license_number text,
  license_expiry date,
  verification_status text DEFAULT 'pending',
  is_active boolean DEFAULT false,
  rating numeric(3,2) DEFAULT 5.00,
  total_trips integer DEFAULT 0,
  total_earnings numeric(12,2) DEFAULT 0,
  balance numeric(12,2) DEFAULT 0,
  last_online_at timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 2.3 vehicles
CREATE TABLE IF NOT EXISTS public.vehicles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid REFERENCES public.drivers(id) ON DELETE CASCADE,
  vehicle_type text,
  plate_number text,
  body_number text,
  model text,
  color text,
  is_verified boolean DEFAULT false
);

-- 2.4 driver_locations
CREATE TABLE IF NOT EXISTS public.driver_locations (
  driver_id uuid PRIMARY KEY REFERENCES public.drivers(id) ON DELETE CASCADE,
  location geography(Point, 4326),
  heading double precision,
  speed_kmh double precision,
  is_online boolean DEFAULT false,
  last_updated timestamptz DEFAULT now()
);
CREATE INDEX IF NOT EXISTS driver_locations_location_idx ON public.driver_locations USING GIST (location);

-- 2.5 trips
CREATE TABLE IF NOT EXISTS public.trips (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  driver_id uuid REFERENCES public.drivers(id),
  vehicle_id uuid REFERENCES public.vehicles(id),
  pickup_location geography(Point, 4326),
  destination_location geography(Point, 4326),
  pickup_address text,
  destination_address text,
  vehicle_type text,
  status text,
  fare numeric(10,2),
  distance_km numeric(8,2),
  duration_min numeric(8,2),
  payment_method text,
  payment_status text,
  cancelled_by text,
  cancellation_reason text,
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- 2.6 parcel_orders
CREATE TABLE IF NOT EXISTS public.parcel_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id uuid REFERENCES public.profiles(id),
  driver_id uuid REFERENCES public.drivers(id),
  receiver_name text,
  receiver_phone text,
  pickup_location geography(Point, 4326),
  delivery_location geography(Point, 4326),
  pickup_address text,
  delivery_address text,
  parcel_type text,
  description text,
  status text,
  price numeric(10,2),
  payment_method text,
  payment_status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- 2.7 errand_orders
CREATE TABLE IF NOT EXISTS public.errand_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  driver_id uuid REFERENCES public.drivers(id),
  store_name text,
  item_list jsonb,
  delivery_address text,
  delivery_location geography(Point, 4326),
  receipt_url text,
  item_cost numeric(10,2),
  delivery_fee numeric(10,2),
  status text,
  payment_method text,
  payment_status text DEFAULT 'pending',
  created_at timestamptz DEFAULT now()
);

-- 2.8 payments
CREATE TABLE IF NOT EXISTS public.payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  order_type text,
  order_id uuid,
  method text,
  amount numeric(10,2),
  status text,
  created_at timestamptz DEFAULT now()
);

-- 2.9 ratings
CREATE TABLE IF NOT EXISTS public.ratings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  driver_id uuid REFERENCES public.drivers(id),
  trip_id uuid,
  order_type text,
  rating integer CHECK (rating >= 1 AND rating <= 5),
  review text,
  tags text[],
  created_at timestamptz DEFAULT now()
);

-- 2.10 notifications
CREATE TABLE IF NOT EXISTS public.notifications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  title text,
  message text,
  type text,
  read boolean DEFAULT false,
  data jsonb,
  created_at timestamptz DEFAULT now()
);

-- 2.11 chat_messages
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  trip_id uuid REFERENCES public.trips(id),
  sender_id uuid REFERENCES public.profiles(id),
  message text,
  is_read boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- 2.12 saved_places
CREATE TABLE IF NOT EXISTS public.saved_places (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES public.profiles(id),
  label text,
  address text,
  latitude double precision,
  longitude double precision,
  icon text DEFAULT 'location',
  is_favorite boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- 2.13 driver_documents
CREATE TABLE IF NOT EXISTS public.driver_documents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  driver_id uuid REFERENCES public.drivers(id),
  document_type text,
  document_url text,
  verification_status text,
  rejection_reason text,
  expiry_date date,
  created_at timestamptz DEFAULT now()
);

-- 2.14 fare_config
CREATE TABLE IF NOT EXISTS public.fare_config (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  vehicle_type text UNIQUE,
  base_fare numeric(8,2),
  per_km_rate numeric(8,2),
  per_minute_rate numeric(8,2),
  minimum_fare numeric(8,2),
  platform_fee_pct numeric(5,2),
  surge_multiplier numeric(4,2) DEFAULT 1.00,
  is_active boolean DEFAULT true
);
-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.driver_locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.trips ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parcel_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.errand_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.driver_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fare_config ENABLE ROW LEVEL SECURITY;

-- 2. Profiles
CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING (auth.uid() = id);

-- 3. Drivers
CREATE POLICY "Public profiles are viewable by everyone" ON public.drivers FOR SELECT USING (true);
CREATE POLICY "Drivers can update own profile" ON public.drivers FOR UPDATE USING (auth.uid() = id);

-- 4. Vehicles
CREATE POLICY "Drivers can view own vehicles" ON public.vehicles FOR SELECT USING (auth.uid() = driver_id);
CREATE POLICY "Drivers can insert own vehicles" ON public.vehicles FOR INSERT WITH CHECK (auth.uid() = driver_id);
CREATE POLICY "Drivers can update own vehicles" ON public.vehicles FOR UPDATE USING (auth.uid() = driver_id);
CREATE POLICY "Drivers can delete own vehicles" ON public.vehicles FOR DELETE USING (auth.uid() = driver_id);

-- 5. Driver Locations
CREATE POLICY "Locations are viewable by everyone" ON public.driver_locations FOR SELECT USING (true);
CREATE POLICY "Drivers can insert own location" ON public.driver_locations FOR INSERT WITH CHECK (auth.uid() = driver_id);
CREATE POLICY "Drivers can update own location" ON public.driver_locations FOR UPDATE USING (auth.uid() = driver_id);

-- 6. Trips
CREATE POLICY "Users can view own trips" ON public.trips FOR SELECT USING (auth.uid() = user_id OR auth.uid() = driver_id);
CREATE POLICY "Users can insert own trips" ON public.trips FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users/Drivers can update own trips" ON public.trips FOR UPDATE USING (auth.uid() = user_id OR auth.uid() = driver_id);

-- 7. Parcel Orders
CREATE POLICY "Users can view own parcels" ON public.parcel_orders FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = driver_id);
CREATE POLICY "Users can insert own parcels" ON public.parcel_orders FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Users/Drivers can update own parcels" ON public.parcel_orders FOR UPDATE USING (auth.uid() = sender_id OR auth.uid() = driver_id);

-- 8. Errand Orders
CREATE POLICY "Users can view own errands" ON public.errand_orders FOR SELECT USING (auth.uid() = user_id OR auth.uid() = driver_id);
CREATE POLICY "Users can insert own errands" ON public.errand_orders FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users/Drivers can update own errands" ON public.errand_orders FOR UPDATE USING (auth.uid() = user_id OR auth.uid() = driver_id);

-- 9. Payments
CREATE POLICY "Users can view own payments" ON public.payments FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own payments" ON public.payments FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 10. Ratings
CREATE POLICY "Users can view own ratings" ON public.ratings FOR SELECT USING (auth.uid() = user_id OR auth.uid() = driver_id);
CREATE POLICY "Users can insert own ratings" ON public.ratings FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 11. Notifications
CREATE POLICY "Users can view own notifications" ON public.notifications FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can update own notifications" ON public.notifications FOR UPDATE USING (auth.uid() = user_id);

-- 12. Chat Messages
CREATE POLICY "Users can view own messages" ON public.chat_messages FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM public.trips t
    WHERE t.id = trip_id AND (t.user_id = auth.uid() OR t.driver_id = auth.uid())
  )
);
CREATE POLICY "Users can insert own messages" ON public.chat_messages FOR INSERT WITH CHECK (auth.uid() = sender_id);

-- 13. Saved Places
CREATE POLICY "Users can view own places" ON public.saved_places FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own places" ON public.saved_places FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own places" ON public.saved_places FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own places" ON public.saved_places FOR DELETE USING (auth.uid() = user_id);

-- 14. Driver Documents
CREATE POLICY "Drivers can view own documents" ON public.driver_documents FOR SELECT USING (auth.uid() = driver_id);
CREATE POLICY "Drivers can insert own documents" ON public.driver_documents FOR INSERT WITH CHECK (auth.uid() = driver_id);
CREATE POLICY "Drivers can update own documents" ON public.driver_documents FOR UPDATE USING (auth.uid() = driver_id);
CREATE POLICY "Drivers can delete own documents" ON public.driver_documents FOR DELETE USING (auth.uid() = driver_id);

-- 15. Fare Config
CREATE POLICY "Fare config viewable by everyone" ON public.fare_config FOR SELECT USING (true);
