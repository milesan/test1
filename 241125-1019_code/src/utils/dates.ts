import { addWeeks, startOfWeek, addDays, addMonths } from 'date-fns';
import { convertToUTC1 } from './timezone';

export function generateWeeks(startDate: Date, count: number): Date[] {
  const weeks: Date[] = [];

  // Special period dates in Portugal time
  const specialDates = {
    dec16: convertToUTC1(new Date('2024-12-16'), 0),
    dec23: convertToUTC1(new Date('2024-12-23'), 0),
    dec30: convertToUTC1(new Date('2024-12-30'), 0)
  };

  // Special period (Dec 16 - Jan 6)
  if (startDate <= specialDates.dec16) {
    weeks.push(specialDates.dec16);
    weeks.push(specialDates.dec23);
    weeks.push(specialDates.dec30);
  }

  // For dates after the special period, use scheduling rules
  let currentWeek = startDate > specialDates.dec30 ? startOfWeek(startDate) : convertToUTC1(new Date('2025-01-07'), 0);
  
  while (weeks.length < count) {
    if (currentWeek >= startDate || weeks.length === 0) {
      weeks.push(currentWeek);
    }
    currentWeek = addDays(currentWeek, 7);
  }

  return weeks.slice(0, count);
}

export function generateSquigglePath(): string {
  const width = 100;
  const height = 30;
  const segments = 8;
  const segmentWidth = width / segments;
  
  let path = `M 0 ${height / 2}`;
  
  for (let i = 0; i < segments; i++) {
    const x1 = i * segmentWidth + segmentWidth / 3;
    const x2 = (i + 1) * segmentWidth;
    const y1 = i % 2 === 0 ? height * 0.2 : height * 0.8;
    const y2 = height / 2;
    
    path += ` C ${x1} ${y1}, ${x1} ${y1}, ${x2} ${y2}`;
  }
  
  return path;
}

export function getWeeksInRange(weeks: Date[], start: Date, end: Date): Date[] {
  const startWeek = startOfWeek(start);
  const endWeek = startOfWeek(end);
  
  return weeks.filter(week => {
    const weekStart = startOfWeek(week);
    return weekStart >= startWeek && weekStart <= endWeek;
  });
}

export function getWeekDates(week: Date): Date[] {
  return Array.from({ length: 7 }, (_, i) => addDays(week, i));
}