import React, { useState, useEffect } from 'react';
import '../../admin_assets/css/medicine.css';
import MedicineModal from '../../components/MedicineModal';

const Medicine = () => {
    const [medicines, setMedicines] = useState([]);
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [selectedMedicine, setSelectedMedicine] = useState(null); // State for the selected medicine

    useEffect(() => {
        fetchMedicines();
    }, []);

    const fetchMedicines = async () => {
        try {
            const response = await fetch('https://localhost:7157/api/admin/medicine');
            const data = await response.json();
            if (data.success) {
                setMedicines(data.medicines);
            } else {
                alert("No medicines found.");
            }
        } catch (error) {
            console.error("Error fetching medicines:", error);
        }
    };

    const handleOpenModal = (medicine) => {
        setSelectedMedicine(medicine); // Set the selected medicine to the state
        setIsModalOpen(true);
    };

    const handleCloseModal = () => {
        setSelectedMedicine(null); // Reset selected medicine when closing
        setIsModalOpen(false);
    };

    const handleAddMedicine = async (formData) => {
        const payload = {
            name: formData.name,
            available: formData.available,
            total: formData.total,
            expiredDate: formData.expiredDate,
        };

        try {
            const response = await fetch('https://localhost:7157/api/admin/medicine', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
            });
            const data = await response.json();
            if (data.success) {
                fetchMedicines(); // Refresh medicine list
            } else {
                alert("Failed to add medicine.");
            }
        } catch (error) {
            console.error("Error adding medicine:", error);
        }
    };

    const handleEditMedicine = async (formData) => {
        const payload = {
            id: selectedMedicine.id, // Include the medicine ID
            name: formData.name,
            available: formData.available,
            total: formData.total,
            expiredDate: formData.expiredDate,
        };

        try {
            const response = await fetch(`https://localhost:7157/api/admin/medicine/${selectedMedicine.id}`, {
                method: 'PUT', // Update request
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload),
            });
            const data = await response.json();
            if (data.success) {
                fetchMedicines(); // Refresh medicine list
            } else {
                alert("Failed to update medicine.");
            }
        } catch (error) {
            console.error("Error updating medicine:", error);
        }
    };

    return (
        <div className="medicine-container">
            <h2>Kho Thuốc</h2>
            <button onClick={() => handleOpenModal(null)} className="create-medicine-button">
                Thêm Thuốc Vào Kho
            </button>
            <div className="medicine-grid">
                {medicines.map((medicine) => (
                    <div key={medicine.id} className="medicine-card" onClick={() => handleOpenModal(medicine)}>
                        <h3>{medicine.name}</h3>
                        <p>Còn lại: <span style={{color: 'red', fontSize: '20px'}}>{medicine.available}</span></p>
                        <p>Tổng Số: {medicine.total}</p>
                        <p>Ngày Hết Hạn: {medicine.expiredDate}</p>
                    </div>
                ))}
            </div>
            <MedicineModal
                isOpen={isModalOpen}
                onClose={handleCloseModal}
                onSubmit={selectedMedicine ? handleEditMedicine : handleAddMedicine}
                editingMedicine={selectedMedicine} // Pass the selected medicine to the modal
            />
        </div>
    );
};

export default Medicine;
