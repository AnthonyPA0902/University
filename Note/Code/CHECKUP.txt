import React, { useState, useEffect } from "react";
import '../../admin_assets/css/checkup.css';
import CheckUpModal from '../../components/CheckUpModal';

const CheckUp = () => {
    const [checkups, setCheckups] = useState([]);  // Initialize checkups as an empty array
    const [isModalOpen, setIsModalOpen] = useState(false);

    useEffect(() => {
        // Fetch the initial checkup data
        fetch("https://localhost:7157/api/admin/checkup")
            .then((response) => response.json())
            .then((data) => {
                // Ensure that the data fetched is an array
                console.log(data)
                if (Array.isArray(data.checkups)) {
                    setCheckups(data.checkups);
                } else {
                    setCheckups([]);  // Set as an empty array if data is not an array
                }
            })
            .catch((error) => console.error("Error fetching checkups:", error));
    }, []);

    const handleAddCheckup = (checkupData) => {
        console.log("Submitting checkup data:", checkupData);

        const formattedStartTime = `${checkupData.startTime}:00`;
        const formattedEndTime = `${checkupData.endTime}:00`;

        const payload = {
            name: checkupData.name,
            phone: checkupData.phone,
            date: checkupData.date,
            startTime: formattedStartTime,  
            endTime: formattedEndTime,
            room: checkupData.room,
            doctorId: parseInt(checkupData.doctorId),
            treatmentId: parseInt(checkupData.treatmentId)
        };
        fetch("https://localhost:7157/api/admin/checkup", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(payload),
        })
            .then((response) => response.json())
            .then(() => refetchCheckUpData())
            .catch((error) => console.error("Error adding checkup:", error));
    };

    const refetchCheckUpData = () => {
        fetch("https://localhost:7157/api/admin/checkup")
        .then((response) => response.json())
        .then((updatedData) => {
            if (Array.isArray(updatedData.checkups)) {
                setCheckups(updatedData.checkups);
            }
        })
        .catch((error) => console.error("Error fetching updated schedule:", error));
    };

    return (
        <div className="content">
            <div className="container">
                <h1>Danh sách ca khám</h1>
                <button className="register-button" onClick={() => setIsModalOpen(true)}>
                    Đăng ký ca khám mới
                </button>
                <br />
                <br />
                <input type="text" placeholder="Tìm kiếm theo SDT" className="search-bar" />
                <table>
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên bệnh nhân</th>
                            <th>Số điện thoại</th>
                            <th>Ngày khám</th>
                            <th>Thời gian khám</th>
                            <th>Bác sĩ khám</th>
                            <th>Dịch vụ khám</th>
                            <th>Phòng khám</th>
                        </tr>
                    </thead>
                    <tbody>
                        {/* Check if checkups is an array before using map */}
                        {Array.isArray(checkups) && checkups.map((checkup, index) => (
                            <tr key={index}>
                                <td>{index + 1}</td>
                                <td>{checkup.name}</td>
                                <td>{checkup.phone}</td>
                                <td>{checkup.appointmentDate}</td>
                                <td>{`${checkup.startTime} - ${checkup.endTime}`}</td>
                                <td>{checkup.doctorName}</td>
                                <td>{checkup.treatmentName}</td>
                                <td>{checkup.room}</td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                <CheckUpModal
                    isOpen={isModalOpen}
                    onClose={() => setIsModalOpen(false)}
                    onSubmit={handleAddCheckup}
                />
            </div>
        </div>
    );
};

export default CheckUp;
