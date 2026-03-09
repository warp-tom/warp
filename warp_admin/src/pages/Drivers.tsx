import { useState, useEffect } from 'react';
import { Search, Filter, MoreVertical, CheckCircle, XCircle } from 'lucide-react';
import { useAdminStore } from '../store/adminStore';

export function Drivers() {
    const [searchTerm, setSearchTerm] = useState('');
    const { drivers, isLoading, fetchDrivers, updateDriverStatus } = useAdminStore();

    useEffect(() => {
        fetchDrivers();
    }, [fetchDrivers]);

    const filteredDrivers = drivers.filter(d =>
        d.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
        d.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
        d.phone?.includes(searchTerm)
    );

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <h1 className="text-2xl font-bold text-warp-dark">Driver Management</h1>
                    <p className="text-slate-500 mt-1">Approve, monitor, and manage the driver fleet</p>
                </div>
                <button className="btn-primary self-start sm:self-auto">
                    Add Driver
                </button>
            </div>

            {/* Filters & Search */}
            <div className="card p-4 flex flex-col sm:flex-row gap-4">
                <div className="relative flex-1">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                    <input
                        type="text"
                        placeholder="Search by name, ID, or phone..."
                        className="w-full pl-10 pr-4 py-2 bg-slate-50 border border-warp-border rounded-lg focus:outline-none focus:ring-2 focus:ring-warp-blue focus:border-transparent transition-all"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                    />
                </div>
                <button className="flex items-center justify-center px-4 py-2 border border-warp-border rounded-lg text-slate-600 hover:bg-slate-50 font-medium transition-colors">
                    <Filter className="w-5 h-5 mr-2" />
                    More Filters
                </button>
            </div>

            {/* Data Table */}
            <div className="card overflow-x-auto">
                <table className="w-full text-left border-collapse">
                    <thead>
                        <tr className="bg-slate-50 border-b border-warp-border">
                            <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Driver info</th>
                            <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Vehicle</th>
                            <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Joined</th>
                            <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider">Status</th>
                            <th className="px-6 py-4 font-semibold text-xs text-slate-500 uppercase tracking-wider text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-warp-border">
                        {isLoading ? (
                            <tr>
                                <td colSpan={5} className="text-center py-8 text-slate-500">Loading drivers...</td>
                            </tr>
                        ) : filteredDrivers.length === 0 ? (
                            <tr>
                                <td colSpan={5} className="text-center py-8 text-slate-500">No drivers found.</td>
                            </tr>
                        ) : filteredDrivers.map((driver) => {
                            const mainVehicle = driver.vehicles && driver.vehicles.length > 0 ? driver.vehicles[0] : null;
                            const dName = driver.full_name || 'Unknown';

                            return (
                                <tr key={driver.id} className="hover:bg-slate-50/50 transition-colors">
                                    <td className="px-6 py-4">
                                        <div className="flex items-center">
                                            <div className="h-10 w-10 flex-shrink-0 rounded-full bg-warp-blue/10 flex items-center justify-center text-warp-blue font-bold">
                                                {dName.charAt(0)}
                                            </div>
                                            <div className="ml-4">
                                                <div className="text-sm font-medium text-warp-dark">{dName}</div>
                                                <div className="text-sm text-slate-500">{driver.phone || 'No phone'} • {driver.id.substring(0, 8)}...</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td className="px-6 py-4">
                                        <div className="text-sm text-warp-dark capitalize">{mainVehicle?.vehicle_type || 'Unregistered'}</div>
                                        <div className="text-sm text-slate-500 uppercase">{mainVehicle?.plate_number || 'N/A'}</div>
                                    </td>
                                    <td className="px-6 py-4 text-sm text-slate-500">
                                        {new Date(driver.created_at).toLocaleDateString()}
                                    </td>
                                    <td className="px-6 py-4">
                                        {driver.verification_status === 'pending' ? (
                                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-amber-100 text-amber-800 border border-amber-200">
                                                Pending Approval
                                            </span>
                                        ) : driver.verification_status === 'approved' ? (
                                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800 border border-emerald-200">
                                                Approved
                                            </span>
                                        ) : (
                                            <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 border border-red-200">
                                                Rejected
                                            </span>
                                        )}
                                    </td>
                                    <td className="px-6 py-4 text-right text-sm font-medium">
                                        {driver.verification_status === 'pending' && (
                                            <div className="flex items-center justify-end space-x-2">
                                                <button
                                                    onClick={() => updateDriverStatus(driver.id, 'approved')}
                                                    className="text-emerald-600 hover:text-emerald-900 bg-emerald-50 p-1.5 rounded-md transition-colors shadow-sm border border-emerald-100"
                                                    title="Approve">
                                                    <CheckCircle className="w-5 h-5" />
                                                </button>
                                                <button
                                                    onClick={() => updateDriverStatus(driver.id, 'rejected')}
                                                    className="text-red-600 hover:text-red-900 bg-red-50 p-1.5 rounded-md transition-colors shadow-sm border border-red-100"
                                                    title="Reject">
                                                    <XCircle className="w-5 h-5" />
                                                </button>
                                            </div>
                                        )}
                                        {driver.verification_status === 'approved' && (
                                            <button className="text-slate-400 hover:text-warp-dark p-1.5 rounded-md">
                                                <MoreVertical className="w-5 h-5" />
                                            </button>
                                        )}
                                    </td>
                                </tr>
                            )
                        })}
                    </tbody>
                </table>
            </div>
        </div>
    );
}
