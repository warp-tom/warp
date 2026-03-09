import { create } from 'zustand';
import { supabase } from '../lib/supabase';

export interface Driver {
    id: string;
    full_name: string | null;
    phone: string | null;
    verification_status: 'pending' | 'approved' | 'rejected';
    created_at: string;
    vehicles?: { plate_number: string, vehicle_type: string }[];
}

export interface DriverLocation {
    driver_id: string;
    location: string;
    is_online: boolean;
    drivers?: { full_name: string };
    trips?: any[]; // Simplified check for active trips
}

export interface Ride {
    id: string;
    user_id: string;
    driver_id: string | null;
    pickup_address: string;
    destination_address: string;
    status: string;
    fare: number;
    created_at: string;
    profiles?: { full_name: string };
    drivers?: { full_name: string };
}

interface AdminState {
    drivers: Driver[];
    rides: Ride[];
    driverLocations: DriverLocation[];
    isLoading: boolean;
    error: string | null;
    fetchDrivers: () => Promise<void>;
    fetchRides: () => Promise<void>;
    fetchDriverLocations: () => Promise<void>;
    updateDriverStatus: (id: string, status: 'approved' | 'rejected') => Promise<void>;
}

export const useAdminStore = create<AdminState>((set, get) => ({
    drivers: [],
    rides: [],
    driverLocations: [],
    isLoading: false,
    error: null,

    fetchDrivers: async () => {
        set({ isLoading: true, error: null });
        try {
            const { data, error } = await supabase
                .from('drivers')
                .select('*, vehicles(plate_number, vehicle_type)')
                .order('created_at', { ascending: false });

            if (error) throw error;
            set({ drivers: data as Driver[] });
        } catch (error: any) {
            set({ error: error.message });
        } finally {
            set({ isLoading: false });
        }
    },

    fetchRides: async () => {
        set({ isLoading: true, error: null });
        try {
            const { data, error } = await supabase
                .from('trips')
                .select('*, profiles(full_name), drivers(full_name)')
                .order('created_at', { ascending: false });

            if (error) throw error;
            set({ rides: data as Ride[] });
        } catch (error: any) {
            set({ error: error.message });
        } finally {
            set({ isLoading: false });
        }
    },

    fetchDriverLocations: async () => {
        try {
            // Fetch locations and join with drivers to get names.
            // Also checking if they have an active trip to color them differently.
            const { data, error } = await supabase
                .from('driver_locations')
                .select('driver_id, location, is_online, drivers(full_name), trips!driver_id(id, status)')
                .eq('is_online', true);

            if (error) throw error;
            set({ driverLocations: data as any[] });
        } catch (error: any) {
            console.error("Error fetching locations:", error);
        }
    },

    updateDriverStatus: async (id, status) => {
        try {
            const { error } = await supabase
                .from('drivers')
                .update({ verification_status: status })
                .eq('id', id);

            if (error) throw error;

            // Update local state
            const drivers = get().drivers.map(d =>
                d.id === id ? { ...d, verification_status: status } : d
            );
            set({ drivers });
        } catch (error: any) {
            set({ error: error.message });
        }
    }
}));
