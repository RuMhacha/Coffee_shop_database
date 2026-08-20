from pathlib import Path

import matplotlib.pyplot as plt


# ---------------------------------------------------------
# Product-category revenue from the SQL analysis
# ---------------------------------------------------------

categories = [
    "Coffee",
    "Tea",
    "Bakery",
    "Drinking Chocolate",
    "Coffee Beans",
]

revenue = [
    269952.45,
    196405.95,
    82315.64,
    72416.00,
    40085.25,
]

shares = [
    38.63,
    28.11,
    11.78,
    10.36,
    5.74,
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

fig, ax = plt.subplots(figsize=(10, 7))

fig.patch.set_facecolor("white")
ax.set_facecolor("white")


# ---------------------------------------------------------
# Horizontal bars
# ---------------------------------------------------------

bars = ax.barh(
    categories,
    revenue,
    color=espresso,
    height=0.58,
)

ax.invert_yaxis()


# ---------------------------------------------------------
# Value labels
# ---------------------------------------------------------

for bar, value, share in zip(bars, revenue, shares):

    ax.text(
        bar.get_width() + 5000,
        bar.get_y() + bar.get_height() / 2,
        f"${value / 1000:.1f}K  |  {share:.1f}%",
        va="center",
        ha="left",
        fontsize=10.5,
        fontweight="bold",
        color=dark_text,
    )


# ---------------------------------------------------------
# Title and subtitle
# ---------------------------------------------------------

fig.suptitle(
    "Coffee and tea generate two-thirds of total revenue",
    fontsize=18,
    fontweight="bold",
    color=dark_text,
    y=0.96,
)

fig.text(
    0.5,
    0.91,
    "Core beverage categories dominate the product mix",
    ha="center",
    va="center",
    fontsize=11.5,
    color=dark_text,
)


# ---------------------------------------------------------
# Axes formatting
# ---------------------------------------------------------

ax.set_xlabel(
    "Revenue (USD)",
    fontsize=11,
    fontweight="bold",
    color=dark_text,
)

ax.set_xlim(0, 310000)

ax.tick_params(
    axis="both",
    labelsize=10,
)

ax.grid(
    axis="x",
    linestyle="--",
    linewidth=0.8,
    alpha=0.25,
)

ax.set_axisbelow(True)

ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["left"].set_visible(False)


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
    "Coffee and Tea contribute 66.7% of total revenue, making beverage\n"
    "availability and morning service capacity commercially critical.",
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
    left=0.22,
    right=0.94,
)


# ---------------------------------------------------------
# Save
# ---------------------------------------------------------

output_dir = Path(__file__).resolve().parents[1] / "images"
output_file = output_dir / "category_revenue.png"

plt.savefig(
    output_file,
    dpi=200,
    bbox_inches="tight",
    facecolor="white",
)

print(f"Chart saved to: {output_file}")

plt.close(fig)
