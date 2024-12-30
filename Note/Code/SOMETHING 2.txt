import React, { useState, useEffect } from "react";
import '../admin_assets/css/modal.css';

const CheckUpModal = ({ isOpen, onClose, onSubmit, initialData}) => {
    const [doctors, setDoctors] = useState([]);
    const [treatments, setTreatments] = useState([]);
    const [formData, setFormData] = useState({
        name: '',
        phone: '',
        date: '',
        startTime: '',
        endTime: '',
        room: '',
        doctorId: '',
        treatmentId: ''
    });
    
    useEffect(() => {
        fetch("https://localhost:7157/api/admin/checkup")
            .then((response) => response.json())
            .then((data) => {
                setDoctors(data.doctors);
                setTreatments(data.treatments);
            })
            .catch((error) => console.error("Error fetching checkup info:", error));
    }, []);

    useEffect(() => {
        console.log(initialData);
        if (initialData) {
            setFormData({
                ...initialData,
                startTime: '', // Set to empty to let user choose
                endTime: '',
                room: ''
            });
        }
    }, [initialData]);

    const handleInputChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value
        });
    };

    const handleDoctorChange = (e) => {
        const doctorId = e.target.value;
        setFormData((prevData) => ({
            ...prevData,
            doctorId: doctorId // Update doctorId in formData
        }));
    };

    const handleTreatmentChange = (e) => {
        const treatmentId = e.target.value;
        setFormData((prevData) => ({
            ...prevData,
            treatmentId: treatmentId // Update treatmentId in formData
        }));
    };
    
    const handleSubmit = (e) => {
        e.preventDefault();

        onSubmit(formData); // Pass the new checkup to the parent
        onClose(); // Close the modal after submission
    };

    if (!isOpen) return null;

    return (
        <div className="modal-overlay">
            <div className="popup-modal">
                <h2>Đăng ký ca khám</h2>
                <form onSubmit={handleSubmit}>
                    <input 
                        type="text" 
                        name="name" 
                        value={formData.name} 
                        onChange={handleInputChange}
                        placeholder="Tên bệnh nhân" 
                        required 
                    />
                    <input 
                        type="text"
                        name="phone" 
                        value={formData.phone} 
                        onChange={handleInputChange}
                        placeholder="Số điện thoại" 
                        required 
                    />
                    <input 
                        type="date" 
                        name="date" 
                        value={formData.date} 
                        onChange={handleInputChange}
                        required 
                    />
                    <div className="time-inputs">
                        <input 
                            type="time" 
                            name="startTime" 
                            value={formData.startTime} 
                            onChange={handleInputChange}
                            required 
                        />
                        <input 
                            type="time" 
                            name="endTime" 
                            value={formData.endTime} 
                            onChange={handleInputChange}
                            required 
                        />
                    </div>
                    <div className="select-container">
                        <select
                            name="doctorId"
                            value={formData.doctorId}
                            onChange={handleDoctorChange}
                            required
                        >
                            <option value="">Chọn bác sĩ</option>
                            {doctors.map((doctor) => (
                                <option key={doctor.id} value={doctor.id}>{doctor.name}</option>
                            ))}
                        </select>

                        <select
                            name="treatmentId"
                            value={formData.treatmentId}
                            onChange={handleTreatmentChange}
                            required
                        >
                            <option value="">Chọn dịch vụ</option>
                            {treatments.map((treatment) => (
                                <option key={treatment.id} value={treatment.id}>{treatment.treatmentName}</option>
                            ))}
                        </select>
                    </div>
                    <input 
                        type="text" 
                        name="room" 
                        value={formData.room} 
                        onChange={handleInputChange}
                        placeholder="Phòng khám" 
                        required 
                    />
                    <div className="button-container">
                        <button type="submit" className="submit-button">Đăng Ký</button>
                        <button type="button" onClick={onClose} className="close-button">Đóng</button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default CheckUpModal;
