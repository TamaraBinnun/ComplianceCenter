// ====================================================
// SmartCertUpload.js - אינטראקטיביות מלאה + API Calls
// ====================================================

let selectedFileSmart = null;
let previewUrlSmart = null;
let analysisInProgress = false;

$(document).ready(function () {
    initSmartCertUpload();
});

function initSmartCertUpload() {
    setupDragAndDropSmart();
}

// ============================================
// Drag & Drop
// ============================================
function setupDragAndDropSmart() {
    const dropZone = document.getElementById('dropZoneSmart');
    if (!dropZone) return;

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, function (e) {
            e.preventDefault();
            e.stopPropagation();
        }, false);
    });

    ['dragenter', 'dragover'].forEach(eventName => {
        dropZone.addEventListener(eventName, function () {
            dropZone.classList.add('dragover');
        }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        dropZone.addEventListener(eventName, function () {
            dropZone.classList.remove('dragover');
        }, false);
    });

    dropZone.addEventListener('drop', function (e) {
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            const fileInput = document.querySelector('[id*="fileUploadSmart"]');
            if (fileInput) {
                fileInput.files = files;
                handleFileSelectSmart(fileInput);
            }
        }
    }, false);
}

// ============================================
// טיפול בבחירת קובץ
// ============================================
function handleFileSelectSmart(input) {
    if (!input.files || input.files.length === 0) return;

    const file = input.files[0];
    selectedFileSmart = file;

    // ולידציה בצד לקוח
    if (!validateFileSmart(file)) {
        removeFileSmart();
        return;
    }

    // הצגת פרטי הקובץ
    displayFileInfoSmart(file);

    // יצירת תצוגה מקדימה
    createPreviewSmart(file);

    // הצגת כפתור ניתוח
    $('#analyzeSection').slideDown(400);
}

function validateFileSmart(file) {
    const allowedTypes = ['application/pdf', 'image/jpeg', 'image/jpg', 'image/png'];
    const maxSize = 5 * 1024 * 1024; // 5MB

    if (!allowedTypes.includes(file.type)) {
        alert('סוג קובץ לא נתמך. רק PDF, JPG, PNG מותרים');
        return false;
    }

    if (file.size > maxSize) {
        alert('הקובץ גדול מדי. גודל מקסימלי: 5MB');
        return false;
    }

    return true;
}

function displayFileInfoSmart(file) {
    $('#fileNameDisplay').text(file.name);
    $('#fileSizeDisplay').text(formatFileSizeSmart(file.size));
    $('#previewSection').slideDown(400);
}

function createPreviewSmart(file) {
    const previewContent = document.getElementById('previewContent');
    previewContent.innerHTML = '<div class="spinner-border text-primary" role="status"><span class="visually-hidden">טוען...</span></div>';

    if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = function (e) {
            previewUrlSmart = e.target.result;
            previewContent.innerHTML = `
                <img src="${e.target.result}" alt="Preview" 
                    style="max-width: 100%; max-height: 400px; border-radius: 10px;" 
                    class="fade-in" />
            `;
        };
        reader.readAsDataURL(file);
    } else if (file.type === 'application/pdf') {
        const reader = new FileReader();
        reader.onload = function (e) {
            previewUrlSmart = e.target.result;
            previewContent.innerHTML = `
                <embed src="${e.target.result}" type="application/pdf" 
                    width="100%" height="400px" style="border-radius: 10px;" />
            `;
        };
        reader.readAsDataURL(file);
    } else {
        previewContent.innerHTML = '<i class="fas fa-file fa-5x text-muted"></i>';
    }
}

function removeFileSmart() {
    selectedFileSmart = null;
    previewUrlSmart = null;

    const fileInput = document.querySelector('[id*="fileUploadSmart"]');
    if (fileInput) fileInput.value = '';

    $('#previewSection').slideUp(400);
    $('#analyzeSection').slideUp(400);
}

function formatFileSizeSmart(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
}

// ============================================
// התחלת ניתוח AI - קריאה ל-API
// ============================================
function startAIAnalysis() {
    if (!selectedFileSmart) {
        alert('אנא בחר קובץ תחילה');
        return false;
    }

    if (analysisInProgress) {
        alert('ניתוח כבר מתבצע, אנא המתן...');
        return false;
    }

    analysisInProgress = true;

    // הצגת אינדיקטור טעינה בכפתור
    const btn = document.querySelector('[id*="btnAnalyzeAI"]');
    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>מנתח...';
    }

    // הצגת שלב 2 - אנימציית ניתוח
    $('#step1Upload').fadeOut(200, function () {
        $('#step2Analysis').fadeIn(200);
        simulateAIAnalysisSteps();
    });

    // קריאה ל-API
    sendFileToAPI()
        .then(handleAPISuccess)
        .catch(handleAPIError);

    return false; // מונע postback
}

