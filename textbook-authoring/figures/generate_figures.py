"""
Textbook Authoring System — Figure Generator
로그 교재용 그림 4개 생성
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyArrowPatch
import matplotlib.gridspec as gridspec

# ── 공통 스타일 설정 ─────────────────────────────────────────
PRIMARY   = '#1A3A5C'
SECONDARY = '#2E7BAE'
ACCENT    = '#3AAFA9'
WARN      = '#F0A500'
LIGHT     = '#F0F7FF'
RED       = '#C0392B'

import matplotlib.font_manager as fm
# Noto Sans CJK KR 경로 직접 지정
_font_candidates = [
    '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
    '/usr/share/fonts/opentype/noto/NotoSansCJKkr-Regular.otf',
]
_font_path = next((p for p in _font_candidates if __import__('os').path.exists(p)), None)
if _font_path:
    fm.fontManager.addfont(_font_path)
    _prop = fm.FontProperties(fname=_font_path)
    _fname = _prop.get_name()
else:
    _fname = 'DejaVu Sans'

plt.rcParams.update({
    'font.family': _fname,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'axes.grid': True,
    'grid.alpha': 0.3,
    'grid.linestyle': '--',
    'figure.dpi': 150,
})

# ══════════════════════════════════════════════════════════════
# 그림 1: 선형 vs 로그 스케일 — 세균 증식
# ══════════════════════════════════════════════════════════════
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(11, 4.5))
fig.patch.set_facecolor('white')

t = np.linspace(0, 10, 300)
N0 = 100
g  = 0.5          # 세대 시간 (시간)
N  = N0 * 2**(t / g)

# 선형 스케일
ax1.plot(t, N, color=SECONDARY, linewidth=2.5)
ax1.fill_between(t, N, alpha=0.08, color=SECONDARY)
ax1.set_xlabel('시간 (시간)', fontsize=11)
ax1.set_ylabel('세균 수 (CFU/mL)', fontsize=11)
ax1.set_title('선형 스케일 (Linear Scale)', fontsize=12, fontweight='bold', color=PRIMARY)
ax1.annotate('처음 몇 시간이\n전혀 보이지 않음',
             xy=(2, N0*2**(2/g)), xytext=(5, 5e5),
             arrowprops=dict(arrowstyle='->', color=RED, lw=1.5),
             fontsize=9, color=RED,
             bbox=dict(boxstyle='round,pad=0.3', facecolor='#FFE8E8', edgecolor=RED))
ax1.yaxis.set_major_formatter(plt.FuncFormatter(lambda x, _: f'{x/1e6:.0f}M' if x >= 1e6 else f'{x:.0f}'))
ax1.set_facecolor(LIGHT)

# 로그 스케일
ax2.semilogy(t, N, color=ACCENT, linewidth=2.5)
ax2.fill_between(t, N, 1, alpha=0.08, color=ACCENT)
ax2.set_xlabel('시간 (시간)', fontsize=11)
ax2.set_ylabel('세균 수 (CFU/mL) — log scale', fontsize=11)
ax2.set_title('로그 스케일 (Log Scale)', fontsize=12, fontweight='bold', color=PRIMARY)

# 세대 시간 표시 (기울기 = 일정)
x1, x2 = 3, 5
ax2.annotate('', xy=(x2, N0*2**(x2/g)), xytext=(x1, N0*2**(x1/g)),
             arrowprops=dict(arrowstyle='<->', color=WARN, lw=2))
ax2.text(4.2, N0*2**(4/g)*1.8, '기울기 = 세대 시간\n(일정한 직선!)',
         fontsize=9, color=WARN, fontweight='bold',
         bbox=dict(boxstyle='round,pad=0.3', facecolor='#FFF8E7', edgecolor=WARN))
ax2.set_facecolor(LIGHT)

fig.suptitle('세균 증식: 같은 데이터, 다른 스케일', fontsize=13, fontweight='bold', color=PRIMARY, y=1.01)
plt.tight_layout()
plt.savefig('fig1_linear_vs_log.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.close()
print("fig1 saved")

# ══════════════════════════════════════════════════════════════
# 그림 2: pH 스케일 — 생체 예시
# ══════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(11, 3.5))
fig.patch.set_facecolor('white')

# pH 색상 그라디언트 (산성=빨강 → 중성=초록 → 염기=파랑)
cmap = plt.cm.RdYlGn
pH_vals = np.linspace(0, 14, 500)
colors  = [cmap(v/14) for v in pH_vals]

for i in range(len(pH_vals)-1):
    ax.barh(0, 1, left=pH_vals[i], height=0.6, color=colors[i], edgecolor='none')

# 주요 생체 pH 표시
examples = [
    (1.5,  '위산\n(1.5)',     -0.55),
    (4.5,  '피부\n(4.5)',     -0.55),
    (5.5,  '소변\n(5.5)',      0.55),
    (7.0,  '순수한 물\n(7.0)', -0.55),
    (7.4,  '혈액\n(7.4)',      0.55),
    (8.0,  '소장\n(8.0)',     -0.55),
    (11.5, '락스\n(11.5)',    -0.55),
]

for ph, label, yoff in examples:
    ax.annotate('', xy=(ph, 0.3 if yoff > 0 else -0.3),
                xytext=(ph, 0.3 + yoff if yoff > 0 else -0.3 + yoff),
                arrowprops=dict(arrowstyle='->', color='#333', lw=1.2))
    ax.text(ph, 0.3 + yoff + (0.08 if yoff > 0 else -0.08), label,
            ha='center', va='bottom' if yoff > 0 else 'top',
            fontsize=8.5, fontweight='bold', color='#222')

ax.set_xlim(-0.3, 14.3)
ax.set_ylim(-1.1, 1.1)
ax.set_xlabel('pH', fontsize=12, fontweight='bold')
ax.set_xticks(range(0, 15))
ax.set_yticks([])
ax.spines['left'].set_visible(False)
ax.spines['bottom'].set_position(('data', 0))

# 산성/중성/염기성 라벨
ax.text(2,   0.85, '산성 (Acidic)',   ha='center', fontsize=10, color='#C0392B', fontweight='bold')
ax.text(7,   0.85, '중성 (Neutral)',  ha='center', fontsize=10, color='#27AE60', fontweight='bold')
ax.text(11.5,0.85, '염기성 (Basic)',  ha='center', fontsize=10, color='#2980B9', fontweight='bold')

# pH 1 차이 = 10배 설명
ax.annotate('', xy=(8.4, -0.72), xytext=(7.4, -0.72),
            arrowprops=dict(arrowstyle='<->', color=PRIMARY, lw=1.5))
ax.text(7.9, -0.88, 'pH 1 차이\n= 농도 10배 차이', ha='center', fontsize=8, color=PRIMARY)

ax.set_title('pH 스케일: 로그로 압축한 수소 이온 농도', fontsize=12, fontweight='bold', color=PRIMARY, pad=12)
ax.set_facecolor('white')
ax.grid(False)

plt.tight_layout()
plt.savefig('fig2_pH_scale.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.close()
print("fig2 saved")

# ══════════════════════════════════════════════════════════════
# 그림 3: 약물 농도 감소 곡선 (약물동력학)
# ══════════════════════════════════════════════════════════════
fig, ax = plt.subplots(figsize=(9, 5))
fig.patch.set_facecolor('white')

t   = np.linspace(0, 24, 500)
C0  = 10.0
k   = 0.693 / 4     # 반감기 4시간
C   = C0 * np.exp(-k * t)
MIC = 0.5

ax.plot(t, C, color=SECONDARY, linewidth=2.8, label=r'$C_t = C_0 \cdot e^{-kt}$')
ax.fill_between(t, C, MIC, where=(C >= MIC), alpha=0.15, color=ACCENT, label='치료 유효 구간')
ax.fill_between(t, C, MIC, where=(C < MIC),  alpha=0.12, color=RED,   label='MIC 이하 (효과 소멸)')
ax.axhline(MIC, color=RED, linewidth=1.8, linestyle='--', label=f'MIC = {MIC} μg/mL')

# MIC 도달 시점 표시
t_mic = np.log(C0 / MIC) / k   # ≈ 17.3 hr
ax.axvline(t_mic, color=WARN, linewidth=1.5, linestyle=':')
ax.annotate(f't ≈ {t_mic:.1f} hr\n(효과 소멸)',
            xy=(t_mic, MIC), xytext=(t_mic + 1.5, 1.5),
            arrowprops=dict(arrowstyle='->', color=WARN, lw=1.5),
            fontsize=9.5, color=WARN, fontweight='bold',
            bbox=dict(boxstyle='round,pad=0.3', facecolor='#FFF8E7', edgecolor=WARN))

# 반감기 표시
for i in range(1, 4):
    th = 4 * i
    ch = C0 / (2**i)
    ax.plot([th, th], [0, ch], color='gray', linewidth=0.8, linestyle=':')
    ax.plot([0, th],  [ch, ch], color='gray', linewidth=0.8, linestyle=':')
    ax.text(th + 0.2, ch + 0.2, f'$t_{{1/2}} \\times {i}$\n= {ch:.2f}', fontsize=7.5, color='gray')

ax.set_xlabel('시간 (hr)', fontsize=12)
ax.set_ylabel('혈중 농도 (μg/mL)', fontsize=12)
ax.set_title('항생제 혈중 농도 감소 (1차 반응, $t_{1/2}$ = 4 hr)', fontsize=12, fontweight='bold', color=PRIMARY)
ax.legend(loc='upper right', fontsize=9, framealpha=0.9)
ax.set_xlim(0, 24)
ax.set_ylim(0, 11)
ax.set_facecolor(LIGHT)

plt.tight_layout()
plt.savefig('fig3_drug_kinetics.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.close()
print("fig3 saved")

# ══════════════════════════════════════════════════════════════
# 그림 4: 로그 함수 — 핵심 성질 시각화
# ══════════════════════════════════════════════════════════════
fig, axes = plt.subplots(1, 2, figsize=(11, 4.5))
fig.patch.set_facecolor('white')

# 왼쪽: y = log₁₀(x) 와 y = 10^x 비교
ax = axes[0]
x_log = np.linspace(0.01, 10, 400)
x_exp = np.linspace(-1, 1, 400)

ax.plot(x_log, np.log10(x_log), color=SECONDARY, linewidth=2.5, label=r'$y = \log_{10}(x)$')
ax.plot(10**x_exp, x_exp,       color=ACCENT,    linewidth=2.5, linestyle='--', label=r'$y = 10^x$ (역함수)')
ax.plot([0.01, 10], [0.01, 10], color='gray',    linewidth=1,   linestyle=':', label='$y = x$')
ax.axhline(0, color='black', linewidth=0.8)
ax.axvline(1, color=RED, linewidth=1, linestyle=':', alpha=0.5)
ax.text(1.1, -0.7, '$\log_{10}(1)=0$', fontsize=9, color=RED)

# 핵심 점 표시
for xv, yv in [(10, 1), (100, 2), (0.1, -1)]:
    ax.plot(xv, yv, 'o', color=PRIMARY, markersize=6, zorder=5)
    ax.annotate(f'({xv}, {yv})', xy=(xv, yv), xytext=(xv+0.3, yv+0.15), fontsize=8, color=PRIMARY)

ax.set_xlim(-0.5, 10.5)
ax.set_ylim(-1.5, 2.5)
ax.set_xlabel('$x$', fontsize=12)
ax.set_ylabel('$y$', fontsize=12)
ax.set_title('로그와 지수: 역함수 관계', fontsize=11, fontweight='bold', color=PRIMARY)
ax.legend(fontsize=9)
ax.set_facecolor(LIGHT)

# 오른쪽: 곱셈 → 덧셈 시각화
ax2 = axes[1]
ax2.set_facecolor(LIGHT)
ax2.axis('off')
ax2.set_xlim(0, 10)
ax2.set_ylim(0, 10)

ax2.text(5, 9.2, '핵심 성질: 곱셈 → 덧셈', ha='center', fontsize=12, fontweight='bold', color=PRIMARY)

props = dict(boxstyle='round,pad=0.5', facecolor='white', edgecolor=SECONDARY, linewidth=1.5)
eq_props = dict(boxstyle='round,pad=0.5', facecolor='#EFF9F8', edgecolor=ACCENT, linewidth=2)

# 행 1: 수 세계
ax2.text(5, 7.8, '수(Number) 세계', ha='center', fontsize=10, color='gray')
ax2.text(2.5, 7.0, '100', ha='center', fontsize=14, fontweight='bold', color=SECONDARY, bbox=props)
ax2.text(5.0, 7.0, '×', ha='center', fontsize=14, color='gray')
ax2.text(7.5, 7.0, '1,000', ha='center', fontsize=14, fontweight='bold', color=SECONDARY, bbox=props)
ax2.annotate('', xy=(5, 5.8), xytext=(5, 6.4),
             arrowprops=dict(arrowstyle='->', color=PRIMARY, lw=2.5))
ax2.text(5.3, 6.1, 'log₁₀', fontsize=9, color=PRIMARY, fontstyle='italic')
ax2.text(5, 5.2, '= 100,000', ha='center', fontsize=13, fontweight='bold', color=RED, bbox=props)

# 행 2: 로그 세계
ax2.text(5, 4.2, '로그(Log) 세계', ha='center', fontsize=10, color='gray')
ax2.text(2.5, 3.4, '2', ha='center', fontsize=14, fontweight='bold', color=ACCENT, bbox=eq_props)
ax2.text(5.0, 3.4, '+', ha='center', fontsize=14, color='gray')
ax2.text(7.5, 3.4, '3', ha='center', fontsize=14, fontweight='bold', color=ACCENT, bbox=eq_props)
ax2.text(5, 2.5, '= 5', ha='center', fontsize=13, fontweight='bold', color=RED, bbox=eq_props)
ax2.annotate('', xy=(5, 1.8), xytext=(5, 2.1),
             arrowprops=dict(arrowstyle='->', color=PRIMARY, lw=2.5))
ax2.text(5.3, 1.95, '10^x', fontsize=9, color=PRIMARY, fontstyle='italic')
ax2.text(5, 1.2, '10⁵ = 100,000', ha='center', fontsize=11, color=SECONDARY)

ax2.text(5, 0.4, 'log(A × B) = log A + log B', ha='center', fontsize=9.5,
         color=PRIMARY, fontstyle='italic',
         bbox=dict(boxstyle='round,pad=0.4', facecolor='#F0F7FF', edgecolor=PRIMARY))

fig.suptitle('로그 함수의 핵심 원리', fontsize=13, fontweight='bold', color=PRIMARY)
plt.tight_layout()
plt.savefig('fig4_log_properties.png', dpi=150, bbox_inches='tight', facecolor='white')
plt.close()
print("fig4 saved")

print("\n모든 그림 생성 완료!")
