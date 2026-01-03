<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SmartCertUpload.ascx.cs" Inherits="ComplianceCenter.Controls.SmartCertUpload" %>

<link href="../Styles/SmartCertUpload.css" rel="stylesheet" />
<!-- jQuery (CDN) -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js" crossorigin="anonymous"></script>

<!-- הסקריפט שלך -->
<script src="../Scripts/Center/SmartCertUpload.js"></script>

<div class="smart-cert-upload-wrapper">
    <!-- שלב 1: העלאת תמונה/מסמך -->
    <div id="step1Upload" class="upload-step active-step">
        <div class="step-header">
            <div class="step-icon">
                <i class="fas fa-cloud-upload-alt"></i>
            </div>
            <div class="step-title">
                <h4>שלב 1: העלה תעודה/תמונה</h4>
                <p class="text-muted">העלה תמונה ברורה או PDF של התעודה</p>
            </div>
        </div>

        <!-- Drag & Drop Zone -->
        <div class="drop-zone-smart" id="dropZoneSmart">
            <div class="drop-zone-content">
                <i class="fas fa-file-upload drop-icon-animated"></i>
                <h5>גרור קובץ לכאן או לחץ לבחירה</h5>
                <p class="text-muted mb-3">תומך ב-JPG, PNG, PDF • עד 5MB</p>
                
                <asp:FileUpload ID="fileUploadSmart" runat="server" 
                    CssClass="file-input-hidden" 
                    accept="image/*,application/pdf"
                    onchange="handleFileSelectSmart(this)" />
                
                <button type="button" class="btn btn-outline-primary" 
                    onclick="$('#<%=fileUploadSmart.ClientID%>').click();">
                    <i class="fas fa-folder-open"></i> בחר קובץ
                </button>
            </div>
        </div>

        <!-- תצוגה מקדימה של הקובץ -->
        <div id="previewSection" class="preview-section" style="display:none;">
            <div class="preview-card">
                <div class="preview-header">
                    <h5><i class="fas fa-eye"></i> תצוגה מקדימה</h5>
                    <button type="button" class="btn btn-sm btn-danger" onclick="removeFileSmart()">
                        <i class="fas fa-times"></i> הסר
                    </button>
                </div>
                <div class="preview-content" id="previewContent">
                    <!-- כאן תופיע התמונה/PDF -->
                </div>
                <div class="file-info">
                    <div class="file-name" id="fileNameDisplay"></div>
                    <div class="file-size" id="fileSizeDisplay"></div>
                </div>
            </div>
        </div>

        <!-- כפתור ניתוח -->
        <div class="analyze-section" id="analyzeSection" style="display:none;">
            <asp:Button ID="btnAnalyzeAI" runat="server" CssClass="btn btn-ai-analyze" 
                Text="🧠 נתח עם AI" OnClientClick="return startAIAnalysis();" />  
            <p class="text-center text-muted mt-2">
                <small> AI ינתח את התעודה ויזהה את כל הפרטים אוטומטית</small>
            </p>
        </div>
    </div>

    <!-- שלב 2: ניתוח AI -->
    <div id="step2Analysis" class="analysis-step" style="display:none;">
        <div class="ai-analysis-container">
            <div class="ai-brain-animation">
                <i class="fas fa-brain rotating-brain-icon"></i>
                <div class="pulse-wave"></div>
                <div class="pulse-wave delay-1"></div>
                <div class="pulse-wave delay-2"></div>
            </div>
            <h4 class="analysis-title">AI מנתח את התעודה...</h4>
            <div class="progress-bar-smart">
                <div class="progress-fill" id="progressFill"></div>
            </div>
            <p class="analysis-status" id="analysisStatus">מזהה טקסט...</p>
        </div>
    </div>

    <!-- שלב 3: תוצאות + שמירה -->
    <div id="step3Results" class="results-step" style="display:none;">
        <div class="success-banner">
            <i class="fas fa-check-circle success-icon-large"></i>
            <h4>ניתוח הושלם בהצלחה!</h4>
            <p class="text-muted">AI זיהה את הפרטים הבאים:</p>
        </div>

        <div class="row">
            <!-- עמודה שמאל: נתוני AI -->
            <div class="col-lg-6">
                <div class="ai-detected-card">
                    <h5 class="card-title-smart">
                        <i class="fas fa-robot text-primary"></i>
                        נתונים שזוהו על ידי AI
                    </h5>

                    <div class="detected-field-group">
                        <label class="detected-label">
                            <i class="fas fa-certificate"></i> סוג הסמכה:
                        </label>
                        <asp:TextBox ID="txtAIDetectedType" runat="server" CssClass="form-control detected-input" ReadOnly="true" />
                        <span class="confidence-badge high">✓ דיוק גבוה</span>
                    </div>

                    <div class="detected-field-group">
                        <label class="detected-label">
                            <i class="fas fa-id-card"></i> מספר תעודה:
                        </label>
                        <asp:TextBox ID="txtAIDetectedNumber" runat="server" CssClass="form-control detected-input" ReadOnly="true" />
                        <span class="confidence-badge high">✓ דיוק גבוה</span>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="detected-field-group">
                                <label class="detected-label">
                                    <i class="fas fa-calendar-plus"></i> תאריך הנפקה:
                                </label>
                                <asp:TextBox ID="txtAIDetectedIssue" runat="server" CssClass="form-control detected-input" ReadOnly="true" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="detected-field-group">
                                <label class="detected-label">
                                    <i class="fas fa-calendar-times"></i> תאריך תפוגה:
                                </label>
                                <asp:TextBox ID="txtAIDetectedExpiry" runat="server" CssClass="form-control detected-input" ReadOnly="true" />
                            </div>
                        </div>
                    </div>

                    <div class="detected-field-group">
                        <label class="detected-label">
                            <i class="fas fa-align-left"></i> טקסט מלא:
                        </label>
                        <asp:TextBox ID="txtAIRawText" runat="server" TextMode="MultiLine" 
                            Rows="4" CssClass="form-control detected-input" ReadOnly="true" />
                    </div>
                </div>
            </div>

            <!-- עמודה ימין: שמירה -->
            <div class="col-lg-6">
                <div class="save-card">
                    <h5 class="card-title-smart">
                        <i class="fas fa-save text-success"></i>
                        שמירה למערכת
                    </h5>

                    <div class="mb-3">
                        <label class="form-label">סוג הסמכה:</label>
                        <asp:DropDownList ID="ddlCertificationType" runat="server" CssClass="form-select" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">מספר תעודה:</label>
                        <asp:TextBox ID="txtCertificateNumber" runat="server" CssClass="form-control" />
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">תאריך הנפקה:</label>
                            <asp:TextBox ID="txtIssueDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">תאריך תפוגה:</label>
                            <asp:TextBox ID="txtExpiryDate" runat="server" CssClass="form-control" TextMode="Date" />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">הערות:</label>
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" 
                            Rows="3" CssClass="form-control" />
                    </div>

                    <!-- כפתורי פעולה -->
                    <div class="action-buttons-smart">
                        <asp:Button ID="btnSaveCertification" runat="server" CssClass="btn btn-success flex-fill" 
                            Text="💾 שמור הסמכה" 
                            OnClientClick="return validateCertificationForm();"
                            OnClick="btnSaveCertification_Click" />
                        <button type="button" class="btn btn-secondary" onclick="resetSmartUpload()">
                            <i class="fas fa-redo"></i> נתח תעודה נוספת
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- הודעות -->
    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert-smart mt-3">
        <i class="fas fa-info-circle"></i>
        <asp:Label ID="lblMessage" runat="server" />
    </asp:Panel>

    <!-- Hidden Fields לשמירת מצב -->
    <asp:HiddenField ID="hdnUploadedFileName" runat="server" />
    <asp:HiddenField ID="hdnAIAnalysisComplete" runat="server" Value="false" />
</div>

