import { useState, useEffect } from 'react';
import { Search, Map as MapIcon, Navigation, Crosshair, Users } from 'lucide-react';
import { useAdminStore } from '../store/adminStore';

function parseLocationString(locationString: string): { lng: number, lat: number } | null {
    // E.g. "POINT(121.05 14.58)"
    const match = locationString.match(/POINT\(([^ ]+) ([^)]+)\)/);
    if (match) {
        return {
            lng: parseFloat(match[1]),
            lat: parseFloat(match[2])
        };
    }
    return null;
}

export function MapView() {
    const { driverLocations, fetchDriverLocations } = useAdminStore();
    const [searchTerm, setSearchTerm] = useState('');

    useEffect(() => {
        fetchDriverLocations();
        // Setup polling for the map to roughly simulate realtime
        const interval = setInterval(fetchDriverLocations, 10000);
        return () => clearInterval(interval);
    }, [fetchDriverLocations]);

    const activeDrivers = driverLocations.filter(dl =>
        dl.drivers?.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        dl.driver_id.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="flex flex-col h-[calc(100vh-8rem)]">
            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 className="text-2xl font-bold text-warp-dark">Live Fleet Map</h1>
                    <p className="text-slate-500 mt-1">Real-time geospatial tracking of all active units</p>
                </div>
                <div className="flex space-x-2">
                    <button onClick={() => fetchDriverLocations()} className="flex items-center px-4 py-2 bg-white border border-warp-border rounded-lg text-slate-600 font-medium hover:bg-slate-50 transition-colors">
                        <Users className="w-4 h-4 mr-2" />
                        Refresh Data
                    </button>
                    <button className="flex items-center px-4 py-2 bg-warp-blue text-white rounded-lg font-medium hover:bg-blue-700 transition-colors">
                        <Crosshair className="w-4 h-4 mr-2" />
                        Recenter Map
                    </button>
                </div>
            </div>

            {/* Main Map Area Container */}
            <div className="flex-1 card flex overflow-hidden relative">

                {/* Mock Map Background Layer */}
                <div className="absolute inset-0 bg-[#e5e3df] dark:bg-slate-800">
                    {/* Decorative Grid for Mock Map */}
                    <div className="absolute inset-0" style={{ backgroundImage: 'radial-gradient(#CBD5E1 1px, transparent 1px)', backgroundSize: '40px 40px' }} />

                    {/* Centered Map Interface Placeholder */}
                    <div className="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                        <MapIcon className="w-16 h-16 text-slate-400 opacity-50 mb-4" />
                        <p className="text-slate-500 font-medium tracking-wide">GOOGLE MAPS INTEGRATION LAYER</p>
                        <p className="text-slate-400 text-sm tracking-wide mt-2">({driverLocations.length} Online Drivers Fetched)</p>
                    </div>

                    {/* Dynamic Driver Markers on Map (Simulated Overlay) */}
                    {activeDrivers.map((dl, idx) => {
                        const coords = dl.location ? parseLocationString(dl.location) : null;
                        // Determine if driver is on a live trip (i.e. status 'accepted', 'arriving', 'ongoing')
                        const inTrip = dl.trips && dl.trips.some((t: any) => ['accepted', 'arriving', 'ongoing'].includes(t.status));

                        // Fake visual placement since we don't have a real map canvas attached yet
                        // We use index to distribute them across the screen purely for UI demonstration
                        const topPos = 20 + ((idx * 37) % 60);
                        const leftPos = 20 + ((idx * 43) % 60);

                        return (
                            <div key={dl.driver_id} className="absolute flex flex-col items-center transition-all duration-1000 ease-in-out" style={{ top: `${topPos}%`, left: `${leftPos}%` }}>
                                <div className="relative group cursor-pointer">
                                    <div className={`w-10 h-10 bg-white rounded-full shadow-lg border-2 flex items-center justify-center z-10 relative ${inTrip ? 'border-emerald-500' : 'border-warp-blue'}`}>
                                        <Navigation className={`w-5 h-5 transform rotate-45 ${inTrip ? 'text-emerald-500' : 'text-warp-blue'}`} />
                                    </div>
                                    <div className="absolute top-full mt-2 left-1/2 -translate-x-1/2 bg-warp-dark text-white text-xs font-bold px-2 py-1 rounded w-max opacity-0 group-hover:opacity-100 transition-opacity z-50">
                                        {dl.drivers?.full_name || dl.driver_id.substring(0, 8)} ({inTrip ? 'In Trip' : 'Available'})
                                        {coords && <div className="text-[10px] font-normal opacity-70 border-t border-slate-600 mt-1 pt-1">{coords.lat.toFixed(4)}, {coords.lng.toFixed(4)}</div>}
                                    </div>
                                </div>
                            </div>
                        )
                    })}
                </div>

                {/* Floating Search overlay */}
                <div className="relative w-80 bg-white border-r border-warp-border flex flex-col shadow-xl z-20">
                    <div className="p-4 border-b border-warp-border">
                        <div className="relative">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                            <input
                                type="text"
                                placeholder="Find driver..."
                                className="w-full pl-9 pr-4 py-2 bg-slate-50 border border-warp-border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-warp-blue focus:border-transparent transition-all"
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                            />
                        </div>
                    </div>

                    <div className="flex-1 overflow-y-auto p-2">
                        <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider px-2 py-3">Active Units ({activeDrivers.length})</h3>

                        {activeDrivers.length === 0 ? (
                            <div className="p-4 text-center text-slate-500 text-sm">No drivers online.</div>
                        ) : activeDrivers.map(dl => {
                            const inTrip = dl.trips && dl.trips.some((t: any) => ['accepted', 'arriving', 'ongoing'].includes(t.status));

                            return (
                                <button key={dl.driver_id} className="w-full text-left p-3 rounded-lg hover:bg-slate-50 transition-colors border border-transparent hover:border-warp-border mb-2 group">
                                    <div className="flex items-center justify-between">
                                        <span className="font-semibold text-warp-dark text-sm truncate pr-2">{dl.drivers?.full_name || dl.driver_id.substring(0, 8)}</span>
                                        <span className={`w-2 h-2 rounded-full ${inTrip ? 'bg-emerald-500' : 'bg-warp-blue'} flex-shrink-0`}></span>
                                    </div>
                                    <p className="text-xs text-slate-500 mt-1">
                                        {inTrip ? 'Active Trip' : 'Available'}
                                    </p>
                                </button>
                            )
                        })}
                    </div>
                </div>
            </div>
        </div>
    );
}
