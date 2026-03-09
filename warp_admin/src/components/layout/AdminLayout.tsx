import { useState } from 'react';
import { NavLink, Outlet } from 'react-router-dom';
import {
    LayoutDashboard,
    Users,
    Car,
    Map,
    Settings,
    Bell,
    Menu,
    LogOut
} from 'lucide-react';
import { useAuthStore } from '../../store/authStore';

const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: Users, label: 'Drivers', path: '/drivers' },
    { icon: Car, label: 'Rides', path: '/rides' },
    { icon: Map, label: 'Live Map', path: '/map' },
    { icon: Settings, label: 'Settings', path: '/settings' },
];

export function AdminLayout() {
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const { setUser } = useAuthStore();

    const handleLogout = () => {
        // Supabase sign out logic would go here
        setUser(null);
    };

    return (
        <div className="flex h-screen bg-warp-light overflow-hidden">

            {/* Mobile sidebar overlay */}
            {sidebarOpen && (
                <div
                    className="fixed inset-0 bg-warp-dark/50 z-20 lg:hidden"
                    onClick={() => setSidebarOpen(false)}
                />
            )}

            {/* Sidebar */}
            <aside className={`
        fixed inset-y-0 left-0 z-30 w-64 bg-white border-r border-warp-border transform transition-transform duration-300 ease-in-out lg:static lg:translate-x-0
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'}
      `}>
                <div className="h-16 flex items-center px-6 border-b border-warp-border">
                    <span className="text-2xl tracking-widest font-black text-warp-blue">WARP</span>
                    <span className="ml-2 text-xs font-semibold px-2 py-0.5 rounded bg-blue-100 text-warp-blue">ADMIN</span>
                </div>

                <nav className="p-4 space-y-1">
                    {navItems.map((item) => (
                        <NavLink
                            key={item.path}
                            to={item.path}
                            className={({ isActive }) => `
                flex items-center px-4 py-3 rounded-lg text-sm font-medium transition-colors
                ${isActive
                                    ? 'bg-warp-blue/10 text-warp-blue'
                                    : 'text-slate-600 hover:bg-slate-50 hover:text-warp-dark'
                                }
              `}
                        >
                            <item.icon className="w-5 h-5 mr-3" />
                            {item.label}
                        </NavLink>
                    ))}
                </nav>

                <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-warp-border">
                    <button
                        onClick={handleLogout}
                        className="flex items-center w-full px-4 py-3 rounded-lg text-sm font-medium text-slate-600 hover:bg-red-50 hover:text-warp-danger transition-colors"
                    >
                        <LogOut className="w-5 h-5 mr-3" />
                        Sign Out
                    </button>
                </div>
            </aside>

            {/* Main Content Component */}
            <div className="flex-1 flex flex-col min-w-0 overflow-hidden">

                {/* Header */}
                <header className="h-16 bg-white border-b border-warp-border flex items-center justify-between px-4 lg:px-8">
                    <button
                        className="p-2 lg:hidden text-slate-600 hover:bg-slate-100 rounded-lg"
                        onClick={() => setSidebarOpen(true)}
                    >
                        <Menu className="w-6 h-6" />
                    </button>

                    <div className="flex-1" />

                    <div className="flex items-center space-x-4">
                        <button className="p-2 text-slate-400 hover:text-slate-600 relative">
                            <Bell className="w-5 h-5" />
                            <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-warp-danger rounded-full" />
                        </button>
                        <div className="h-8 w-8 rounded-full bg-slate-200 border border-warp-border flex items-center justify-center">
                            <Users className="w-4 h-4 text-slate-500" />
                        </div>
                    </div>
                </header>

                {/* Page Content */}
                <main className="flex-1 overflow-y-auto p-4 lg:p-8">
                    <Outlet />
                </main>
            </div>

        </div>
    );
}
