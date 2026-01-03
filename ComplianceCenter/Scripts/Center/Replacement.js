// Replacements.js - אינטראקטיביות ואנימציות מתקדמות

$(document).ready(function () {
    initReplacements();
});

function initReplacements() {
    animateScoreCircles();
    initConfirmations();
    initTooltips();
    initCardAnimations();
    autoHideMessages();
}

// אנימציה לעיגולי הציון
function animateScoreCircles() {
    $('.score-circle').each(function (index) {
        var $circle = $(this);
        var score = $circle.closest('.confidence-badge').data('score');

        // צבע דינמי על פי הציון
        var color = getScoreColor(score);
        $circle.find('.score-value').css({
            'background': color,
            '-webkit-background-clip': 'text',
            '-webkit-text-fill-color': 'transparent'
        });

        // אנימציה מספרים
        animateNumber($circle.find('.score-value'), 0, score, 1500, index * 100);
    });
}

// אנימציה למוטות הציונים
function animateScoreBars() {
    $('.score-fill').each(function (index) {
        var $bar = $(this);
        var width = $bar.css('width');

        $bar.css('width', '0');

        setTimeout(function () {
            $bar.animate({
                width: width
            }, 1000, 'easeOutCubic');
        }, index * 100);
    });
}

// פונקציה לאנימציה של מספרים
function animateNumber($element, start, end, duration, delay) {
    setTimeout(function () {
        $({ counter: start }).animate({ counter: end }, {
            duration: duration,
            easing: 'swing',
            step: function () {
                $element.text(Math.ceil(this.counter));
            },
            complete: function () {
                $element.text(Math.round(end));
            }
        });
    }, delay || 0);
}

// קבלת צבע על פי ציון
function getScoreColor(score) {
    if (score >= 85) return 'linear-gradient(135deg, #28a745 0%, #20c997 100%)';
    if (score >= 70) return 'linear-gradient(135deg, #17a2b8 0%, #5bc0de 100%)';
    if (score >= 60) return 'linear-gradient(135deg, #ffc107 0%, #ff9800 100%)';
    return 'linear-gradient(135deg, #dc3545 0%, #f44336 100%)';
}

// אישורים לפני פעולות
function initConfirmations() {
    // אישור לפני קבלה
    $('.btn-success').on('click', function (e) {
        var employeeName = $(this).closest('.replacement-card')
            .find('.employee-name').text();

        if (!confirm(`האם אתה בטוח שברצונך לשבץ את ${employeeName} למשמרת?`)) {
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    });

    // אישור לפני דחייה
    $('.btn-outline-danger').on('click', function (e) {
        var employeeName = $(this).closest('.replacement-card')
            .find('.employee-name').text();

        if (!confirm(`האם אתה בטוח שברצונך לדחות את ${employeeName}?`)) {
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
    });
}

// Tooltips
function initTooltips() {
    $('[data-bs-toggle="tooltip"]').tooltip();

    // Tooltip מותאם אישית לציונים
    $('.score-item').each(function () {
        var $item = $(this);
        var label = $item.find('.score-label-small').text();
        var score = $item.find('.score-num').text();

        $item.attr('title', `${label}: ${score} נקודות`)
            .tooltip({ placement: 'top' });
    });
}

// אנימציות לכרטיסים
function initCardAnimations() {
    // אנימציה בכניסה
    $('.replacement-card').each(function (index) {
        $(this).css({
            'animation-delay': (index * 0.1) + 's'
        });
    });

    // אפקט hover מתקדם
    $('.replacement-card').hover(
        function () {
            $(this).find('.score-circle').addClass('pulse-animation');
            animateScoreBars(); // מפעיל מחדש את אנימציית המוטות
        },
        function () {
            $(this).find('.score-circle').removeClass('pulse-animation');
        }
    );
}

// הסתרה אוטומטית של הודעות
function autoHideMessages() {
    setTimeout(function () {
        $('.alert').fadeOut('slow', function () {
            $(this).remove();
        });
    }, 5000);
}

// פילטר מהיר בצד לקוח
function quickFilter() {
    var minScore = $('#minScoreSlider').val();

    $('.replacement-card').each(function () {
        var score = $(this).data('score');

        if (score >= minScore) {
            $(this).parent().show();
        } else {
            $(this).parent().hide();
        }
    });
}

// מיון כרטיסים
function sortCards(sortBy) {
    var $container = $('#resultsContainer .row');
    var $cards = $container.children('.col-md-6');

    $cards.sort(function (a, b) {
        var scoreA = $(a).find('.replacement-card').data('score');
        var scoreB = $(b).find('.replacement-card').data('score');

        return sortBy === 'desc' ? scoreB - scoreA : scoreA - scoreB;
    });

    $cards.detach().appendTo($container);

    // אנימציה מחדש
    $cards.each(function (index) {
        $(this).css({
            'animation': 'none',
            'animation-delay': '0s'
        });

        setTimeout(function (card) {
            $(card).css({
                'animation': 'fadeInUp 0.5s ease',
                'animation-delay': (index * 0.1) + 's'
            });
        }, 10, this);
    });
}

// ייצוא לדוח
function exportToExcel() {
    var data = [];

    $('.replacement-card').each(function () {
        var $card = $(this);
        var row = {
            'שם': $card.find('.employee-name').text(),
            'תפקיד': $card.find('.employee-position').text(),
            'ציון': $card.data('score'),
            'סיבה': $card.find('.reason-text').text()
        };
        data.push(row);
    });

    // המרה ל-CSV
    var csv = 'data:text/csv;charset=utf-8,\uFEFF';
    csv += Object.keys(data[0]).join(',') + '\n';

    data.forEach(function (row) {
        csv += Object.values(row).join(',') + '\n';
    });

    // הורדה
    var encodedUri = encodeURI(csv);
    var link = document.createElement('a');
    link.setAttribute('href', encodedUri);
    link.setAttribute('download', 'ai_replacements_' + new Date().getTime() + '.csv');
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// עדכון אוטומטי כל דקה
var autoRefreshInterval;
function startAutoRefresh() {
    autoRefreshInterval = setInterval(function () {
        console.log('Auto refresh...');
        // כאן ניתן להוסיף AJAX לרענון התוצאות
        updateLastRefreshTime();
    }, 60000); // כל דקה
}

function stopAutoRefresh() {
    if (autoRefreshInterval) {
        clearInterval(autoRefreshInterval);
    }
}

function updateLastRefreshTime() {
    var now = new Date();
    var timeStr = now.toLocaleTimeString('he-IL');
    $('.last-update').text('עדכון אחרון: ' + timeStr);
}

// אנימציית פולס
$.fn.pulse = function () {
    return this.each(function () {
        var $el = $(this);
        $el.addClass('pulse-animation');

        setTimeout(function () {
            $el.removeClass('pulse-animation');
        }, 1000);
    });
};

// CSS דינמי לאנימציות
$('<style>')
    .prop('type', 'text/css')
    .html(`
        .pulse-animation {
            animation: pulse 0.5s ease !important;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .shake {
            animation: shake 0.5s;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }
    `)
    .appendTo('head');

// טעינה ראשונית
$(window).on('load', function () {
    animateScoreBars();
    // startAutoRefresh(); // אופציונלי
});