module SDPMem #(
    parameter SPRITE_WIDTH = 8, // Sprite width (8 pixels)
    parameter SPRITE_HEIGHT = 8, // Sprite height (8 pixels)
    parameter NUM_SPRITES = 8 // Number of different sprites stored
)(
    input wire clk, // System clock
    input wire reset, // Reset signal
    input wire [$clog2(NUM_SPRITES*SPRITE_WIDTH*SPRITE_HEIGHT)-1:0] wr_addr, // Write address
    input wire [$clog2(NUM_SPRITES*SPRITE_WIDTH*SPRITE_HEIGHT)-1:0] rd_addr, // Read address
    input wire data_in, // Data input (1-bit per pixel)
    output reg data_out // Data output (1-bit per pixel)
);

    // Memory storage for sprite bitmaps
    reg sprite_memory [0:NUM_SPRITES*SPRITE_WIDTH*SPRITE_HEIGHT-1];

    // Predefined sprite data
    initial begin
        // Sprite 0: C
        sprite_memory[0] = 1; sprite_memory[1] = 1; sprite_memory[2] = 1; sprite_memory[3] = 0;
        sprite_memory[4] = 0; sprite_memory[5] = 0; sprite_memory[6] = 1; sprite_memory[7] = 1;
        sprite_memory[8] = 1; sprite_memory[9] = 0; sprite_memory[10] = 0; sprite_memory[11] = 0;
        sprite_memory[12] = 0; sprite_memory[13] = 0; sprite_memory[14] = 0; sprite_memory[15] = 1;
        sprite_memory[16] = 1; sprite_memory[17] = 0; sprite_memory[18] = 0; sprite_memory[19] = 0;
        sprite_memory[20] = 0; sprite_memory[21] = 0; sprite_memory[22] = 0; sprite_memory[23] = 1;
        sprite_memory[24] = 1; sprite_memory[25] = 0; sprite_memory[26] = 0; sprite_memory[27] = 0;
        sprite_memory[28] = 0; sprite_memory[29] = 0; sprite_memory[30] = 0; sprite_memory[31] = 1;
        sprite_memory[32] = 1; sprite_memory[33] = 0; sprite_memory[34] = 0; sprite_memory[35] = 0;
        sprite_memory[36] = 0; sprite_memory[37] = 0; sprite_memory[38] = 0; sprite_memory[39] = 1;
        sprite_memory[40] = 1; sprite_memory[41] = 1; sprite_memory[42] = 1; sprite_memory[43] = 0;
        sprite_memory[44] = 0; sprite_memory[45] = 0; sprite_memory[46] = 1; sprite_memory[47] = 1;

        // Sprite 1: D
        sprite_memory[48] = 1; sprite_memory[49] = 1; sprite_memory[50] = 1; sprite_memory[51] = 0;
        sprite_memory[52] = 0; sprite_memory[53] = 0; sprite_memory[54] = 1; sprite_memory[55] = 0;
        sprite_memory[56] = 1; sprite_memory[57] = 0; sprite_memory[58] = 0; sprite_memory[59] = 1;
        sprite_memory[60] = 0; sprite_memory[61] = 0; sprite_memory[62] = 0; sprite_memory[63] = 1;
        sprite_memory[64] = 1; sprite_memory[65] = 0; sprite_memory[66] = 0; sprite_memory[67] = 0;
        sprite_memory[68] = 0; sprite_memory[69] = 0; sprite_memory[70] = 0; sprite_memory[71] = 1;
        sprite_memory[72] = 1; sprite_memory[73] = 0; sprite_memory[74] = 0; sprite_memory[75] = 0;
        sprite_memory[76] = 0; sprite_memory[77] = 0; sprite_memory[78] = 0; sprite_memory[79] = 1;
        sprite_memory[80] = 1; sprite_memory[81] = 0; sprite_memory[82] = 0; sprite_memory[83] = 1;
        sprite_memory[84] = 0; sprite_memory[85] = 0; sprite_memory[86] = 0; sprite_memory[87] = 1;
        sprite_memory[88] = 1; sprite_memory[89] = 1; sprite_memory[90] = 1; sprite_memory[91] = 0;
        sprite_memory[92] = 0; sprite_memory[93] = 0; sprite_memory[94] = 1; sprite_memory[95] = 0;

        // Sprite 2: E
        sprite_memory[96] = 1; sprite_memory[97] = 1; sprite_memory[98] = 1; sprite_memory[99] = 1;
        sprite_memory[100] = 0; sprite_memory[101] = 0; sprite_memory[102] = 0; sprite_memory[103] = 0;
        sprite_memory[104] = 1; sprite_memory[105] = 0; sprite_memory[106] = 0; sprite_memory[107] = 0;
        sprite_memory[108] = 0; sprite_memory[109] = 0; sprite_memory[110] = 0; sprite_memory[111] = 0;
        sprite_memory[112] = 1; sprite_memory[113] = 1; sprite_memory[114] = 1; sprite_memory[115] = 0;
        sprite_memory[116] = 0; sprite_memory[117] = 0; sprite_memory[118] = 0; sprite_memory[119] = 0;
        sprite_memory[120] = 1; sprite_memory[121] = 0; sprite_memory[122] = 0; sprite_memory[123] = 0;
        sprite_memory[124] = 0; sprite_memory[125] = 0; sprite_memory[126] = 0; sprite_memory[127] = 0;
        sprite_memory[128] = 1; sprite_memory[129] = 0; sprite_memory[130] = 0; sprite_memory[131] = 0;
        sprite_memory[132] = 0; sprite_memory[133] = 0; sprite_memory[134] = 0; sprite_memory[135] = 0;
        sprite_memory[136] = 1; sprite_memory[137] = 1; sprite_memory[138] = 1; sprite_memory[139] = 1;
        sprite_memory[140] = 0; sprite_memory[141] = 0; sprite_memory[142] = 0; sprite_memory[143] = 0;

        // Sprite 3: F
        sprite_memory[144] = 1; sprite_memory[145] = 1; sprite_memory[146] = 1; sprite_memory[147] = 1;
        sprite_memory[148] = 0; sprite_memory[149] = 0; sprite_memory[150] = 0; sprite_memory[151] = 0;
        sprite_memory[152] = 1; sprite_memory[153] = 0; sprite_memory[154] = 0; sprite_memory[155] = 0;
        sprite_memory[156] = 0; sprite_memory[157] = 0; sprite_memory[158] = 0; sprite_memory[159] = 0;
        sprite_memory[160] = 1; sprite_memory[161] = 1; sprite_memory[162] = 1; sprite_memory[163] = 0;
        sprite_memory[164] = 0; sprite_memory[165] = 0; sprite_memory[166] = 0; sprite_memory[167] = 0;
        sprite_memory[168] = 1; sprite_memory[169] = 0; sprite_memory[170] = 0; sprite_memory[171] = 0;
        sprite_memory[172] = 0; sprite_memory[173] = 0; sprite_memory[174] = 0; sprite_memory[175] = 0;
        sprite_memory[176] = 1; sprite_memory[177] = 0; sprite_memory[178] = 0; sprite_memory[179] = 0;
        sprite_memory[180] = 0; sprite_memory[181] = 0; sprite_memory[182] = 0; sprite_memory[183] = 0;
        sprite_memory[184] = 1; sprite_memory[185] = 0; sprite_memory[186] = 0; sprite_memory[187] = 0;
        sprite_memory[188] = 0; sprite_memory[189] = 0; sprite_memory[190] = 0; sprite_memory[191] = 0;
        sprite_memory[192] = 1; sprite_memory[193] = 0; sprite_memory[194] = 0; sprite_memory[195] = 0;
        sprite_memory[196] = 0; sprite_memory[197] = 0; sprite_memory[198] = 0; sprite_memory[199] = 0;

        // Sprite 4: G
        sprite_memory[200] = 0; sprite_memory[201] = 1; sprite_memory[202] = 1; sprite_memory[203] = 1;
        sprite_memory[204] = 1; sprite_memory[205] = 0; sprite_memory[206] = 0; sprite_memory[207] = 0;
        sprite_memory[208] = 1; sprite_memory[209] = 0; sprite_memory[210] = 0; sprite_memory[211] = 0;
        sprite_memory[212] = 0; sprite_memory[213] = 1; sprite_memory[214] = 1; sprite_memory[215] = 1;
        sprite_memory[216] = 1; sprite_memory[217] = 0; sprite_memory[218] = 0; sprite_memory[219] = 0;
        sprite_memory[220] = 0; sprite_memory[221] = 1; sprite_memory[222] = 1; sprite_memory[223] = 1;
        sprite_memory[224] = 1; sprite_memory[225] = 1; sprite_memory[226] = 1; sprite_memory[227] = 0;
        sprite_memory[228] = 0; sprite_memory[229] = 0; sprite_memory[230] = 1; sprite_memory[231] = 1;
        sprite_memory[232] = 0; sprite_memory[233] = 1; sprite_memory[234] = 0; sprite_memory[235] = 0;
        sprite_memory[236] = 0; sprite_memory[237] = 0; sprite_memory[238] = 0; sprite_memory[239] = 0;

        // Sprite 5: A
        sprite_memory[240] = 0; sprite_memory[241] = 0; sprite_memory[242] = 1; sprite_memory[243] = 1;
        sprite_memory[244] = 1; sprite_memory[245] = 0; sprite_memory[246] = 0; sprite_memory[247] = 0;
        sprite_memory[248] = 1; sprite_memory[249] = 0; sprite_memory[250] = 0; sprite_memory[251] = 1;
        sprite_memory[252] = 0; sprite_memory[253] = 1; sprite_memory[254] = 1; sprite_memory[255] = 0;
        sprite_memory[256] = 1; sprite_memory[257] = 0; sprite_memory[258] = 0; sprite_memory[259] = 0;
        sprite_memory[260] = 0; sprite_memory[261] = 1; sprite_memory[262] = 1; sprite_memory[263] = 0;
        sprite_memory[264] = 1; sprite_memory[265] = 0; sprite_memory[266] = 0; sprite_memory[267] = 0;
        sprite_memory[268] = 0; sprite_memory[269] = 1; sprite_memory[270] = 1; sprite_memory[271] = 0;
        sprite_memory[272] = 1; sprite_memory[273] = 1; sprite_memory[274] = 1; sprite_memory[275] = 1;
        sprite_memory[276] = 1; sprite_memory[277] = 1; sprite_memory[278] = 1; sprite_memory[279] = 1;

        // Sprite 6: B
        sprite_memory[280] = 1; sprite_memory[281] = 1; sprite_memory[282] = 1; sprite_memory[283] = 0;
        sprite_memory[284] = 0; sprite_memory[285] = 0; sprite_memory[286] = 1; sprite_memory[287] = 0;
        sprite_memory[288] = 1; sprite_memory[289] = 0; sprite_memory[290] = 0; sprite_memory[291] = 0;
        sprite_memory[292] = 0; sprite_memory[293] = 0; sprite_memory[294] = 1; sprite_memory[295] = 0;
        sprite_memory[296] = 1; sprite_memory[297] = 1; sprite_memory[298] = 1; sprite_memory[299] = 0;
        sprite_memory[300] = 0; sprite_memory[301] = 0; sprite_memory[302] = 1; sprite_memory[303] = 0;
        sprite_memory[304] = 1; sprite_memory[305] = 1; sprite_memory[306] = 1; sprite_memory[307] = 0;
        sprite_memory[308] = 0; sprite_memory[309] = 0; sprite_memory[310] = 1; sprite_memory[311] = 0;
        sprite_memory[312] = 1; sprite_memory[313] = 0; sprite_memory[314] = 0; sprite_memory[315] = 0;
        sprite_memory[316] = 0; sprite_memory[317] = 0; sprite_memory[318] = 1; sprite_memory[319] = 0;

        // Sprite 7: High C
        sprite_memory[320] = 0; sprite_memory[321] = 1; sprite_memory[322] = 1; sprite_memory[323] = 1;
        sprite_memory[324] = 0; sprite_memory[325] = 0; sprite_memory[326] = 1; sprite_memory[327] = 0;
        sprite_memory[328] = 1; sprite_memory[329] = 0; sprite_memory[330] = 0; sprite_memory[331] = 0;
        sprite_memory[332] = 0; sprite_memory[333] = 0; sprite_memory[334] = 0; sprite_memory[335] = 1;
        sprite_memory[336] = 1; sprite_memory[337] = 0; sprite_memory[338] = 0; sprite_memory[339] = 0;
        sprite_memory[340] = 0; sprite_memory[341] = 0; sprite_memory[342] = 0; sprite_memory[343] = 1;
        sprite_memory[344] = 1; sprite_memory[345] = 0; sprite_memory[346] = 0; sprite_memory[347] = 0;
        sprite_memory[348] = 0; sprite_memory[349] = 0; sprite_memory[350] = 0; sprite_memory[351] = 1;
        sprite_memory[352] = 1; sprite_memory[353] = 0; sprite_memory[354] = 0; sprite_memory[355] = 0;
        sprite_memory[356] = 0; sprite_memory[357] = 0; sprite_memory[358] = 0; sprite_memory[359] = 1;
        sprite_memory[360] = 1; sprite_memory[361] = 1; sprite_memory[362] = 1; sprite_memory[363] = 0;
        sprite_memory[364] = 0; sprite_memory[365] = 0; sprite_memory[366] = 1; sprite_memory[367] = 0;
    end

    // Read operation (for rendering)
    always @(posedge clk) begin
        data_out <= sprite_memory[rd_addr];
    end

endmodule