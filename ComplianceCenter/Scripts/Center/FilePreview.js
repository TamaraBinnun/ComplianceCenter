// ====================================================
// FilePreview.js - תצוגה מקדימה של קבצים
// ====================================================

let currentRotation = 0;
let currentFileUrl = '';
let currentFileName = '';
let currentFileType = '';

/**
 * פתיחת תצוגה מקדימה של קובץ
 */
function openFilePreview(fileUrl, fileName, fileType) {
    currentFileUrl = fileUrl;
    currentFileName = fileName;
    currentFileType = fileType.toLowerCase();
    currentRotation = 0;

    // עדכון כותרת
    $('#previewFileName').text(fileName);

    // איפוס מצב
    resetPreviewModal();

    // הצגת loader
    $('#previewLoader').removeClass('d-none');

    // הצגת המודל
    const modal = new bootstrap.Modal(document.getElementById('filePreviewModal'));
    modal.show();

    // טעינת הקובץ לפי סוג
    setTimeout(() => {
        loadFilePreview(fileUrl, fileType);
    }, 300);
}

/**
 * איפוס המודל
 */
function resetPreviewModal() {
    $('#imagePreviewContainer').addClass('d-none');
    $('#pdfPreviewContainer').addClass('d-none');
    $('#previewError').addClass('d-none');
    $('#previewLoader').removeClass('d-none');
    currentRotation = 0;
}

/**
 * טעינת הקובץ לתצוגה
 */
function loadFilePreview(fileUrl, fileType) {
    const extension = fileType.toLowerCase().replace('.', '');

    try {
        if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].includes(extension)) {
            // תמונה
            loadImagePreview(fileUrl);
        } else if (extension === 'pdf') {
            // PDF
            loadPDFPreview(fileUrl);
        } else {
            // לא נתמך
            showPreviewError();
        }
    } catch (error) {
        console.error('Preview error:', error);
        showPreviewError();
    }
}

/**
 * טעינת תמונה
 */
function loadImagePreview(imageUrl) {
    const img = new Image();

    img.onload = function () {
        $('#previewImage').attr('src', imageUrl);
        $('#previewImage').css('transform', 'rotate(0deg)');

        $('#previewLoader').addClass('d-none');
        $('#imagePreviewContainer').removeClass('d-none');
    };

    img.onerror = function () {
        console.error('Failed to load image:', imageUrl);
        showPreviewError();
    };

    img.src = imageUrl;
}

/**
 * טעינת PDF
 */
function loadPDFPreview(pdfUrl) {
    // הוספת viewer parameter לחלק מהדפדפנים
    const viewerUrl = pdfUrl + '#toolbar=1&navpanes=0&scrollbar=1';

    $('#previewPDF').attr('src', viewerUrl);

    // המתנה קצרה ואז הצגה
    setTimeout(() => {
        $('#previewLoader').addClass('d-none');
        $('#pdfPreviewContainer').removeClass('d-none');
    }, 500);
}

/**
 * הצגת שגיאה
 */
function showPreviewError() {
    $('#previewLoader').addClass('d-none');
    $('#previewError').removeClass('d-none');
}

/**
 * סיבוב תמונה
 */
function rotatePreviewImage(degrees) {
    currentRotation += degrees;
    if (currentRotation >= 360) currentRotation -= 360;
    if (currentRotation < 0) currentRotation += 360;

    $('#previewImage').css('transform', `rotate(${currentRotation}deg)`);
}

/**
 * זום על תמונה
 */
function toggleImageZoom(img) {
    if (img.style.cursor === 'zoom-in') {
        img.style.cursor = 'zoom-out';
        img.style.maxHeight = 'none';
        img.style.maxWidth = '100%';
    } else {
        img.style.cursor = 'zoom-in';
        img.style.maxHeight = '70vh';
        img.style.maxWidth = '100%';
    }
}

/**
 * הורדת קובץ מהתצוגה המקדימה
 */
function downloadPreviewFile() {
    if (!currentFileUrl) {
        alert('שגיאה: כתובת קובץ לא נמצאה');
        return;
    }

    // יצירת קישור זמני להורדה
    const link = document.createElement('a');
    link.href = currentFileUrl;
    link.download = currentFileName || 'file';
    link.target = '_blank';

    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

/**
 * טיפול במקש ESC
 */
$(document).on('keydown', function (e) {
    if (e.key === 'Escape') {
        const modal = bootstrap.Modal.getInstance(document.getElementById('filePreviewModal'));
        if (modal) {
            modal.hide();
        }
    }
});

/**
 * ניקוי כשהמודל נסגר
 */
$('#filePreviewModal').on('hidden.bs.modal', function () {
    resetPreviewModal();
    currentFileUrl = '';
    currentFileName = '';
    currentFileType = '';
});