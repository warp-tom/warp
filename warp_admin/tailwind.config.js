/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                warp: {
                    blue: '#2563EB',
                    dark: '#0f172a',
                    light: '#f8fafc',
                    border: '#e2e8f0',
                    success: '#10b981',
                    warning: '#f59e0b',
                    danger: '#ef4444',
                }
            },
            fontFamily: {
                sans: ['Inter', 'sans-serif'],
            }
        },
    },
    plugins: [],
}
