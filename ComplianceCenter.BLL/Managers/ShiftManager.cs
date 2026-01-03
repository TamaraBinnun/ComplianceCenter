using ComplianceCenter.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using ComplianceCenter.BLL.DTO;

namespace ComplianceCenter.BLL.Managers
{

    // =============================================
    // ShiftManager
    // ניהול משמרות ושיבוץ
    // =============================================

    public class ShiftManager
    {
        private readonly ComplianceCenterEntities _context;

        public ShiftManager()
        {
            _context = new ComplianceCenterEntities();
        }

        public ShiftManager(ComplianceCenterEntities context)
        {
            _context = context;
        }

        // קבלת כל המשמרות
        public List<Shift> GetAllShifts()
        {
            return _context.Shifts
                .Where(s => s.IsActive)
                .OrderBy(s => s.StartTime)
                .ToList();
        }

        // קבלת שיבוצים לתאריך
        public List<ShiftAssignment> GetShiftAssignments(int departmentId, DateTime date, int? shiftId = null)
        {
            var query = _context.ShiftAssignments
                .Include(sa => sa.Employee)
                .Include(sa => sa.Shift)
                .Where(sa => sa.DepartmentID == departmentId && sa.AssignmentDate == date);

            if (shiftId.HasValue)
            {
                query = query.Where(sa => sa.ShiftID == shiftId.Value);
            }

            return query.OrderBy(sa => sa.Shift.StartTime)
                .ThenBy(sa => sa.Employee.LastName)
                .ToList();
        }


        // שמירת שיבוץ
        public int SaveShiftAssignment(ShiftAssignment assignment)
        {
            if (assignment.AssignmentID == 0)
            {
                assignment.CreatedDate = DateTime.Now;
                _context.ShiftAssignments.Add(assignment);
            }
            else
            {
                var existing = _context.ShiftAssignments.Find(assignment.AssignmentID);
                if (existing != null)
                {
                    existing.IsPresent = assignment.IsPresent;
                    existing.CheckInTime = assignment.CheckInTime;
                    existing.CheckOutTime = assignment.CheckOutTime;
                    existing.Notes = assignment.Notes;
                    existing.ModifiedDate = DateTime.Now;
                }
            }

            _context.SaveChanges();
            return assignment.AssignmentID;
        }

        // עדכון נוכחות
        public void UpdateAttendance(int assignmentId, bool isPresent, DateTime? checkInTime = null)
        {
            var assignment = _context.ShiftAssignments.Find(assignmentId);
            if (assignment != null)
            {
                assignment.IsPresent = isPresent;
                assignment.CheckInTime = checkInTime ?? DateTime.Now;
                assignment.ModifiedDate = DateTime.Now;
                _context.SaveChanges();
            }
        }

        public void Dispose()
        {
            _context?.Dispose();
        }

        /// <summary>
        /// Checks if employee had any shifts in the last X days
        /// </summary>
        public bool IsEmployeeOnShift(int EmployeeId)
        {
            var startDate = DateTime.Today;

            var isOnShift = _context.ShiftAssignments
                .Any(sa => sa.EmployeeID == EmployeeId &&
                          sa.AssignmentDate == DateTime.Today &&
                          sa.IsPresent.HasValue && sa.IsPresent.Value);

            return isOnShift;
        }

        
       
    }
}