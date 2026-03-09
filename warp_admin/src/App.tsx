import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AdminLayout } from './components/layout/AdminLayout';
import { Dashboard } from './pages/Dashboard';
import { Drivers } from './pages/Drivers';
import { Rides } from './pages/Rides';
import { MapView } from './pages/LiveMap';

// Placeholder Pages
const Settings = () => <div className="p-4"><h1 className="text-2xl font-bold">Platform Settings</h1></div>;

// This will eventually check useAuthStore before routing
const RequireAuth = ({ children }: { children: React.ReactNode }) => {
  return <>{children}</>;
};

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<RequireAuth><AdminLayout /></RequireAuth>}>
          <Route index element={<Dashboard />} />
          <Route path="drivers" element={<Drivers />} />
          <Route path="rides" element={<Rides />} />
          <Route path="map" element={<MapView />} />
          <Route path="settings" element={<Settings />} />
        </Route>
        {/* Fallback route */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
