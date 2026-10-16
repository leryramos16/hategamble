package com.hategamble.hategamble

import android.app.Activity
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Calm interstitial shown when the blocker stops a gambling app or site.
 * Built in code (no Flutter engine) so it appears instantly.
 */
class BlockedActivity : Activity() {

    companion object {
        const val EXTRA_TYPE = "type"
        const val EXTRA_TARGET = "target"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        render(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        render(intent)
    }

    private fun dp(v: Int) = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP, v.toFloat(), resources.displayMetrics
    ).toInt()

    private fun render(intent: Intent) {
        // Normal mode: hand straight off to the Flutter urge flow. Because this
        // start comes from a foreground activity, Android brings it to the front
        // reliably (unlike a start from the background service). The urge screen
        // itself reminds the user why they're quitting.
        if (!BlockerStore.isDiscreet(this)) {
            // REORDER_TO_FRONT reliably brings the existing app to the foreground on
            // Android 12+ (a plain start from the background does not). It does not
            // deliver a new intent, so the route is left as a pending route that
            // MainActivity reads in onResume.
            BlockerStore.setPendingRoute(this, "/sos")
            startActivity(
                Intent(this, MainActivity::class.java)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
            )
            finish()
            return
        }

        // Discreet mode: a neutral screen that names nothing and links to no app.
        val dark = (resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) ==
            Configuration.UI_MODE_NIGHT_YES
        val bg = if (dark) Color.parseColor("#1A1512") else Color.WHITE
        val fg = if (dark) Color.parseColor("#F0E5DB") else Color.parseColor("#2B211A")
        val muted = if (dark) Color.parseColor("#C9B9AB") else Color.parseColor("#6F6056")
        val accent = if (dark) Color.parseColor("#F5C08F") else Color.parseColor("#CC7F40")
        val onAccent = if (dark) Color.parseColor("#452408") else Color.parseColor("#3A2112")

        window.statusBarColor = bg
        window.navigationBarColor = bg

        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(bg)
            setPadding(dp(32), dp(48), dp(32), dp(48))
        }

        fun text(s: String, size: Float, color: Int, bold: Boolean = false, top: Int = 0) =
            TextView(this).apply {
                this.text = s
                textSize = size
                setTextColor(color)
                gravity = Gravity.CENTER
                if (bold) setTypeface(typeface, android.graphics.Typeface.BOLD)
                layoutParams = LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT).apply { topMargin = dp(top) }
            }

        fun button(s: String, filled: Boolean, top: Int, onClick: () -> Unit) = Button(this).apply {
            text = s
            isAllCaps = false
            textSize = 16f
            stateListAnimator = null
            setTextColor(if (filled) onAccent else accent)
            background = GradientDrawable().apply {
                cornerRadius = dp(28).toFloat()
                if (filled) setColor(accent) else {
                    setColor(Color.TRANSPARENT); setStroke(dp(1), accent)
                }
            }
            layoutParams = LinearLayout.LayoutParams(MATCH_PARENT, dp(52)).apply { topMargin = dp(top) }
            setOnClickListener { onClick() }
        }

        val fil = BlockerStore.language(this) == "fil"
        root.addView(text(if (fil) "Hindi available" else "Not available", 26f, fg, bold = true))
        root.addView(text(
            if (fil) "Hindi ma-access ang page na ito sa device na ito."
            else "This page can't be opened on this device.",
            16f, muted, top = 12,
        ))
        root.addView(button(if (fil) "Isara" else "Close", filled = true, top = 40) { goHome() })
        setContentView(root)
    }

    private fun goHome() {
        startActivity(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        finish()
    }

    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        goHome()
    }
}
