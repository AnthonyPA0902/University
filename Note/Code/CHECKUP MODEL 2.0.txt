import React, { useState, useEffect, useMemo } from "react";
import '../admin_assets/css/modal.css';

const CheckUpModal = ({ isOpen, onClose, onSubmit, initialData }) => {
    const [doctors, setDoctors] = useState([]);
    const [treatments, setTreatments] = useState([]);


    // Memoize the initial form state to avoid recreating it on every render
    const initialFormState = useMemo(() => ({
        name: '',
        phone: '',
        date: '',
        startTime: '',
        endTime: '',
        room: '',
        doctorId: '',
        treatmentId: ''
    }), []);

    const [formData, setFormData] = useState(initialFormState);
    const [isEditMode, setIsEditMode] = useState(false);

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
        if (initialData) {
            setFormData({
                ...initialData,
                startTime: '',
                endTime: '',
                room: ''
            });
            setIsEditMode(true);
        } else {
            setFormData(initialFormState);
            setIsEditMode(false);
        }
    }, [initialData, initialFormState]);

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
            doctorId
        }));
    };

    const handleTreatmentChange = (e) => {
        const treatmentId = e.target.value;
        setFormData((prevData) => ({
            ...prevData,
            treatmentId
        }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit(formData);
    };

    const handleClose = () => {
        setFormData(initialFormState);
        setIsEditMode(false);
        onClose();
    };

    if (!isOpen) return null;

    return (
        <div className="modal-overlay">
            <div className="popup-modal">
                <h2>{isEditMode ? "Chỉnh sửa ca khám" : "Đăng ký ca khám"}</h2>
                <form onSubmit={handleSubmit}>
                    <input
                        type="text"
                        name="name"
                        value={formData.name}
                        onChange={handleInputChange}
                        placeholder="Tên bệnh nhân"
                        required
                        disabled={isEditMode}
                    />
                    <input
                        type="text"
                        name="phone"
                        value={formData.phone}
                        onChange={handleInputChange}
                        placeholder="Số điện thoại"
                        required
                        disabled={isEditMode}
                    />
                    <input
                        type="date"
                        name="date"
                        value={formData.date}
                        onChange={handleInputChange}
                        required
                        disabled={isEditMode}
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
                            disabled={isEditMode}
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
                            disabled={isEditMode}
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
                        <button type="button" onClick={handleClose} className="close-button">Đóng</button>
                    </div>
                </form>
            </div>
        </div>
    );
};

export default CheckUpModal;