// ============================================
// שליחת קובץ ל-Web API
// ============================================
function sendFileToAPI() {
    return new Promise((resolve, reject) => {
        const formData = new FormData();
        formData.append('file', selectedFileSmart);

        // הוספת EmployeeID אם קיים
        const employeeId = document.getElementById('hdnEmployeeId')?.value || '0';
        formData.append('employeeId', employeeId);

        // קריאת AJAX
        $.ajax({
            url: '/api/aianalyzer/analyze',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            timeout: 60000, // 30 שניות
            success: function (response) {
                if (response.success) {
                    resolve(response.data);
                } else {
                    reject(new Error(response.message || 'שגיאה בניתוח'));
                }
            },
            error: function (xhr, status, error) {
                reject(new Error(getErrorMessage(xhr, status, error)));
            }
        });
    });
}

// ============================================
// טיפול בהצלחה
// ============================================
function handleAPISuccess(data) {
    analysisInProgress = false;

    console.log('AI Analysis Result:', data);

    // מילוי שדות AI (לתצוגה)
    $('[id*="txtAIDetectedType"]').val(data.certificationType || 'לא זוהה');
    $('[id*="txtAIDetectedNumber"]').val(data.certificateNumber || 'לא זוהה');
    $('[id*="txtAIDetectedIssue"]').val(data.issueDate || 'לא זוהה');
    $('[id*="txtAIDetectedExpiry"]').val(data.expiryDate || 'לא זוהה');
    $('[id*="txtAIRawText"]').val(data.fullText || 'לא זוהה טקסט');

    // מילוי שדות לעריכה
    $('[id*="txtCertificateNumber"]').val(data.certificateNumber || '');
    $('[id*="txtIssueDate"]').val(data.issueDate || '');
    $('[id*="txtExpiryDate"]').val(data.expiryDate || '');

    // שמירת שם הקובץ הזמני
    $('[id*="hdnUploadedFileName"]').val(data.tempFileName || '');

    // ניסיון לבחור סוג הסמכה מתאים
    trySelectCertificationType(data.certificationType);

    // מעבר לשלב 3
    showResultsStepSmart();
}

// ============================================
// טיפול בשגיאה
// ============================================
function handleAPIError(error) {
    analysisInProgress = false;

    console.error('AI Analysis Error:', error);

    // איפוס כפתור
    const btn = document.querySelector('[id*="btnAnalyzeAI"]');
    if (btn) {
        btn.disabled = false;
        btn.innerHTML = '🧠 נתח עם AI';
    }

    // הסתרת שלב 2
    $('#step2Analysis').fadeOut(200, function () {
        $('#step1Upload').fadeIn(200);
    });

    // הצגת שגיאה
    alert(`שגיאה בניתוח: ${error.message || 'שגיאה לא ידועה'}\n\nנסה שוב או צור קשר עם התמיכה.`);
}

function getErrorMessage(xhr, status, error) {
    if (status === 'timeout') {
        return 'פג זמן הבקשה. אנא נסה שוב.';
    }

    if (xhr.responseJSON && xhr.responseJSON.message) {
        return xhr.responseJSON.message;
    }

    if (xhr.responseJSON && xhr.responseJSON.error) {
        return xhr.responseJSON.error;
    }

    if (xhr.status === 0) {
        return 'אין חיבור לשרת. בדוק את חיבור האינטרנט.';
    }

    return error || 'שגיאה לא ידועה';
}

// ============================================
// סימולציה של שלבי ניתוח (ויזואלי בלבד)
// ============================================
function simulateAIAnalysisSteps() {
    const steps = [
        'מעלה קובץ לשרת...',
        'מזהה טקסט באמצעות OCR...',
        'מנתח מבנה מסמך...',
        'מחלץ תאריכים...',
        'מזהה סוג הסמכה...',
        'משלים ניתוח...'
    ];

    let currentStep = 0;
    const interval = setInterval(function () {
        if (currentStep < steps.length) {
            $('#analysisStatus').text(steps[currentStep]);
            currentStep++;
        } else {
            clearInterval(interval);
        }
    }, 600);
}

// ============================================
// בחירה אוטומטית של סוג הסמכה
// ============================================
function trySelectCertificationType(detectedType) {
    if (!detectedType || detectedType === 'לא זוהה') return;

    const dropdown = $('[id*="ddlCertificationType"]');
    if (!dropdown.length) return;

    // חיפוש התאמה
    dropdown.find('option').each(function () {
        const optionText = $(this).text().toLowerCase();
        const detected = detectedType.toLowerCase();

        if (optionText.includes(detected) || detected.includes(optionText)) {
            dropdown.val($(this).val());
            return false; // break
        }
    });
}

