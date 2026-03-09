import { Users, Car, TrendingUp, AlertTriangle } from 'lucide-react';

export function Dashboard() {
    return (
        <div className="space-y-6">
            <div>
                <h1 className="text-2xl font-bold text-warp-dark">Platform Overview</h1>
                <p className="text-slate-500 mt-1">Real-time metrics for all provincial operations</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <StatCard
                    title="Active Drivers"
                    value="142"
                    change="+12% this week"
                    icon={<Users className="w-6 h-6 text-warp-blue" />}
                    trend="up"
                />
                <StatCard
                    title="Live Rides"
                    value="48"
                    change="Updated just now"
                    icon={<Car className="w-6 h-6 text-emerald-500" />}
                    trend="neutral"
                />
                <StatCard
                    title="Daily GMV"
                    value="₱ 84,500"
                    change="+8% vs yesterday"
                    icon={<TrendingUp className="w-6 h-6 text-purple-500" />}
                    trend="up"
                />
                <StatCard
                    title="Pending Approvals"
                    value="14"
                    change="Requires attention"
                    icon={<AlertTriangle className="w-6 h-6 text-warp-warning" />}
                    trend="down"
                    alert
                />
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {/* Placeholder for Revenue Chart */}
                <div className="col-span-2 card p-6">
                    <h2 className="text-lg font-bold text-warp-dark mb-4">Revenue Overview</h2>
                    <div className="h-72 flex items-center justify-center bg-slate-50 rounded-lg border border-warp-border border-dashed">
                        <span className="text-slate-400">Recharts BarChart goes here</span>
                    </div>
                </div>

                {/* Placeholder for Recent Activity */}
                <div className="card p-6">
                    <h2 className="text-lg font-bold text-warp-dark mb-4">Live Dispatch</h2>
                    <div className="space-y-4">
                        {[1, 2, 3, 4].map((i) => (
                            <div key={i} className="flex items-start space-x-3 p-3 rounded-lg bg-slate-50 border border-warp-border">
                                <div className="w-2 h-2 mt-2 rounded-full bg-warp-blue" />
                                <div>
                                    <p className="text-sm font-medium text-warp-dark">Ride #{1040 + i} assigned</p>
                                    <p className="text-xs text-slate-500">2 mins ago</p>
                                </div>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
        </div>
    );
}

interface StatCardProps {
    title: string;
    value: string;
    change: string;
    icon: React.ReactNode;
    trend: 'up' | 'down' | 'neutral';
    alert?: boolean;
}

function StatCard({ title, value, change, icon, trend, alert = false }: StatCardProps) {
    return (
        <div className={`card p-6 ${alert ? 'border-warp-warning/50 bg-amber-50/10' : ''}`}>
            <div className="flex items-center justify-between">
                <div>
                    <p className="text-sm font-medium text-slate-500">{title}</p>
                    <p className="text-3xl font-bold text-warp-dark mt-2">{value}</p>
                </div>
                <div className="p-3 bg-slate-50 rounded-xl border border-warp-border">
                    {icon}
                </div>
            </div>
            <div className="mt-4 flex items-center text-sm">
                <span className={`
          ${trend === 'up' ? 'text-emerald-500' : ''}
          ${trend === 'down' ? 'text-warp-warning' : ''}
          ${trend === 'neutral' ? 'text-slate-500' : ''}
        `}>
                    {change}
                </span>
            </div>
        </div>
    );
}
