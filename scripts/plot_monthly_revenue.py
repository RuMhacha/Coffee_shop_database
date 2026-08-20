from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter


# ---------------------------------------------------------
# Data from SQL analysis
# ---------------------------------------------------------

months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]

revenue = [
    81677.74,
    76145.19,
    98834.68,
    118941.08,
    156727.76,
    166485.88,
]

growth = [
    None,
    -6.77,
    29.80,
    20.34,
    31.77,
    6.23,
]


# ---------------------------------------------------------
# Coffee-shop colour palette
# ---------------------------------------------------------

espresso = "#6F3200"
dark_text = "#2D1B12"
positive = "#2E7D32"
negative = "#C62828"
takeaway_bg = "#F7F0E8"
takeaway_edge = "#D8C3AE"


# ---------------------------------------------------------
# Create figure
# ---------------------------------------------------------

fig, ax = plt.subplots(figsize=(11, 7))

fig.patch.set_facecolor("white")
ax.set_facecolor("white")


# ---------------------------------------------------------
# Main line
# ---------------------------------------------------------

ax.plot(
    months,
    revenue,
    marker="o",
    markersize=8,
    linewidth=2.6,
    color=espresso,
    markerfacecolor=espresso,
    markeredgecolor=espresso,
    zorder=3,
)


# ---------------------------------------------------------
# Data labels
# ---------------------------------------------------------

for month, value, pct in zip(months, revenue, growth):

    # Revenue value above the point
    ax.annotate(
        f"${value / 1000:.1f}K",
        xy=(month, value),
        xytext=(0, 28),
        textcoords="offset points",
        ha="center",
        va="bottom",
        fontsize=10,
        fontweight="bold",
        color=dark_text,
        zorder=5,
    )

    # Growth percentage just below the revenue value,
    # but still above the line
    if pct is not None:

        growth_colour = positive if pct >= 0 else negative

        ax.annotate(
            f"{pct:+.1f}%",
            xy=(month, value),
            xytext=(0, 12),
            textcoords="offset points",
            ha="center",
            va="bottom",
            fontsize=10,
            color=growth_colour,
            zorder=5,
        )


# ---------------------------------------------------------
# Title and subtitle
# ---------------------------------------------------------

fig.suptitle(
    "Monthly revenue accelerates after February",
    fontsize=20,
    fontweight="bold",
    color=dark_text,
    y=0.97,
)

fig.text(
    0.5,
    0.91,
    r"Revenue rises from \$76.1K in February to \$166.5K in June",
    ha="center",
    va="center",
    fontsize=12,
    color=dark_text,
)


# ---------------------------------------------------------
# Axes formatting
# ---------------------------------------------------------

ax.set_xlabel(
    "Month",
    fontsize=11,
    fontweight="bold",
    color=dark_text,
)

ax.set_ylabel(
    "Revenue (USD)",
    fontsize=11,
    fontweight="bold",
    color=dark_text,
)

ax.set_ylim(70000, 180000)

ax.yaxis.set_major_formatter(
    FuncFormatter(lambda value, _: f"{value / 1000:.0f}K")
)

ax.tick_params(
    axis="both",
    labelsize=10,
)

ax.grid(
    axis="y",
    linestyle="--",
    linewidth=0.8,
    alpha=0.25,
)

ax.grid(
    axis="x",
    visible=False,
)

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)


# ---------------------------------------------------------
# Key takeaway box
# ---------------------------------------------------------

fig.text(
    0.11,
    0.055,
    "Key takeaway:",
    fontsize=11,
    fontweight="bold",
    color=dark_text,
    ha="left",
    va="center",
)

fig.text(
    0.27,
    0.055,
    "After a February dip, revenue grew for four consecutive months,\n"
    "with particularly strong acceleration in March and May.",
    fontsize=10,
    color=dark_text,
    ha="left",
    va="center",
)

# Background box behind both takeaway texts
fig.patches.extend([
    plt.Rectangle(
        (0.10, 0.025),
        0.80,
        0.075,
        transform=fig.transFigure,
        facecolor=takeaway_bg,
        edgecolor=takeaway_edge,
        linewidth=1,
        zorder=-1,
    )
])


# ---------------------------------------------------------
# Layout
# ---------------------------------------------------------

plt.subplots_adjust(
    top=0.80,
    bottom=0.18,
    left=0.10,
    right=0.97,
)


# ---------------------------------------------------------
# Save
# ---------------------------------------------------------

output_dir = Path(__file__).resolve().parents[1] / "images"
output_file = output_dir / "monthly_revenue_trend.png"

plt.savefig(
    output_file,
    dpi=200,
    bbox_inches="tight",
    facecolor="white",
)

print(f"Chart saved to: {output_file}")

plt.close(fig)
