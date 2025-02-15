import React, { useState } from 'react';
import { Applications2 } from '../components/admin/Applications2';
import { AppView } from '../components/admin/AppView';
import { BookingsList } from '../components/BookingsList';
import { InventoryCalendar } from '../components/InventoryCalendar';
import { Weekly } from '../components/admin/Weekly';
import { ClipboardList, Calendar, Users, LayoutGrid, ListChecks } from 'lucide-react';

type AdminView = 'applications' | 'appview' | 'bookings' | 'calendar' | 'weekly';

export function AdminPage() {
  const [currentView, setCurrentView] = useState<AdminView>('applications');
  const [showCalendar, setShowCalendar] = useState(false);
  const [showWeekly, setShowWeekly] = useState(false);

  return (
    <div className="min-h-screen bg-stone-50">
      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="mb-8">
          <h1 className="text-3xl font-display font-light text-stone-900">Admin Dashboard</h1>
          <p className="text-stone-600">Manage applications, bookings, and availability</p>
        </div>

        <div className="flex gap-4 mb-8">
          <button
            onClick={() => setCurrentView('applications')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              currentView === 'applications'
                ? 'bg-emerald-900 text-white'
                : 'bg-white text-stone-600 hover:bg-stone-50 border border-stone-200'
            }`}
          >
            <Users className="w-4 h-4" />
            Applications
          </button>
          <button
            onClick={() => setCurrentView('appview')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              currentView === 'appview'
                ? 'bg-emerald-900 text-white'
                : 'bg-white text-stone-600 hover:bg-stone-50 border border-stone-200'
            }`}
          >
            <LayoutGrid className="w-4 h-4" />
            AppView
          </button>
          <button
            onClick={() => setCurrentView('bookings')}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              currentView === 'bookings'
                ? 'bg-emerald-900 text-white'
                : 'bg-white text-stone-600 hover:bg-stone-50 border border-stone-200'
            }`}
          >
            <ClipboardList className="w-4 h-4" />
            Bookings
          </button>
          <button
            onClick={() => setShowCalendar(true)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              showCalendar
                ? 'bg-emerald-900 text-white'
                : 'bg-white text-stone-600 hover:bg-stone-50 border border-stone-200'
            }`}
          >
            <Calendar className="w-4 h-4" />
            Calendar
          </button>
          <button
            onClick={() => setShowWeekly(true)}
            className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
              showWeekly
                ? 'bg-emerald-900 text-white'
                : 'bg-white text-stone-600 hover:bg-stone-50 border border-stone-200'
            }`}
          >
            <ListChecks className="w-4 h-4" />
            Weekly
          </button>
        </div>

        <div className="bg-white rounded-xl border border-stone-200 shadow-sm">
          {currentView === 'applications' && <Applications2 />}
          {currentView === 'appview' && <AppView />}
          {currentView === 'bookings' && <BookingsList />}
        </div>
      </div>

      {showCalendar && (
        <InventoryCalendar onClose={() => setShowCalendar(false)} />
      )}

      {showWeekly && (
        <Weekly onClose={() => setShowWeekly(false)} />
      )}
    </div>
  );
}