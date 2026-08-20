from pathlib import Path

import matplotlib.pyplot as plt


# ---------------------------------------------------------
# Store revenue from the SQL analysis
# ---------------------------------------------------------

stores = [
    "Hell's Kitchen",
    "Astoria",
    "Lower Manhattan",
]

revenue = [
    236511.17,
    232243.91,
    230057.25,
]


# ---------------------------------------------------------
# Coffee-shop colour palette
# ---------------------------------------------------------

espresso = "#6F3200"
dark_text = "#2D1B12"
takeaway_bg = "#F7F0E8"
takeaway_edge = "#D8C3AE"


# ---------------------------------------------------------
# Create figure
# ---------------------------------------------------------

fig, ax = plt.subplots(figsize=(10, 6.5))

fig.patch.set_facecolor("white")
ax.set_facecolor("white")


# ---------------------------------------------------------
# Bars
# ---------------------------------------------------------

bars = ax.bar(
    stores,
    revenue,
    color=espresso,
    width=0.58,
)


# ---------------------------------------------------------
# Value labels
# ---------------------------------------------------------

for bar, value in zip(bars, revenue):
    ax.text(
        bar.get_x() + bar.get_width() / 2,
        bar.get_height() + 2500,
        f"${value / 1000:.1f}K",
        ha="center",
        va="bottom",
        fontsize=11,
        fontweight="bold",
        color=dark_text,
    )


# ---------------------------------------------------------
# Title and subtitle
# ---------------------------------------------------------

fig.suptitle(
    "Revenue is evenly distributed across the three stores",
    fontsize=18,
    fontweight="bold",
    color=dark_text,
    y=0.96,
)

fig.text(
    0.5,
    0.91,
    r"Hell's Kitchen leads, but no single location dominates total revenue",
    ha="center",
    va="center",
    fontsize=11.5,
    color=dark_text,
)


# ---------------------------------------------------------
# Axes formatting
# ---------------------------------------------------------

ax.set_ylabel(
    "Revenue (USD)",
    fontsize=11,
    fontweight="bold",
    color=dark_text,
)

ax.set_ylim(0, 260000)

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

ax.set_axisbelow(True)

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)


# ---------------------------------------------------------
# Key takeaway box
# ---------------------------------------------------------

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

fig.text(
    0.12,
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
    "Store performance is balanced, reducing reliance on a single location\n"
    "and suggesting broadly consistent demand across the network.",
    fontsize=10,
    color=dark_text,
    ha="left",
    va="center",
)


# ---------------------------------------------------------
# Layout
# ---------------------------------------------------------

plt.subplots_adjust(
    top=0.80,
    bottom=0.18,
    left=0.11,
    right=0.97,
)


# ---------------------------------------------------------
# Save
# ---------------------------------------------------------

output_dir = Path(__file__).resolve().parents[1] / "images"
output_file = output_dir / "store_revenue_comparison.png"

plt.savefig(
    output_file,
    dpi=200,
    bbox_inches="tight",
    facecolor="white",
)

print(f"Chart saved to: {output_file}")

plt.close(fig)
