import React, { useState, useEffect } from 'react';
import '../../admin_assets/css/schedule.css';
import ScheduleModal from '../../components/ScheduleModal';
// import Swal from 'sweetalert2';
import { useNavigate } from 'react-router-dom'; // Import for navigation



const Schedule = () => {
    const [schedule, setSchedule] = useState([]);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [editingSchedule, setEditingSchedule] = useState(null);
    const [searchTerm, setSearchTerm] = useState(""); // State for the search input
    const navigate = useNavigate(); // Initialize navigate


    useEffect(() => {
        fetch("https://localhost:7157/api/admin/schedule")
            .then((response) => response.json())
            .then((data) => {
                console.log(data)
                if (Array.isArray(data.schedules)) {
                    setSchedule(data.schedules);
                } else {
                    setSchedule([]);
                }
            })
            .catch((error) => console.error("Error fetching schedulé:", error));
    }, []);

    const handleCheckupClick = (scheduleData) => {
        navigate('/admin/checkup', { state: { scheduleData } }); // Pass data to CheckUp page
    };


    const handleAddSchedule = (scheduleData) => {
        console.log("Submitting schedule data:", scheduleData);

        const payload = {
            name: scheduleData.name,
            phone: scheduleData.phone,
            email: scheduleData.email,
            date: scheduleData.date,
            doctorId: parseInt(scheduleData.doctorId),
            treatmentId: parseInt(scheduleData.treatmentId)
        };

        if (editingSchedule) {
            fetch(`https://localhost:7157/api/admin/schedule/${editingSchedule.id}`, {
                method: "PUT",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(payload),
            })
                .then((response) => response.json())
                .then(() => refetchScheduleData())
                .catch((error) => console.error("Error editing schedule:", error));
        } else {
            fetch("https://localhost:7157/api/admin/schedule", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(payload),
            })
                .then((response) => response.json())
                .then(() => refetchScheduleData())
                .catch((error) => console.error("Error updating schedule:", error));
        }
        setIsModalOpen(false);
    };

    const refetchScheduleData = (search = "") => {
        fetch(`https://localhost:7157/api/admin/schedule?search=${encodeURIComponent(search)}`)
            .then((response) => response.json())
            .then((updatedData) => {
                if (Array.isArray(updatedData.schedules)) {
                    setSchedule(updatedData.schedules);
                }
            })
            .catch((error) => console.error("Error fetching updated schedule:", error));
    };

    const handleSearch = () => {
        refetchScheduleData(searchTerm); // Fetch data based on search term
    };


    const handleCreateClick = () => {
        setEditingSchedule(null);
        setIsModalOpen(true);
    };

    const handleEditClick = (id) => {
        fetch(`https://localhost:7157/api/admin/schedule/${id}`)
            .then((response) => response.json())
            .then((data) => {
                setEditingSchedule(data.schedule);
                setIsModalOpen(true);
            })
            .catch((error) => console.error("Error fetching schedule:", error));
    };

    
    // const handleDeleteClick = (scheduleId) => {
    //     // Show SweetAlert2 confirmation dialog
    //     Swal.fire({
    //         title: 'Are you sure?',
    //         text: "Do you really want to delete this schedule?",
    //         icon: 'warning',
    //         showCancelButton: true,
    //         confirmButtonColor: '#d33',
    //         cancelButtonColor: '#3085d6',
    //         confirmButtonText: 'Delete',
    //         cancelButtonText: 'Cancel'
    //     }).then((result) => {
    //         if (result.isConfirmed) {
    //             fetch(`https://localhost:7157/api/admin/schedule/${scheduleId}`, {
    //                 method: 'DELETE',
    //                 headers: {
    //                     'Content-Type': 'application/json',
    //                 }
    //             })
    //                 .then((response) => response.json())
    //                 .then((data) => {
    //                     if (data.success) {
    //                         Swal.fire(
    //                             'Deleted!',
    //                             'Schedule has been deleted.',
    //                             'success'
    //                         );
    //                         refetchScheduleData();
    //                     }
    //                 })
    //                 .catch((error) => {
    //                     Swal.fire(
    //                         'Error!',
    //                         'There was a problem deleting the schedule.',
    //                         'error'
    //                     );
    //                     console.error('Error deleting schedule:', error);
    //                 });
    //         }
    //     });
    // };


    return (
        <div className="content">
            <div className="schedule-container">
                <h1>Danh sách lịch hẹn khám</h1>
                <button className="register-button" onClick={() => handleCreateClick()}>
                    Tạo lịch hẹn khám mới
                </button>
                <br />
                <br />
                <input
                    type="text"
                    placeholder="Tìm kiếm theo tên bác sĩ"
                    className="search-bar"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                />
                <button onClick={handleSearch} className="search-button">
                    <img src="/admin_assets/img/search-icon.png" alt="Search" className="search-icon" />
                </button>
                <table className="schedule-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Họ tên</th>
                            <th>Số điện thoại</th>
                            <th>Email</th>
                            <th>Ngày hẹn</th>
                            <th>Bác sĩ khám</th>
                            <th>Dịch vụ khám</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        {Array.isArray(schedule) && schedule.map((schedule, index) => (
                            <tr key={index}>
                                <td>{index + 1}</td>
                                <td>{schedule.name}</td>
                                <td>{schedule.phone}</td>
                                <td>{schedule.email}</td>
                                <td>{schedule.date}</td>
                                <td>{schedule.doctorName}</td>
                                <td>{schedule.treatmentName}</td>
                                <td style={{ textAlign: 'center' }}><button onClick={() => handleEditClick(schedule.id)}><img className="icon" src="/admin_assets/img/icon/edit-icon.png" alt="edit-icon" /></button>
                                    &nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;
                                    {schedule.condition === "Chưa Xếp Lịch" && (
                                        <button onClick={() => handleCheckupClick(schedule)}>
                                            <img className="icon" src="/admin_assets/img/icon/checkup-icon.png" alt="checkup-icon" />
                                        </button>
                                    )}
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                <ScheduleModal
                    isOpen={isModalOpen}
                    onClose={() => setIsModalOpen(false)}
                    onSubmit={handleAddSchedule}
                    editingSchedule={editingSchedule}
                />
            </div>
        </div>
    );
};

export default Schedule;