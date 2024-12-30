import React, { useEffect, useState } from 'react';
import '../../admin_assets/css/medicalrecord.css';
import RecordModal from '../../components/RecordModal';

const MedicalRecord = () => {
    const [records, setRecords] = useState([]);
    const [selectedRecord, setSelectedRecord] = useState(null);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [selectedName, setSelectedName] = useState('');
    const [selectedDate, setSelectedDate] = useState('');
    const [uniqueNames, setUniqueNames] = useState([]);
    const [uniqueDates, setUniqueDates] = useState([]);

    // Function to fetch records
    const fetchRecords = async () => {
        try {
            const response = await fetch('https://localhost:7157/api/admin/record');
            const data = await response.json();
            if (data.success) {
                setRecords(data.records);
            } else {
                alert(data.message);
            }
        } catch (error) {
            console.error('Error fetching records:', error);
        }
    };

    // Initial fetch on component mount
    useEffect(() => {
        fetchRecords();
    }, []);

    // Compute unique names and dates whenever records change
    useEffect(() => {
        const getUniqueNames = records => Array.from(new Set(records.map(record => record.customerName)));
        const getUniqueDates = records => Array.from(new Set(records.map(record => new Date(record.recordDate).toLocaleDateString())));

        setUniqueNames(getUniqueNames(records));
        setUniqueDates(getUniqueDates(records));
    }, [records]);

    // Handle record selection
    const handleRecordSelect = (event) => {
        const recordId = event.target.value;
        const record = records.find((r) => r.id === parseInt(recordId));
        setSelectedRecord(record);
    };

    const handleUpdateRecord = (updatedRecord) => {
        // Re-fetch records to get updated data
        fetchRecords();
        // Close modal after submitting
        setIsModalOpen(false);
    };

    const filteredRecords = records.filter(record => {
        const nameMatch = selectedName ? record.customerName.includes(selectedName) : true;
        const recordDate = new Date(record.recordDate).toLocaleDateString();
        const dateMatch = selectedDate ? recordDate === selectedDate : true;
        return nameMatch && dateMatch;
    });

    const handleOpenModal = () => {
        setIsModalOpen(true);
    };

    return (
        <div className="content">
            <h1>Hồ Sơ Khám Bệnh</h1>
            <div className="modal-open-button">
                <button className="record-button" onClick={handleOpenModal}>Tạo Hồ Sơ</button>
            </div>
            <br />
            <div className="filter-container">
                <div className="dropdown-container">
                    <label htmlFor="nameDropdown">Theo Tên Hồ Sơ:</label>
                    <select
                        className="record-select"
                        id="nameDropdown"
                        onChange={(e) => setSelectedName(e.target.value)}
                        value={selectedName}
                    >
                        <option value="">Tất Cả</option>
                        {uniqueNames.map((name, index) => (
                            <option key={index} value={name}>
                                {name}
                            </option>
                        ))}
                    </select>
                </div>
                <div className="dropdown-container">
                    <label htmlFor="dateDropdown">Theo Ngày :</label>
                    <select
                        className="record-select"
                        id="dateDropdown"
                        onChange={(e) => setSelectedDate(e.target.value)}
                        value={selectedDate}
                    >
                        <option value="">Tất Cả</option>
                        {uniqueDates.map((date, index) => (
                            <option key={index} value={date}>
                                {date}
                            </option>
                        ))}
                    </select>
                </div>
            </div>
            <div className="record-container">
                <div className="dropdown-container">
                    <label htmlFor="recordDropdown">Vui Lòng Chọn Hồ Sơ:</label>
                    <select
                        className="record-select"
                        id="recordDropdown"
                        onChange={handleRecordSelect}
                        value={selectedRecord ? selectedRecord.id : ''}
                    >
                        <option value="" disabled></option>
                        {filteredRecords.map((record) => (
                            <option key={record.id} value={record.id}>
                                {record.customerName} - {new Date(record.recordDate).toLocaleDateString()}
                            </option>
                        ))}
                    </select>
                </div>
                <div className="record-details-container">
                    {selectedRecord ? (
                        <div className="record-details">
                            <h2><i>Chi Tiết Hồ Sơ</i></h2>
                            <p><strong>Tên Khách Hàng:</strong> {selectedRecord.customerName}</p>
                            <p><strong>Ngày Lập Hồ Sơ:</strong> {new Date(selectedRecord.recordDate).toLocaleDateString()}</p>
                            <p><strong>Thông Tin Chi Tiết:</strong> {selectedRecord.description}</p>
                            <p><strong>Toa Thuốc:</strong></p>
                            <ul>
                                {selectedRecord.medicines.map(medicine => (
                                    <li key={medicine.medicineId}>
                                        {medicine.medicineName} - Số lượng: {medicine.quantity}
                                    </li>
                                ))}
                            </ul>
                        </div>
                    ) : (
                        <p>Hãy Chọn Một Hồ Sơ Để Xem Thông Tin.</p>
                    )}
                </div>
            </div>
            <RecordModal
                isOpen={isModalOpen}
                onClose={() => setIsModalOpen(false)}
                onSubmit={handleUpdateRecord}
            />
        </div>
    );
};

export default MedicalRecord;
