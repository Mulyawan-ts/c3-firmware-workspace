module main;

// Register Base GPIO ESP32-C3
const uintptr GPIO_BASE = 0x60004000;
const uint* GPIO_OUT_REG    = (uint*)(GPIO_BASE + 0x0004);
const uint* GPIO_ENABLE_REG = (uint*)(GPIO_BASE + 0x020);
const uint* GPIO_IN_REG     = (uint*)(GPIO_BASE + 0x003C);

// Alokasi Pin GPIO
const uint PIN_IN_A   = 4;
const uint PIN_IN_B   = 5;
const uint PIN_OUT_AND = 6;
const uint PIN_OUT_OR  = 7;
const uint PIN_OUT_XOR = 8;

fn void main()
{
    // Configure Pin Output (Set bit pada GPIO_ENABLE_REG)
    *GPIO_ENABLE_REG |= (1 << PIN_OUT_AND) | (1 << PIN_OUT_OR) | (1 << PIN_OUT_XOR);

    while (true)
    {
        // Read Inputs (Active-LOW karena terhubung ke GND via Button)
        uint in_reg = *GPIO_IN_REG;
        bool in_a = (in_reg & (1 << PIN_IN_A)) == 0;
        bool in_b = (in_reg & (1 << PIN_IN_B)) == 0;

        // Evaluasi Gerbang Logika
        bool out_and = in_a && in_b;
        bool out_or  = in_a || in_b;
        bool out_xor = in_a ^ in_b;

        // Reset bit output lama
        uint out_val = *GPIO_OUT_REG;
        out_val &= ~((1 << PIN_OUT_AND) | (1 << PIN_OUT_OR) | (1 << PIN_OUT_XOR));

        // Set bit output baru berdasarkan hasil logika
        if (out_and) out_val |= (1 << PIN_OUT_AND);
        if (out_or)  out_val |= (1 << PIN_OUT_OR);
        if (out_xor) out_val |= (1 << PIN_OUT_XOR);

        *GPIO_OUT_REG = out_val;
    }
}