// ============================================
// הצגת תוצאות
// ============================================
function showResultsStepSmart() {
    $('#step2Analysis').fadeOut(400, function () {
        $('#step3Results').fadeIn(400);
        confettiAnimation();
    });
}

function confettiAnimation() {
    const successIcon = document.querySelector('.success-icon-large');
    if (successIcon) {
        successIcon.classList.add('bounce');
        setTimeout(() => {
            successIcon.classList.remove('bounce');
        }, 600);
    }
}

// ============================================
// איפוס המערכת
// ============================================
function resetSmartUpload() {
    selectedFileSmart = null;
    previewUrlSmart = null;
    analysisInProgress = false;

    const fileInput = document.querySelector('[id*="fileUploadSmart"]');
    if (fileInput) fileInput.value = '';

    $('#previewSection').hide();
    $('#analyzeSection').hide();
    $('#step2Analysis').hide();
    $('#step3Results').hide();
    $('#step1Upload').fadeIn(400);

    $('[id*="pnlMessage"]').fadeOut();

    const btn = document.querySelector('[id*="btnAnalyzeAI"]');
    if (btn) {
        btn.disabled = false;
        btn.innerHTML = '🧠 נתח עם AI';
    }

    $('#addCertModal').modal('hide');
    $('.modal-backdrop').remove();
}

// ============================================
// ולידציה לפני שמירה
// ============================================
function validateCertificationForm() {
    const certType = $('[id*="ddlCertificationType"]').val();
    const certNumber = $('[id*="txtCertificateNumber"]').val();
    const issueDate = $('[id*="txtIssueDate"]').val();
    const expiryDate = $('[id*="txtExpiryDate"]').val();

    // בדיקת שדות חובה
    if (certType === '0' || certType === '') {
        alert('יש לבחור סוג הסמכה');
        $('[id*="ddlCertificationType"]').focus();
        return false;
    }

    if (!certNumber) {
        alert('יש למלא מספר תעודה');
        $('[id*="txtCertificateNumber"]').focus();
        return false;
    }

    if (!issueDate) {
        alert('יש למלא תאריך הנפקה');
        $('[id*="txtIssueDate"]').focus();
        return false;
    }

    if (!expiryDate) {
        alert('יש למלא תאריך תפוגה');
        $('[id*="txtExpiryDate"]').focus();
        return false;
    }

    // ✅ בדיקת תקינות התאריכים - זה חסר!
    const issue = new Date(issueDate);
    const expiry = new Date(expiryDate);

    if (isNaN(issue.getTime()) || isNaN(expiry.getTime())) {
        alert('תאריכים לא תקינים');
        return false;
    }

    if (expiry <= issue) {
        alert('תאריך התפוגה חייב להיות אחרי תאריך ההנפקה');
        $('[id*="txtExpiryDate"]').focus();
        return false;
    }

    console.log('Validation passed!');

    // ✅ רק אם הולידציה עברה - שנה את הכפתור
    setTimeout(function () {
        const btn = document.querySelector('[id*="btnSaveCertification"]');
        if (btn) {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>שומר...';
        }
    }, 0);

    return true;
   
}

// ============================================
// העתקה ללוח
// ============================================
function copyToClipboard(text) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(text).then(() => {
            showToastSmart('הועתק ללוח!', 'success');
        });
    } else {
        // fallback
        const textarea = document.createElement('textarea');
        textarea.value = text;
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);
        showToastSmart('הועתק ללוח!', 'success');
    }
}

// ============================================
// Toast הודעות
// ============================================
function showToastSmart(message, type) {
    const toastHtml = `
        <div class="toast-smart ${type}" style="
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: ${type === 'success' ? '#28a745' : '#dc3545'};
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            z-index: 9999;
            animation: slideInDown 0.5s ease;
        ">
            <i class="fas fa-${type === 'success' ? 'check' : 'times'}-circle me-2"></i>
            ${message}
        </div>
    `;

    $('body').append(toastHtml);

    setTimeout(() => {
        $('.toast-smart').fadeOut(400, function () {
            $(this).remove();
        });
    }, 3000);
}

// ============================================
// Keyboard Shortcuts
// ============================================
$(document).on('keydown', function (e) {
    // Ctrl + U = פתיחת בחירת קובץ
    if (e.ctrlKey && e.key === 'u') {
        e.preventDefault();
        const fileInput = document.querySelector('[id*="fileUploadSmart"]');
        if (fileInput) fileInput.click();
    }

    // Escape = איפוס
    if (e.key === 'Escape') {
        if ($('#step3Results').is(':visible')) {
            if (confirm('האם לאפס ולהעלות תעודה נוספת?')) {
                resetSmartUpload();
            }
        }
    }
});

// ============================================
// הסתרה אוטומטית של הודעות
// ============================================
$(document).ready(function () {
    setTimeout(() => {
        $('.alert-smart').fadeOut(400);
    }, 5000);
});