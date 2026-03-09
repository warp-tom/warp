import { useState, useEffect } from 'react';
import { Search, Filter, MapPin, Navigation2, MoreHorizontal } from 'lucide-react';
import { useAdminStore } from '../store/adminStore';

export function Rides() {
    const [searchTerm, setSearchTerm] = useState('');
    const { rides, isLoading, fetchRides } = useAdminStore();

    useEffect(() => {
        fetchRides();
    }, [fetchRides]);

    const filteredRides = rides.filter(r =>
        r.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        r.profiles?.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        r.drivers?.full_name?.toLowerCase().includes(searchTerm.toLowerCase())
    );

    return (
        <div className="space-y-6">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-warp-dark">Ride Operations Log</h1>
                    <p className="text-slate-500 mt-1">Monitor historical and active dispatch records</p>
                </div>
                <button className="btn-primary flex items-center">
                    Export CSV
                </button>
            </div>

            <div className="card p-4 flex flex-col sm:flex-row gap-4">
                <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                    <input
                        type="text"
                        placeholder="Search by Ride ID or Passenger..."
                        className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-warp-border rounded-lg focus:outline-none focus:ring-2 focus:ring-warp-blue focus:border-transparent transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <button className="flex items-center justify-center px-4 py-2 border border-warp-border rounded-lg text-slate-600 hover:bg-slate-50 font-medium transition-colors">
                    <Filter className="w-5 h-5 mr-2" />
                    Status Filter
                </button>
            </div>

            <div className="card overflow-hidden">
                <div className="overflow-x-auto">
                    <table className="w-full text-left border-collapse">
                        <thead>
                            <tr className="bg-slate-50 border-b border-warp-border">
                                <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Ride ID</th>
                                <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Parties</th>
                                <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Route</th>
                                <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Status</th>
                                <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider text-right">Fare</th>
                                <th className="px-6 py-4"></th>
                            </tr>
                        </thead>
                        <tbody className="divide-y divide-warp-border">
                            {isLoading ? (
                                <tr>
                                    <td colSpan={6} className="text-center py-8 text-slate-500">Loading rides...</td>
                                </tr>
                            ) : filteredRides.length === 0 ? (
                                <tr>
                                    <td colSpan={6} className="text-center py-8 text-slate-500">No rides found.</td>
                                </tr>
                            ) : filteredRides.map((ride) => (
                                <tr key={ride.id} className="hover:bg-slate-50/50 transition-colors">
                                    <td className="px-6 py-4">
                                        <span className="font-mono text-sm font-semibold text-warp-dark">
                                            {ride.id.substring(0, 8).toUpperCase()}
                                        </span>
                                        <div className="text-xs text-slate-500 mt-1">
                                            {new Date(ride.created_at).toLocaleTimeString([], { timeStyle: 'short' })}
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <div className="text-sm font-medium text-warp-dark">{ride.profiles?.full_name || 'Guest User'}</div>
                                        <div className="text-sm text-slate-500">Driver: {ride.drivers?.full_name || 'Unassigned'}</div>
                                    </td>
                                    <td className="px-6 py-4 max-w-xs">
                                        <div className="flex items-center text-sm text-warp-dark">
                                            <MapPin className="w-3 h-3 mr-2 text-slate-400 flex-shrink-0" />
                                            <span className="truncate">{ride.pickup_address}</span>
                                        </div>
                                        <div className="flex items-center text-sm text-warp-dark mt-1">
                                            <Navigation2 className="w-3 h-3 mr-2 text-warp-blue flex-shrink-0 transform rotate-45" />
                                            <span className="truncate">{ride.destination_address}</span>
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <StatusBadge status={ride.status} />
                                    </td>
                                    <td className="px-6 py-4 text-right text-sm font-medium text-warp-dark">
                                        ₱ {ride.fare?.toFixed(2) || '0.00'}
                                    </td>
                                    <td className="px-6 py-4 text-right">
                                        <button className="text-slate-400 hover:text-warp-dark p-1 rounded transition-colors">
                                            <MoreHorizontal className="w-5 h-5" />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
}

function StatusBadge({ status }: { status: string }) {
    const configs: Record<string, { bg: string, text: string, label: string }> = {
        requested: { bg: 'bg-amber-100', text: 'text-amber-800 border-amber-200', label: 'Requested' },
        accepted: { bg: 'bg-warp-blue/10', text: 'text-warp-blue border-warp-blue/20', label: 'Accepted' },
        arriving: { bg: 'bg-warp-blue/10', text: 'text-warp-blue border-warp-blue/20', label: 'Arriving' },
        ongoing: { bg: 'bg-blue-100', text: 'text-blue-700 border-blue-200', label: 'In Progress' },
        completed: { bg: 'bg-emerald-50', text: 'text-emerald-700 border-emerald-200', label: 'Completed' },
        cancelled: { bg: 'bg-slate-100', text: 'text-slate-600 border-slate-200', label: 'Cancelled' },
    };

    const config = configs[status] || { bg: 'bg-slate-100', text: 'text-slate-600 border-slate-200', label: status || 'Unknown' };

    return (
        <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${config.bg} ${config.text}`}>
            {config.label}
        </span>
    );
}
